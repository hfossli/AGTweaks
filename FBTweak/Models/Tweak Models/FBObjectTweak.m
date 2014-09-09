/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import <FBTweak/FBObjectTweak.h>
#import <FBTweak/FBTweak_SubclassEyesOnly.h>

@implementation FBObjectTweak

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if(self)
    {
        _currentValue = [coder decodeObjectForKey:@"currentValue"];
        _defaultValue = [coder decodeObjectForKey:@"defaultValue"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    
    [coder encodeObject:self.defaultValue forKey:@"defaultValue"];
    [coder encodeObject:self.currentValue forKey:@"currentValue"];
}

- (void)setCurrentValue:(id)currentValue
{
    [self setCurrentValue:currentValue reason:FBTweakChangeReasonEdit];
}

- (void)setCurrentValue:(id)currentValue reason:(FBTweakChangeReason)reason
{
    _currentValue = currentValue;
    [self tweakChanged:reason];
}

- (void)load
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:self.identifier];
    if(data)
    {
        _currentValue = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    else
    {
        _currentValue = self.defaultValue;
    }
}

- (void)save
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.currentValue];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:self.identifier];
}

- (void)reset
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:self.identifier];
    [self setCurrentValue:self.defaultValue reason:FBTweakChangeReasonReset];
}

@end