//
//  FBTweakEXTScope.m
//  FBTweakEXTobjc
//
//  Created by Justin Spahr-Summers on 2011-05-04.
//  Copyright (C) 2012 Justin Spahr-Summers.
//  Released under the MIT license.
//

#import "FBTweakEXTScope.h"

void FBTweakEXT_executeCleanupBlock (__strong FBTweakEXT_cleanupBlock_t *block) {
    (*block)();
}

