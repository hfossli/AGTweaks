/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import <Tweaks/_FBTweakTableViewCell.h>
#import <Tweaks/FBSelectValueTweak.h>

@interface _FBTweakTableViewSelectAmongFewValuesCell : _FBTweakTableViewCell

@property (nonatomic, strong) FBSelectValueTweak *tweak;

@end