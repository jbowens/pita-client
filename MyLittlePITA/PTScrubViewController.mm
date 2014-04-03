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

#define CHECK_GL_ERROR() ({ GLenum __error = glGetError(); if(__error) printf("OpenGL error 0x%04X in %s\n", __error, __FUNCTION__); (__error ? NO : YES); })

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
    
    js::OpenGLShaderProgram _textureQuadProgram;
    
    BOOL _imageDirty;
}

@property (atomic) GLKTextureInfo *dirtTexture;

- (void)setupGL;
- (void)teardownGL;

- (void)drawTextureQuadUsingProgram:(js::OpenGLShaderProgram *)program inRect:(CGRect)rect;

@end

@implementation PTScrubViewController

- (void)viewDidLoad {
    // From https://developer.apple.com/library/ios/samplecode/GLCameraRipple/
    
    [super viewDidLoad];
    
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!_context) {
        NSLog(@"Failed to create ES context");
    }
    
    if (_imageDirty) {
        [self setImage:_image]; // TODO: this is hacky af
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = _context;
    self.preferredFramesPerSecond = 60;
    
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

    _textureQuadProgram.setVertexSource(kTextureQuadVertexSource);
    _textureQuadProgram.setFragmentSource(kTextureQuadFragmentSource);
    
    if (_textureQuadProgram.initialize()) {
        std::string reason = _textureQuadProgram.getErrorLog();
        DDLogError(@"Error creating RTT shader program: %s", reason.c_str());
        
        return;
    }
    
    CHECK_GL_ERROR();
}

- (void)setImage:(UIImage *)image {
    if (_context == nil) {
        _imageDirty = YES;
    }
    else {
        [EAGLContext setCurrentContext:_context];
        
        NSError *error;
        CGImageRef cgImage = image.CGImage;
        self.dirtTexture = [GLKTextureLoader textureWithCGImage:cgImage options:nil error:&error];
        
        if (error) {
            DDLogError(@"Error extracting scrubbing texture from image: %@", error.localizedDescription);
        }
        else {
            glActiveTexture(GL_TEXTURE0);
            
            glBindTexture(GL_TEXTURE_2D, _dirtTexture.name);
            
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
            
            glBindTexture(GL_TEXTURE_2D, 0);
        }
    }
    
    _image = image;
}

- (void)teardownGL {
}

- (void)drawTextureQuadUsingProgram:(js::OpenGLShaderProgram *)program inRect:(CGRect)rect {
    JS_USING(program) {
        GLuint texture = program->getUniformLocation("texture");
        glUniform1i(texture, 0);
        
        // From http://stackoverflow.com/questions/13455590/opengl-es-2-0-textured-quad
        const float quadPositions[] = {  1.0,  1.0, 0.0,
            -1.0,  1.0, 0.0,
            -1.0, -1.0, 0.0,
            -1.0, -1.0, 0.0,
            1.0, -1.0, 0.0,
            1.0,  1.0, 0.0 };
        const float quadTexcoords[] = { 1.0, 1.0,
            0.0, 1.0,
            0.0, 0.0,
            0.0, 0.0,
            1.0, 0.0,
            1.0, 1.0 };
        
        GLuint position = program->getAttributeLocation("position");
        GLuint texcoord = program->getAttributeLocation("texcoord");
        
        // Setup buffer offsets
        glVertexAttribPointer(position, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), quadPositions);
        glVertexAttribPointer(texcoord, 2, GL_FLOAT, GL_FALSE, 2 * sizeof(float), quadTexcoords);
        
        // Ensure the proper arrays are enabled
        glEnableVertexAttribArray(position);
        glEnableVertexAttribArray(texcoord);
        
        // Draw
        glDrawArrays(GL_TRIANGLES, 0, 2 * 3);
    } JS_END_USING
    
    CHECK_GL_ERROR();
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(0, 0, 0, 0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    if (self.dirtTexture) {
        glActiveTexture(GL_TEXTURE0 + 0);
        glDisable(GL_DEPTH_TEST);
            
        glBindTexture(GL_TEXTURE_2D, _dirtTexture.name);
        
        [self drawTextureQuadUsingProgram:&_textureQuadProgram inRect:CGRectZero];

        glBindTexture(GL_TEXTURE_2D, 0);
    }

    CHECK_GL_ERROR();
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];

    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    
}

@end
