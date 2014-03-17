//
//  JSResource.h
//  JumboSolitaire
//
//  Created by Jacob Stern on 1/14/14.
//  Copyright (c) 2014 Jacob Stern. All rights reserved.
//

#ifndef JumboSolitaire_JSResource_h
#define JumboSolitaire_JSResource_h

#include <vector>
#include "JSError.h"

namespace js {
    
    class Resource {
    public:
        virtual ErrorValue initialize() = 0;
        virtual void enter()            = 0;
        virtual void exit()             = 0;
    };
}

class __js_using_ctx_t final {
    std::vector<js::Resource*> resources;
    
public:
    inline __js_using_ctx_t(std::vector<js::Resource*> theResources) : resources(theResources)
    {
        for (js::Resource *r : resources) {
            r->enter();
        }
    }
    inline ~__js_using_ctx_t()
    {
        for (js::Resource *r : resources) {
            r->exit();
        }
    }
    
};

#define JS_USING(...)   \
{                       \
    std::vector<js::Resource*> resources = { __VA_ARGS__ }; \
    __js_using_ctx_t __js_using_ctx(resources);

#define JS_END_USING    \
}

#endif
