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
    
    GLKTextureInfo *_texture;
    
    js::OpenGLShaderProgram _textureQuadProgram;
    
    GLuint _framebuffer, _framebufferTexture, _colorRenderBuffer;
    
    BOOL _shouldRedrawFramebuffer;
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
    
    _shouldRedrawFramebuffer = YES;
    
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
    [textureLoader textureWithContentsOfFile:imagePath options:@{GLKTextureLoaderOriginBottomLeft: @YES} queue:NULL completionHandler:^(GLKTextureInfo *textureInfo, NSError *outError) {
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
    
    glGenFramebuffers(1, &_framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _framebuffer);
    
    glActiveTexture(GL_TEXTURE0);
    glGenTextures(1, &_framebufferTexture);

    glBindTexture(GL_TEXTURE_2D, _framebufferTexture); {

        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, _screenWidth, _screenHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);

    } glBindTexture(GL_TEXTURE_2D, 0);

    glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _framebufferTexture, 0);
     
    GLenum framebufferStatus = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (framebufferStatus != GL_FRAMEBUFFER_COMPLETE) {
        DDLogError(@"Error creating scrub framebuffer, failed with status 0x%04X", framebufferStatus);
        
        return;
    }
    
    CHECK_GL_ERROR();
}

- (void)teardownGL {
    glDeleteFramebuffers(1, &_framebuffer);
    GLuint textures[2] = {_framebufferTexture, _texture.name};
    glDeleteTextures(2, textures);
    
    CHECK_GL_ERROR();
}

- (void)drawTextureQuad {
    JS_USING(&_textureQuadProgram) {
        GLuint texture = _textureQuadProgram.getUniformLocation("texture");
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
    } JS_END_USING
    
    CHECK_GL_ERROR();
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(0, 0, 0, 0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    if (_texture) {
        glActiveTexture(GL_TEXTURE0 + 0);
        
        if (_shouldRedrawFramebuffer) {
            glViewport(0, 0, _screenWidth, _screenHeight);

            glBindTexture(GL_TEXTURE_2D, _texture.name);
            glBindFramebuffer(GL_FRAMEBUFFER, _framebuffer);
            
            [self drawTextureQuad];
        }
        
        [view bindDrawable];
            
        glBindTexture(GL_TEXTURE_2D, _framebufferTexture);
        
        [self drawTextureQuad];
        
        glBindTexture(GL_TEXTURE_2D, 0);
        
        _shouldRedrawFramebuffer = NO;
    }
    
    CHECK_GL_ERROR();
}

@end
