//
//  JSOpenGLTexture2D.h
//  JumboSolitaire
//
//  Created by Jacob Stern on 1/19/14.
//  Copyright (c) 2014 Jacob Stern. All rights reserved.
//

#ifndef __JumboSolitaire__JSOpenGLTexture2D__
#define __JumboSolitaire__JSOpenGLTexture2D__

#include "JSResource.h"
#include <OpenGLES/ES2/gl.h>

namespace js {
    
    enum FramebufferAttachment {
        kColorAttachment = 0,
        kDepthAttachment,
        kStencilAttachment
    };

    class OpenGLTexture2D : public Resource {
        GLuint texture2D;
        GLuint textureUnit;
        
    public:
        OpenGLTexture2D(unsigned textureUnit);
        ~OpenGLTexture2D();
        
        unsigned getTextureUnit();
        
        ErrorValue initialize();
        
        void enter();
        void exit();
        
        void framebufferTexture(FramebufferAttachment attachment);
    };
}

#endif /* defined(__JumboSolitaire__JSOpenGLTexture2D__) */
