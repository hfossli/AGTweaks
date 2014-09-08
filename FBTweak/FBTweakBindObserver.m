/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import <objc/runtime.h>

#import "FBTweak.h"
#import "FBTweakBindObserver.h"

@interface FBTweakBindObserver () <FBTweakObserver>

@property (nonatomic, strong) FBTweak *tweak;
@property (nonatomic, strong) FBTweakBindObserverBlock block;
@property (nonatomic, weak) id object;

@end

@implementation FBTweakBindObserver

- (instancetype)initWithTweak:(FBTweak *)tweak block:(FBTweakBindObserverBlock)block
{
    self = [super init];
    if(self)
    {
        NSAssert(tweak != nil, @"tweak is required");
        NSAssert(block != NULL, @"block is required");
        
        self.tweak = tweak;
        self.block = block;
        
        [tweak addObserver:self];
    }
    return self;
}

- (void)tweakDidChange:(FBTweak *)tweak
{
    __attribute__((objc_precise_lifetime)) id strongObject = self.object;
    
    if (strongObject != nil)
    {
        self.block(strongObject);
    }
}

- (void)attachToObject:(id)object
{
    NSAssert(self.object == nil, @"can only attach to an object once");
    NSAssert(object != nil, @"object is required");
    
    self.object = object;
    objc_setAssociatedObject(object, (__bridge void *)self, self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
