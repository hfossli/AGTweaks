/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import "_FBTweakTableViewUnsupportedCell.h"

@implementation _FBTweakTableViewUnsupportedCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.textField.userInteractionEnabled = NO;
        self.textField.text = @"Unsupported type";
        self.textField.textColor = [UIColor redColor];
    }
    return self;
}

@end
