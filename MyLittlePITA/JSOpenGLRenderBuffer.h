//
//  JSOpenGLRenderBuffer.h
//  MyLittlePITA
//
//  Created by Jacob Stern on 3/17/14.
//  Copyright (c) 2014 My Little PITA Group. All rights reserved.
//

#ifndef __MyLittlePITA__JSOpenGLRenderBuffer__
#define __MyLittlePITA__JSOpenGLRenderBuffer__

#include <string>
#include "JSError.h"
#include "JSResource.h"
#include "JSOpenGLTexture2D.h"

#include <OpenGLES/ES2/gl.h>

namespace js {
    
    class OpenGLRenderBuffer final : public Resource {
        GLuint renderBuffer;
        js::OpenGLTexture2D colorTexture;
        int width, height;
        
    public:
        OpenGLRenderBuffer(int width, int height);
        ~OpenGLRenderBuffer();
        
        ErrorValue initialize();
        void enter();
        void exit();
        
        js::OpenGLTexture2D *getColorTexture();
    };
}

#endif /* defined(__MyLittlePITA__JSOpenGLRenderBuffer__) */
