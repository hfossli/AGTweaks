/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import <Tweaks/FBTweak.h>

@interface FBIntegerTweak : FBTweak

@property (nonatomic, assign) NSInteger defaultValue;

@property (nonatomic, assign) NSInteger currentValue;

@property (nonatomic, assign) NSInteger maximumValue;

@property (nonatomic, assign) NSInteger minimumValue;

@property (nonatomic, assign) NSInteger stepValue;

@end
