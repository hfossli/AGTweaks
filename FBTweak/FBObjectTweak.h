//
//  FBGenericTweak.h
//  FBTweak
//
//  Created by Maria Fossli on 05.09.14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import <FBTweak/FBTweak.h>

@interface FBObjectTweak : FBTweak

@property (nonatomic, copy) id <NSObject, NSCopying, NSCoding> defaultValue;

@property (nonatomic, copy) id <NSObject, NSCopying, NSCoding> currentValue;

@end
