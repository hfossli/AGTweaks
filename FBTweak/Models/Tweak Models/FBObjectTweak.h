/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import <FBTweak/FBTweak.h>

@interface FBObjectTweak : FBTweak

@property (nonatomic, copy) id <NSObject, NSCopying, NSCoding> defaultValue;

@property (nonatomic, copy) id <NSObject, NSCopying, NSCoding> currentValue;

@end
