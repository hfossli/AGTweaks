//
//  FBDoubleTweak.m
//  FBTweak
//
//  Created by Maria Fossli on 02.09.14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "FBDoubleTweak.h"
#import "FBTweak_SubclassEyesOnly.h"

@implementation FBDoubleTweak

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [self initWithCoder:coder];
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
    _currentValue = currentValue;
    [self tweakChanged];
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
    _currentValue = self.defaultValue;
}

@end
