//
//  FBTweakEXTSelectorChecking.m
//  FBTweakEXTobjc
//
//  Created by Justin Spahr-Summers on 26.06.12.
//  Copyright (C) 2012 Justin Spahr-Summers.
//  Released under the MIT license.
//

#import "FBTweakEXTSelectorChecking.h"

@implementation NSString (FBTweakEXTCheckedSelectorAdditions)
- (SEL)FBTweakEXT_toSelector {
    return NSSelectorFromString(self);
}

@end
