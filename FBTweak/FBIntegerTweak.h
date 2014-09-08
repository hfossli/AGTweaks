//
//  FBIntegerTweak.h
//  FBTweak
//
//  Created by Maria Fossli on 02.09.14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import <FBTweak/FBTweak.h>

@interface FBIntegerTweak : FBTweak

@property (nonatomic, assign) NSInteger defaultValue;

@property (nonatomic, assign) NSInteger currentValue;

@property (nonatomic, assign) NSInteger maximumValue;

@property (nonatomic, assign) NSInteger minimumValue;

@property (nonatomic, assign) NSInteger stepValue;

@end
