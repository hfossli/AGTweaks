/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import <Tweaks/FBTweak.h>

@interface FBDoubleTweak : FBTweak

@property (nonatomic, assign) double defaultValue;

@property (nonatomic, assign) double currentValue;

@property (nonatomic, assign) double maximumValue;

@property (nonatomic, assign) double minimumValue;

@property (nonatomic, assign) double precisionValue;

@property (nonatomic, assign) double stepValue;

@end
