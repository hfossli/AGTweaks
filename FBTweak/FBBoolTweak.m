/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import "FBBoolTweak.h"
#import "FBTweak_SubclassEyesOnly.h"

@implementation FBBoolTweak

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if(self)
    {
        _defaultValue = [coder decodeBoolForKey:@"defaultValue"];
        _currentValue = [coder decodeBoolForKey:@"currentValue"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    
    [coder encodeInteger:self.defaultValue forKey:@"defaultValue"];
    [coder encodeInteger:self.currentValue forKey:@"currentValue"];
}

- (void)setCurrentValue:(BOOL)currentValue
{
    [self setCurrentValue:currentValue reason:FBTweakChangeReasonEdit];
}

- (void)setCurrentValue:(BOOL)currentValue reason:(FBTweakChangeReason)reason
{
    _currentValue = currentValue;
    [self tweakChanged:reason];
}

- (void)load
{
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:self.identifier];
    _currentValue = number ? [number boolValue] : self.defaultValue;
}

- (void)save
{
    [[NSUserDefaults standardUserDefaults] setBool:self.currentValue forKey:self.identifier];
}

- (void)reset
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:self.identifier];
    [self setCurrentValue:self.defaultValue reason:FBTweakChangeReasonReset];
}

@end
