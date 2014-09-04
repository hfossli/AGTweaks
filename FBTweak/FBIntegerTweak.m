//
//  FBIntegerTweak.m
//  FBTweak
//
//  Created by Maria Fossli on 02.09.14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "FBIntegerTweak.h"
#import "FBTweak_SubclassEyesOnly.h"

@implementation FBIntegerTweak

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if(self)
    {
        _defaultValue = [coder decodeIntegerForKey:@"defaultValue"];
        _currentValue = [coder decodeIntegerForKey:@"currentValue"];
        _minimumValue = [coder decodeIntegerForKey:@"minimumValue"];
        _maximumValue = [coder decodeIntegerForKey:@"maximumValue"];
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
    [coder encodeInteger:self.stepValue forKey:@"stepValue"];
}

- (void)setCurrentValue:(NSInteger)currentValue
{
    _currentValue = currentValue;
    [self tweakChanged];
}

- (void)load
{
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:self.identifier];
    _currentValue = number ? [number integerValue] : self.defaultValue;
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
