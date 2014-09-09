/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import <FBTweak/_FBTweakTableViewBoolCell.h>

@interface _FBTweakTableViewBoolCell ()

@property (nonatomic, strong) UISwitch *switchControl;

@end

@implementation _FBTweakTableViewBoolCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.textField.hidden = YES;

        self.switchControl = [UISwitch new];
        [self.switchControl addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        [self.accessoryView addSubview:self.switchControl];
    }
    return self;
}

- (void)setTweak:(FBBoolTweak *)tweak
{
    [super setTweak:tweak];
    
    self.switchControl.on = tweak.currentValue;
}

- (void)switchChanged:(UISwitch *)sender
{
    self.tweak.currentValue = sender.on;
}

@end
