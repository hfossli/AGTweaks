/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import <Tweaks/_FBTweakTableViewSelectAmongFewValuesCell.h>


@interface _FBTweakTableViewSelectAmongFewValuesCell ()

@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@end

@implementation _FBTweakTableViewSelectAmongFewValuesCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.textField.hidden = YES;

        self.segmentedControl = [UISegmentedControl new];
        [self.segmentedControl addTarget:self action:@selector(segmentedControlChanged:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:self.segmentedControl];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGRect textLabelFrame = self.textLabel.frame;
    textLabelFrame.size.height = 40;
    textLabelFrame.origin.y = 0;
    self.textLabel.frame = textLabelFrame;

    CGRect segmentedControlFrame;
    segmentedControlFrame.origin.x = self.textLabel.frame.origin.x;
    segmentedControlFrame.origin.y = 36.0;
    segmentedControlFrame.size.width = self.bounds.size.width - segmentedControlFrame.origin.x - 6;
    segmentedControlFrame.size.height = 25.0;
    self.segmentedControl.frame = segmentedControlFrame;
}

- (void)setTweak:(FBSelectValueTweak *)tweak
{
    [super setTweak:tweak];

    [self updateSegmentedControl];
}

+ (CGFloat)neededHeightForTweak:(FBSelectValueTweak *)tweak
{
    return 70;
}

#pragma mark - Segmented control

- (void)updateSegmentedControl
{
    [self.segmentedControl removeAllSegments];

    for(int i = 0; i < self.tweak.strings.count; i++)
    {
        id value = self.tweak.strings[i];
        NSString *text = [value description];
        [self.segmentedControl insertSegmentWithTitle:text atIndex:i animated:NO];
    }

    self.segmentedControl.selectedSegmentIndex = [self.tweak.strings indexOfObject:self.tweak.currentValue];
}

- (void)segmentedControlChanged:(UISegmentedControl *)sender
{
    self.tweak.currentIndex = sender.selectedSegmentIndex;
}

@end
