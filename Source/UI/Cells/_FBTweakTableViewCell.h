/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import <UIKit/UIKit.h>
#import <Tweaks/FBTweak.h>

/*
 Responsibility:
 - sets up accessoryView
 - sets up default styling
 - layout accessoryView appropriately
 */

@interface _FBTweakTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic, strong) FBTweak *tweak;

@property (nonatomic, strong, readonly) UITextField *textField;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

+ (CGFloat)neededHeightForTweak:(FBTweak *)tweak;

@end
