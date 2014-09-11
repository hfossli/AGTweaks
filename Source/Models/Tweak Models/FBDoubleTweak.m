/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import "FBDoubleTweak.h"
#import "FBTweak_SubclassEyesOnly.h"

@implementation FBDoubleTweak

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if(self)
    {
        _defaultValue = [coder decodeIntegerForKey:@"defaultValue"];
        _currentValue = [coder decodeIntegerForKey:@"currentValue"];
        _minimumValue = [coder decodeIntegerForKey:@"minimumValue"];
        _maximumValue = [coder decodeIntegerForKey:@"maximumValue"];
        _precisionValue = [coder decodeIntegerForKey:@"precisionValue"];
        _stepValue = [coder decodeIntegerForKey:@"stepValue"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    
    [coder encodeInteger:self.defaultValue forKey:@"defaultValue"];
    [coder encodeInteger:self.currentValue forKey:@"currentValue"];
    [coder encodeInteger:self.minimumValue forKey:@"minimumValue"];
    [coder encodeInteger:self.maximumValue forKey:@"maximumValue"];
    [coder encodeInteger:self.precisionValue forKey:@"precisionValue"];
    [coder encodeInteger:self.stepValue forKey:@"stepValue"];
}

- (void)setCurrentValue:(double)currentValue
{
    [self setCurrentValue:currentValue reason:FBTweakChangeReasonEdit];
}

- (void)setCurrentValue:(double)currentValue reason:(FBTweakChangeReason)reason
{
    _currentValue = currentValue;
    [self tweakChanged:reason];
}

- (void)load
{
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:self.identifier];
    _currentValue = number ? [number doubleValue] : self.defaultValue;
}

- (void)save
{
    [[NSUserDefaults standardUserDefaults] setObject:@(self.currentValue) forKey:self.identifier];
}

- (void)reset
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:self.identifier];
    [self setCurrentValue:self.defaultValue reason:FBTweakChangeReasonReset];
}

@end
