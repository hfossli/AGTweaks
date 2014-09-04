//
//  FBStringTweak.m
//  FBTweak
//
//  Created by Maria Fossli on 02.09.14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "FBStringTweak.h"
#import "FBTweak_SubclassEyesOnly.h"

@implementation FBStringTweak

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
    _currentValue = currentValue;
    [self tweakChanged];
}

- (void)load
{
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:self.identifier];
    _currentValue = value ? value : self.defaultValue;
}

- (void)save
{
    [[NSUserDefaults standardUserDefaults] setObject:self.currentValue forKey:self.identifier];
}

- (void)reset
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:self.identifier];
    _currentValue = self.defaultValue;
}

@end
