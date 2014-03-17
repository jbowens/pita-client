//
//  JSOpenGLShaderProgram.h
//  JumboSolitaire
//
//  Created by Jacob Stern on 1/11/14.
//  Copyright (c) 2014 Jacob Stern. All rights reserved.
//

#ifndef __JumboSolitaire__JSOpenGLShaderProgram__
#define __JumboSolitaire__JSOpenGLShaderProgram__

#include <string>
#include "JSError.h"
#include "JSResource.h"

#include <OpenGLES/ES2/gl.h>

namespace js {
    
    class OpenGLShaderProgram final : public Resource {
        GLuint shaderProgram;
        std::string vertexSource, fragmentSource, errorLog;
        
        static void sourceShader(GLint shader, const std::string source);
        ErrorValue compileShader(GLint shader);
        ErrorValue linkProgram();
        
    public:
        OpenGLShaderProgram();
        ~OpenGLShaderProgram();
        
        void setVertexSource(const std::string theSource);
        void setFragmentSource(const std::string theSource);
        
        const std::string getErrorLog() const;

        ErrorValue initialize();
        void enter();
        void exit();

        GLint getAttributeLocation(std::string name);
        GLint getUniformLocation(std::string name);
        
    };
}

#endif /* defined(__JumboSolitaire__JSOpenGLShaderProgram__) */
