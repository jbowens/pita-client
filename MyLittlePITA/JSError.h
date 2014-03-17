//
//  JSError.h
//  JumboSolitaire
//
//  Created by Jacob Stern on 1/11/14.
//  Copyright (c) 2014 Jacob Stern. All rights reserved.
//

#ifndef JumboSolitaire_JSError_h
#define JumboSolitaire_JSError_h

namespace js {
    
    enum ErrorValue
    {
        kErrorValueSuccess      = 0x00,
        kErrorValueFailure      = 0x01,
        kErrorValueOutOfMemory = 0x02,
    };
}

#endif
