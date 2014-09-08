/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import "FBTweakCollection.h"
#import "FBTweak.h"

@interface FBTweakCollection ()

@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, strong, readwrite) NSMutableArray *orderedTweaks;

@end

@implementation FBTweakCollection

- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    if (self)
    {
        self.name = name;
        self.orderedTweaks = [NSMutableArray new];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    NSString *name = [coder decodeObjectForKey:@"name"];
    
    self = [self initWithName:name];
    if (self)
    {
        NSArray *stored = [coder decodeObjectForKey:@"tweaks"];
        
        for(FBTweak *tweak in stored)
        {
            [self.orderedTweaks addObject:tweak];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.orderedTweaks forKey:@"tweaks"];
}

- (FBTweak *)tweakWithIdentifier:(NSString *)identifier
{
    NSInteger index = [self.orderedTweaks indexOfObjectPassingTest:^BOOL(FBTweak *tweak, NSUInteger idx, BOOL *stop) {
        return [tweak.identifier isEqualToString:identifier];
    }];
    if(index != NSNotFound)
    {
        return self.orderedTweaks[index];
    }
    return nil;
}

- (NSArray *)tweaks
{
    return [self.orderedTweaks copy];
}

- (void)addTweak:(FBTweak *)tweak
{
    [self.orderedTweaks addObject:tweak];
}

- (void)removeTweak:(FBTweak *)tweak
{
    [self.orderedTweaks removeObject:tweak];
}

@end
