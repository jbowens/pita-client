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
#include <vector>

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

static const int kBrushWidthPixels = 50;
static const int kBrushHeightPixels = 50;

static const GLfloat kTextureQuadVertexPositions[] = {
    1.0,  1.0,  0.0,
    -1.0, 1.0,  0.0,
    -1.0, -1.0, 0.0,
    -1.0, -1.0, 0.0,
    1.0,  -1.0, 0.0,
    1.0,  1.0,  0.0
};
const GLfloat kTextureQuadTexcoords[] = {
    1.0, 1.0,
    0.0, 1.0,
    0.0, 0.0,
    0.0, 0.0,
    1.0, 0.0,
    1.0, 1.0
};

@interface PTScrubViewController () {
    EAGLContext *_context;
    
    float _width, _height;
    
    js::OpenGLShaderProgram _textureQuadProgram;
    std::vector<GLfloat> _brushCoords, _brushTexCoords;
    
    BOOL _imageDirty;
}

@property GLKTextureInfo *dirtTexture, *brushMaskTexture;

- (void)setupGL;
- (void)teardownGL;

- (void)drawDirtTexture;
- (void)drawBrushes;

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
    
    GLKTextureLoader *textureLoader = [[GLKTextureLoader alloc] initWithSharegroup:_context.sharegroup];
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"mask_round" ofType:@"png"];
    [textureLoader textureWithContentsOfFile:filePath options:@{GLKTextureLoaderOriginBottomLeft: @YES} queue:nil completionHandler:^(GLKTextureInfo *textureInfo, NSError *outError) {
        if (outError) {
            DDLogError(@"Error loading brush mask texture: %@", outError);
        }
        self.brushMaskTexture = textureInfo;
    }];
    
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
    
    CHECK_GL_ERROR();
    
    _image = image;
}

- (void)teardownGL {
}

- (void)drawDirtTexture {
    glActiveTexture(GL_TEXTURE0 + 0);
    glDisable(GL_DEPTH_TEST);
    glDisable(GL_BLEND);
    
    glBindTexture(GL_TEXTURE_2D, _dirtTexture.name);
    
    JS_USING(&_textureQuadProgram) {
        GLuint texture = _textureQuadProgram.getUniformLocation("texture");
        glUniform1i(texture, 0);
        
        GLuint position = _textureQuadProgram.getAttributeLocation("position");
        GLuint texcoord = _textureQuadProgram.getAttributeLocation("texcoord");
        
        // Setup buffer offsets
        glVertexAttribPointer(position, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), kTextureQuadVertexPositions);
        glVertexAttribPointer(texcoord, 2, GL_FLOAT, GL_FALSE, 2 * sizeof(float), kTextureQuadTexcoords);
        
        // Ensure the proper arrays are enabled
        glEnableVertexAttribArray(position);
        glEnableVertexAttribArray(texcoord);
        
        // Draw
        glDrawArrays(GL_TRIANGLES, 0, 2 * 3);
    } JS_END_USING
    
    glBindTexture(GL_TEXTURE_2D, 0);

    glEnable(GL_DEPTH_TEST);
    
    CHECK_GL_ERROR();
}

- (void)drawBrushes {
    glActiveTexture(GL_TEXTURE0 + 0);
    glDisable(GL_DEPTH_TEST);
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_ZERO, GL_ONE_MINUS_SRC_ALPHA);
    glColorMask(GL_FALSE, GL_FALSE, GL_FALSE, GL_TRUE);
    glBlendEquation(GL_FUNC_ADD);
    
    glBindTexture(GL_TEXTURE_2D, _brushMaskTexture.name);
    
    JS_USING(&_textureQuadProgram) {
        GLuint texture = _textureQuadProgram.getUniformLocation("texture");
        glUniform1i(texture, 0);
        
        GLuint position = _textureQuadProgram.getAttributeLocation("position");
        GLuint texcoord = _textureQuadProgram.getAttributeLocation("texcoord");

        // Setup buffer offsets
        glVertexAttribPointer(position, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), &_brushCoords[0]);
        glVertexAttribPointer(texcoord, 2, GL_FLOAT, GL_FALSE, 2 * sizeof(float), &_brushTexCoords[0]);

        // Ensure the proper arrays are enabled
        glEnableVertexAttribArray(position);
        glEnableVertexAttribArray(texcoord);

        // Draw
        GLsizei n = (GLsizei) _brushCoords.size() / 3;
        glDrawArrays(GL_TRIANGLES, 0, n);
    } JS_END_USING
    
    glBindTexture(GL_TEXTURE_2D, 0);
    
    glEnable(GL_DEPTH_TEST);
    glDisable(GL_BLEND);
    glColorMask(GL_TRUE, GL_TRUE, GL_TRUE, GL_TRUE);
    
    CHECK_GL_ERROR();
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(0, 0, 0, 0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    if (self.dirtTexture && self.brushMaskTexture) {

        [self drawDirtTexture];
        [self drawBrushes];

    }

    CHECK_GL_ERROR();
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    GLKView *view = (GLKView *)self.view;
    
    for (UITouch *touch in touches) {
        
        CGPoint location = [touch locationInView:view];
        
        float widthf = (float) view.drawableWidth;
        float heightf = (float) view.drawableHeight;
        float scaleFactor = view.contentScaleFactor;
        float scaleX = (float)kBrushWidthPixels * scaleFactor / widthf,
        scaleY = (float)kBrushHeightPixels * scaleFactor / widthf,
        translateX = location.x * scaleFactor * 2.f / widthf - 1.f,
        translateY = -location.y * scaleFactor * 2.f / heightf + 1.f;
        
        for (int i = 0; i < 6; i++) {
            for (int j = 0; j < 3; j++) {
                GLfloat f = kTextureQuadVertexPositions[i * 3 + j];
                
                if (j == 0) { f *= scaleX; f += translateX; }
                if (j == 1) { f *= scaleY; f += translateY; }
                
                _brushCoords.push_back(f);
            }
        }
        
        for (int i = 0; i < 6; i++) {
            for (int j = 0; j < 2; j++) {
                GLfloat f = kTextureQuadTexcoords[i * 2 + j];
                
                _brushTexCoords.push_back(f);
            }
        }
    }
}

@end
