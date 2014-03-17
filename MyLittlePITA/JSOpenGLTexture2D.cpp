//
//  JSOpenGLTexture2D.cpp
//  JumboSolitaire
//
//  Created by Jacob Stern on 1/19/14.
//  Copyright (c) 2014 Jacob Stern. All rights reserved.
//

#include "JSOpenGLTexture2D.h"

using namespace js;

OpenGLTexture2D::OpenGLTexture2D(unsigned textureUnit) : textureUnit(textureUnit)
{
    
}

OpenGLTexture2D::~OpenGLTexture2D()
{
    if (texture2D)
        glDeleteTextures(1, &texture2D);
}

ErrorValue OpenGLTexture2D::initialize()
{
    glGenTextures(1, &texture2D);
    
    return kErrorValueSuccess;
}

void OpenGLTexture2D::enter()
{
    glActiveTexture(GL_TEXTURE0 + textureUnit);
    glBindTexture(GL_TEXTURE_2D, texture2D);
}
void OpenGLTexture2D::exit()
{
    glActiveTexture(GL_TEXTURE0 + textureUnit);
    glBindTexture(GL_TEXTURE_2D, 0);
    glActiveTexture(GL_TEXTURE0); // TODO: Is this necessary?
}

unsigned OpenGLTexture2D::getTextureUnit()
{
    return textureUnit;
}

void OpenGLTexture2D::framebufferTexture(FramebufferAttachment attachment)
{
    GLenum translateAttachment = 0;
    switch (attachment) {
        case kColorAttachment:
            translateAttachment = GL_COLOR_ATTACHMENT0;
            break;
            
        case kDepthAttachment:
            translateAttachment = GL_DEPTH_ATTACHMENT;
            break;
            
        case kStencilAttachment:
            translateAttachment = GL_STENCIL_ATTACHMENT;
            break;
            
        default:
            break;
    }
    
    glFramebufferTexture2D(GL_FRAMEBUFFER, translateAttachment, GL_TEXTURE_2D, texture2D, 0);
}