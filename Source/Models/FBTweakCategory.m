/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import <Tweaks/FBTweakCategory.h>
#import <Tweaks/FBTweakCollection.h>

@interface FBTweakCategory ()

@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, strong) NSMutableArray *orderedCollections;

@end

@implementation FBTweakCategory

- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    if(self)
    {
        self.name = name;
        self.orderedCollections = [NSMutableArray new];
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
        
        for(FBTweakCollection *collection in stored)
        {
            [self.orderedCollections addObject:collection];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.orderedCollections forKey:@"collections"];
}

- (FBTweakCollection *)tweakCollectionWithName:(NSString *)name
{
    NSInteger index = [self.orderedCollections indexOfObjectPassingTest:^BOOL(FBTweakCollection *collection, NSUInteger idx, BOOL *stop) {
        return [collection.name isEqualToString:name];
    }];
    
    FBTweakCollection *collection = nil;
    if(index != NSNotFound)
    {
        collection = self.orderedCollections[index];
    }
    else
    {
        collection = [[FBTweakCollection alloc] initWithName:name];
        [self addTweakCollection:collection];
    }
    return collection;
}

- (NSArray *)tweakCollections
{
    return [self.orderedCollections copy];
}

- (void)addTweakCollection:(FBTweakCollection *)tweakCollection
{
    [self.orderedCollections addObject:tweakCollection];
}

- (void)removeTweakCollection:(FBTweakCollection *)tweakCollection
{
    [self.orderedCollections removeObject:tweakCollection];
}

@end
