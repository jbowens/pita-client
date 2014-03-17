//
//  JSOpenGLRenderBuffer.cpp
//  MyLittlePITA
//
//  Created by Jacob Stern on 3/17/14.
//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#include "JSOpenGLRenderBuffer.h"

using namespace js;

static const int kInvalidHandle = 0;

OpenGLRenderBuffer::OpenGLRenderBuffer(int width, int height)
    : renderBuffer(kInvalidHandle), width(width), height(height), colorTexture(0)
{
    
}

OpenGLRenderBuffer::~OpenGLRenderBuffer()
{
    
}

ErrorValue OpenGLRenderBuffer::initialize()
{
    ErrorValue error = colorTexture.initialize();
    if (error)
        return error;
    
    glGenFramebuffers(1, &renderBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, renderBuffer);
    
    JS_USING(&colorTexture) {
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    } JS_END_USING
    
    colorTexture.framebufferTexture(kColorAttachment);
    
    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
        error = kErrorValueFailure;
        goto cleanup;
    }
    
cleanup:
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    return error;
}

void OpenGLRenderBuffer::enter()
{
    glBindFramebuffer(GL_FRAMEBUFFER, renderBuffer);
}

void OpenGLRenderBuffer::exit()
{
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
}