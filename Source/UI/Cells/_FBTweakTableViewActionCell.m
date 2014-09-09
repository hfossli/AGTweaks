/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import <Tweaks/_FBTweakTableViewActionCell.h>

@interface _FBTweakTableViewActionCell ()

@property (nonatomic, strong) UIButton *button;

@end

@implementation _FBTweakTableViewActionCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.textField.hidden = YES;

        self.button = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        self.button.frame = CGRectMake(0, 0, 100, 40);
        self.button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self.button setTitle:@"Trigger" forState:UIControlStateNormal];
        [self.accessoryView addSubview:self.button];
    }
    return self;
}

- (void)buttonTapped:(UIButton *)sender
{
    [self.tweak triggerAction];
}

@end
