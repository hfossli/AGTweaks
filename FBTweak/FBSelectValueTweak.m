/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import "FBSelectValueTweak.h"
#import "FBTweak_SubclassEyesOnly.h"

@implementation FBSelectValueTweak

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if(self)
    {
        _currentIndex = [[coder decodeObjectForKey:@"currentIndex"] unsignedIntegerValue];
        _defaultIndex = [[coder decodeObjectForKey:@"defaultIndex"] unsignedIntegerValue];
        _strings = [coder decodeObjectForKey:@"values"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    
    [coder encodeObject:@(self.defaultIndex) forKey:@"defaultValue"];
    [coder encodeObject:@(self.currentIndex) forKey:@"currentIndex"];
    [coder encodeObject:self.strings forKey:@"values"];
}

- (void)setCurrentIndex:(NSUInteger)currentIndex
{
    if(self.strings.count < currentIndex + 1)
    {
        currentIndex = MAX(self.strings.count, 1) - 1;
    }
    _currentIndex = currentIndex;
    [self tweakChanged];
}

- (NSString *)currentValue
{
    if(self.strings.count < self.currentIndex + 1)
    {
        return [self.strings lastObject];
    }
    return self.strings[self.currentIndex];
}

- (void)load
{
    NSNumber *index = [[NSUserDefaults standardUserDefaults] objectForKey:self.identifier];
    _currentIndex = index ? [index unsignedIntegerValue] : self.defaultIndex;
}

- (void)save
{
    [[NSUserDefaults standardUserDefaults] setObject:@(self.currentIndex) forKey:self.identifier];
}

- (void)reset
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:self.identifier];
    _currentIndex = self.defaultIndex;
}

@end
