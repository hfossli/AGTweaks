/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import <Tweaks/_FBTweakTableViewStringCell.h>

@interface _FBTweakTableViewStringCell ()

@end

@implementation _FBTweakTableViewStringCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if(self)
    {
    }
    return self;
}

- (void)setTweak:(FBObjectTweak *)tweak
{
    NSParameterAssert([tweak.defaultValue isKindOfClass:[NSString class]]);
    [super setTweak:tweak];

    self.textField.text = (NSString *)tweak.currentValue;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.tweak.currentValue = textField.text;
}

@end
