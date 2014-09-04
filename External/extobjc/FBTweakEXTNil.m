//
//  FBTweakEXTNil.m
//  FBTweakEXTobjc
//
//  Created by Justin Spahr-Summers on 2011-04-25.
//  Copyright (C) 2012 Justin Spahr-Summers.
//  Released under the MIT license.
//

#import "FBTweakEXTNil.h"
#import "FBTweakEXTRuntimeExtensions.h"

static id singleton = nil;

@implementation FBTweakEXTNil
+ (void)initialize {
    if (self == [FBTweakEXTNil class]) {
        if (!singleton)
            singleton = [self alloc];
    }
}

+ (FBTweakEXTNil *)null {
    return singleton;
}

- (id)init {
    return self;
}

#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

#pragma mark Forwarding machinery

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSUInteger returnLength = [[anInvocation methodSignature] methodReturnLength];
    if (!returnLength) {
        // nothing to do
        return;
    }

    // set return value to all zero bits
    char buffer[returnLength];
    memset(buffer, 0, returnLength);

    [anInvocation setReturnValue:buffer];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return FBTweakEXT_globalMethodSignatureForSelector(selector);
}

- (BOOL)respondsToSelector:(SEL)selector {
    // behave like nil
    return NO;
}

#pragma mark NSObject protocol

- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    return NO;
}

- (NSUInteger)hash {
    return 0;
}

- (BOOL)isEqual:(id)obj {
    return !obj || obj == self || [obj isEqual:[NSNull null]];
}

- (BOOL)isKindOfClass:(Class)class {
    return [class isEqual:[FBTweakEXTNil class]] || [class isEqual:[NSNull class]];
}

- (BOOL)isMemberOfClass:(Class)class {
    return [class isEqual:[FBTweakEXTNil class]] || [class isEqual:[NSNull class]];
}

- (BOOL)isProxy {
    // not really a proxy -- we just inherit from NSProxy because it makes
    // method signature lookup simpler
    return NO;
}

@end
