//
//  FBDoubleTweak.h
//  FBTweak
//
//  Created by Maria Fossli on 02.09.14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import <FBTweak/FBTweak.h>

@interface FBDoubleTweak : FBTweak

@property (nonatomic, assign) double defaultValue;

@property (nonatomic, assign) double currentValue;

@property (nonatomic, assign) double maximumValue;

@property (nonatomic, assign) double minimumValue;

@property (nonatomic, assign) double precisionValue;

@property (nonatomic, assign) double stepValue;

@end
