//
//  FBGenericTweak.m
//  FBTweak
//
//  Created by Maria Fossli on 05.09.14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "FBObjectTweak.h"
#import "FBTweak_SubclassEyesOnly.h"

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
    _currentValue = currentValue;
    [self tweakChanged];
}

- (void)load
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:self.identifier];
    id <NSObject, NSCopying, NSCoding> value = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    _currentValue = value ? value : self.defaultValue;
}

- (void)save
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.currentValue];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:self.identifier];
}

- (void)reset
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:self.identifier];
    _currentValue = self.defaultValue;
}

@end