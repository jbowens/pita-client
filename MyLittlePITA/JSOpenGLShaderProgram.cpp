//
//  JSOpenGLShaderProgram.cpp
//  JumboSolitaire
//
//  Created by Jacob Stern on 1/11/14.
//  Copyright (c) 2014 Jacob Stern. All rights reserved.
//

#include "JSOpenGLShaderProgram.h"
#include <iostream>

using namespace js;

static const GLuint kInvalidHandle = 0;

OpenGLShaderProgram::OpenGLShaderProgram() : shaderProgram(0) { }

void OpenGLShaderProgram::setVertexSource(const std::string theSource)
{
    vertexSource = std::string(theSource);
}

void OpenGLShaderProgram::setFragmentSource(const std::string theSource)
{
    fragmentSource = std::string(theSource);
}

OpenGLShaderProgram::~OpenGLShaderProgram()
{
    if (shaderProgram)
        glDeleteProgram(shaderProgram);
}

ErrorValue OpenGLShaderProgram::initialize()
{
    if (! shaderProgram)
        shaderProgram = glCreateProgram();
    
    GLuint vertexShader = glCreateShader(GL_VERTEX_SHADER);
    GLuint fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
    
    sourceShader(vertexShader, vertexSource);
    sourceShader(fragmentShader, fragmentSource);
    
    ErrorValue error = kErrorValueSuccess;
    
    error = compileShader(vertexShader);
    if (error) goto cleanup;
    
    error = compileShader(fragmentShader);
    if (error) goto cleanup;
    
    glAttachShader(shaderProgram, vertexShader);
    glAttachShader(shaderProgram, fragmentShader);
    
    error = linkProgram();
    glDetachShader(shaderProgram, vertexShader);
    glDetachShader(shaderProgram, fragmentShader);
    
cleanup:
    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);
    
    return error;
}

void OpenGLShaderProgram::sourceShader(GLint shader, const std::string source)
{
    GLchar const *sourceBuffer = source.c_str();
    GLint const sourceLength = (int)source.size();
    
    glShaderSource(shader, 1, &sourceBuffer, &sourceLength);
}

ErrorValue OpenGLShaderProgram::compileShader(GLint shader)
{
    glCompileShader(shader);
    
    GLint didCompile = 0;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &didCompile);
    
    if (!didCompile) {
        GLint logSize = 0;
        glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &logSize);
        
        try {
            errorLog.resize(logSize);
        } catch (std::bad_alloc) {
            return kErrorValueOutOfMemory;
        }
        glGetShaderInfoLog(shader, logSize, &logSize, &errorLog[0]);
        
        return kErrorValueFailure;
    }
    
    return kErrorValueSuccess;
}

ErrorValue OpenGLShaderProgram::linkProgram()
{
    glLinkProgram(shaderProgram);
    
    GLint isLinked = 0;
    glGetProgramiv(shaderProgram, GL_LINK_STATUS, &isLinked);
    
    if (!isLinked) {
        GLint logSize = 0;
        glGetProgramiv(shaderProgram, GL_INFO_LOG_LENGTH, &logSize);
        
        try {
            errorLog.resize(logSize);
        } catch (std::bad_alloc) {
            return kErrorValueOutOfMemory;
        }
        glGetProgramInfoLog(shaderProgram, logSize, &logSize, &errorLog[0]);
        
        return kErrorValueFailure;
    }
    
    return kErrorValueSuccess;
}

void OpenGLShaderProgram::enter()
{
    glUseProgram(shaderProgram);
}

void OpenGLShaderProgram::exit()
{
    glUseProgram(0);
}

const std::string OpenGLShaderProgram::getErrorLog() const
{
    return errorLog;
}

GLint OpenGLShaderProgram::getAttributeLocation(std::string name)
{
    return glGetAttribLocation(shaderProgram, &name[0]);
}

GLint OpenGLShaderProgram::getUniformLocation(std::string name)
{
    return glGetUniformLocation(shaderProgram, &name[0]);
}