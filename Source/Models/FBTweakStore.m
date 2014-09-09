/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import <Tweaks/FBTweakStore.h>
#import <Tweaks/FBTweak.h>
#import <Tweaks/FBTweakCategory.h>
#import <Tweaks/FBTweakCollection.h>

@interface FBTweakStore ()

@property (nonatomic, strong) NSMutableArray *orderedCategories;

@end

@implementation FBTweakStore

+ (instancetype)sharedInstance
{
    static FBTweakStore *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.orderedCategories = [NSMutableArray new];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [self init];
    if(self)
    {
        NSArray *stored = [coder decodeObjectForKey:@"categories"];
        
        for (FBTweakCategory *category in stored)
        {
            [self.orderedCategories addObject:category];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.orderedCategories forKey:@"categories"];
}

- (NSArray *)tweakCategories
{
    return [self.orderedCategories copy];
}

- (FBTweakCategory *)tweakCategoryWithName:(NSString *)name
{
    NSInteger index = [self.orderedCategories indexOfObjectPassingTest:^BOOL(FBTweakCollection *collection, NSUInteger idx, BOOL *stop) {
        return [collection.name isEqualToString:name];
    }];
    
    FBTweakCategory *category = nil;
    if(index != NSNotFound)
    {
        category = self.orderedCategories[index];
    }
    else
    {
        category = [[FBTweakCategory alloc] initWithName:name];
        [self addTweakCategory:category];
    }
    return category;
}

- (void)addTweakCategory:(FBTweakCategory *)category
{
    [self.orderedCategories addObject:category];
}

- (void)removeTweakCategory:(FBTweakCategory *)category
{
    [self.orderedCategories removeObject:category];
}

- (void)reset
{
    for (FBTweakCategory *category in self.tweakCategories)
    {
        for (FBTweakCollection *collection in category.tweakCollections)
        {
            [collection.tweaks makeObjectsPerformSelector:@selector(reset)];
        }
    }
}

@end
