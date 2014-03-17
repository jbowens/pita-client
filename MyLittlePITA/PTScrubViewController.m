//
//  PTScrubViewController.m
//  MyLittlePITA
//
//  Created by Jacob Stern on 3/16/14.
//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#import "PTScrubViewController.h"
#import "PTLog.h"

static const GLfloat kQuadVertexBufferData[] = {
    -1.0f, -1.0f, 0.0f,
    1.0f, -1.0f, 0.0f,
    -1.0f,  1.0f, 0.0f,
    -1.0f,  1.0f, 0.0f,
    1.0f, -1.0f, 0.0f,
    1.0f,  1.0f, 0.0f,
};

static const char kTextureQuadVertexSource[] =
    "varying vec2 uv;                                           "
    "                                                           "
    "void main() {                                              "
    "    uv = gl_Position.xy;                                   "
    "}                                                          "
    "                                                           "
    ")                                                          ";


@interface PTScrubViewController () {
    EAGLContext *_context;
    
    float _screenWidth;
    float _screenHeight;
    
    GLKTextureInfo *_texture;
    
    GLuint _quadVertexBuffer;
    GLuint _quadShaderProgram;
}

- (void)setupGL;
- (void)teardownGL;

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
    NSString *imagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"sprite_happy.png"];
    GLKTextureLoader *textureLoader = [[GLKTextureLoader alloc] initWithSharegroup:_context.sharegroup];
    [textureLoader textureWithContentsOfFile:imagePath options:NULL queue:NULL completionHandler:^(GLKTextureInfo *textureInfo, NSError *outError) {
        if (outError) {
            DDLogError(@"Error loading scrubbing texture: %@", outError);
        }
        
        _texture = textureInfo;
    }];
    
    glGenBuffers(1, &_quadVertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _quadVertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(kQuadVertexBufferData), &kQuadVertexBufferData, GL_STATIC_DRAW);
}

- (void)teardownGL {
    if (_quadVertexBuffer) {
        glDeleteBuffers(1, &_quadVertexBuffer);
    }
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(0, 0, 0, 0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

@end
