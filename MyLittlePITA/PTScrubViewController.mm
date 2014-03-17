//
//  PTScrubViewController.m
//  MyLittlePITA
//
//  Created by Jacob Stern on 3/16/14.
//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import "PTScrubViewController.h"
#import "PTLog.h"

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

#include "JSOpenGLShaderProgram.h"

#include <iostream>

static const char kTextureQuadVertexSource[] =
    "precision mediump float;                                   "
    "                                                           "
    "attribute vec3 position;                                   "
    "attribute vec2 texcoord;                                   "
    "varying vec2 uv;                                           "
    "                                                           "
    "void main() {                                              "
    "    uv = texcoord;                                         "
    "    gl_Position = vec4(position, 1);                       "
    "}                                                          ";

static const char kTextureQuadFragmentSource[] =
    "precision mediump float;                                   "
    "                                                           "
    "varying vec2 uv;                                           "
    "uniform sampler2D texture;                                 "
    "                                                           "
    "void main() {                                              "
    "   gl_FragColor =  texture2D(texture, uv);                 "
    "}                                                          ";


@interface PTScrubViewController () {
    EAGLContext *_context;
    
    float _screenWidth;
    float _screenHeight;
    
    GLKTextureInfo *_texture;
    
    js::OpenGLShaderProgram _textureQuadProgram;
}

- (void)setupGL;
- (void)teardownGL;

- (void)drawTextureQuad;

@end

@implementation PTScrubViewController

- (void)viewDidLoad {
    // From https://developer.apple.com/library/ios/samplecode/GLCameraRipple/
    
    [super viewDidLoad];
    
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!_context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = _context;
    self.preferredFramesPerSecond = 60;
    
    _screenWidth = [UIScreen mainScreen].bounds.size.width;
    _screenHeight = [UIScreen mainScreen].bounds.size.height;
    view.contentScaleFactor = [UIScreen mainScreen].scale;
    
    view.opaque = NO;
    
    [self setupGL];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    [self teardownGL];
}

- (void)setupGL {
    [EAGLContext setCurrentContext:_context];
    
    NSString *imagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"sprite_happy.png"];
    GLKTextureLoader *textureLoader = [[GLKTextureLoader alloc] initWithSharegroup:_context.sharegroup];
    [textureLoader textureWithContentsOfFile:imagePath options:NULL queue:NULL completionHandler:^(GLKTextureInfo *textureInfo, NSError *outError) {
        if (outError) {
            DDLogError(@"Error loading scrubbing texture: %@", outError);
        }
        
        _texture = textureInfo;
    }];

    _textureQuadProgram.setVertexSource(kTextureQuadVertexSource);
    _textureQuadProgram.setFragmentSource(kTextureQuadFragmentSource);
    
    if (_textureQuadProgram.initialize()) {
        std::string reason = _textureQuadProgram.getErrorLog();
        DDLogError(@"Error creating scrub shader program: %s", reason.c_str());
        
        return;
    }
 
    glUniform1i(_textureQuadProgram.getUniformLocation("texture"), 0);
}

- (void)teardownGL {
}

- (void)drawTextureQuad {
    JS_USING(&_textureQuadProgram) {
        
        // From http://stackoverflow.com/questions/13455590/opengl-es-2-0-textured-quad
        
        glEnableClientState(GL_VERTEX_ARRAY);
        
        const float quadPositions[] = {  1.0,  1.0, 0.0,
            -1.0,  1.0, 0.0,
            -1.0, -1.0, 0.0,
            -1.0, -1.0, 0.0,
            1.0, -1.0, 0.0,
            1.0,  1.0, 0.0 };
        const float quadTexcoords[] = { 1.0, 0.0,
            0.0, 0.0,
            0.0, 1.0,
            0.0, 1.0,
            1.0, 1.0,
            1.0, 0.0 };
        
        glBindBuffer(GL_ARRAY_BUFFER, 0);
        
        GLuint position = _textureQuadProgram.getAttributeLocation("position");
        GLuint texcoord = _textureQuadProgram.getAttributeLocation("texcoord");
        
        // Setup buffer offsets
        glVertexAttribPointer(position, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), quadPositions);
        glVertexAttribPointer(texcoord, 2, GL_FLOAT, GL_FALSE, 2 * sizeof(float), quadTexcoords);
        
        // Ensure the proper arrays are enabled
        glEnableVertexAttribArray(position);
        glEnableVertexAttribArray(texcoord);
        
        // Draw
        glDrawArrays(GL_TRIANGLES, 0, 2 * 3);
        
        glDisableClientState(GL_VERTEX_ARRAY);
        
    } JS_END_USING
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(0, 0, 0, 0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    if (_texture) {
        glActiveTexture(GL_TEXTURE0 + 0);
        glBindTexture(GL_TEXTURE_2D, _texture.name);
        
        [self drawTextureQuad];
        
        glBindTexture(GL_TEXTURE_2D, 0);
    }
    
}

@end
