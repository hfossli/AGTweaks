/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import "FBTweak.h"
#import "FBTweak_SubclassEyesOnly.h"

@interface FBTweak ()

@property (nonatomic, copy, readwrite) NSString *identifier;
@property (nonatomic, strong, readwrite) NSHashTable *observers;

@end

@implementation FBTweak

- (instancetype)init
{
    [NSException raise:NSInternalInconsistencyException format:@"Use designated initializer (%@)", NSStringFromSelector(@selector(initWithIdentifier:))];
    return nil;
}

- (instancetype)initWithIdentifier:(NSString *)identifier
{
    self = [super init];
    if (self)
    {
        self.identifier = identifier;
        self.observers = [NSHashTable weakObjectsHashTable];

        [self load];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    NSString *identifier = [coder decodeObjectForKey:@"identifier"];
    self = [self initWithIdentifier:identifier];
    if (self)
    {
        self.name = [coder decodeObjectForKey:@"name"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.identifier forKey:@"identifier"];
    [coder encodeObject:self.name forKey:@"name"];
}

- (void)tweakChanged:(FBTweakChangeReason)reason
{
    if(reason == FBTweakChangeReasonEdit)
    {
        [self save];
    }
    
    for (id <FBTweakObserver> observer in [_observers setRepresentation])
    {
        [observer tweakDidChange:self];
    }
}

- (void)load
{
    [NSException raise:NSInternalInconsistencyException format:@"Subclasses should override"];
}

- (void)save
{
    [NSException raise:NSInternalInconsistencyException format:@"Subclasses should override"];
}

- (void)reset
{
    [NSException raise:NSInternalInconsistencyException format:@"Subclasses should override"];
}

- (void)addObserver:(id<FBTweakObserver>)observer
{
    NSAssert(observer != nil, @"Observer is required");
    [self.observers addObject:observer];
}

- (void)removeObserver:(id<FBTweakObserver>)observer
{
    NSAssert(observer != nil, @"Observer is required");
    [self.observers removeObject:observer];
}

@end
