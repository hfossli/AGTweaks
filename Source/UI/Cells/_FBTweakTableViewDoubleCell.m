/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import "_FBTweakTableViewDoubleCell.h"

@interface _FBTweakTableViewDoubleCell ()

@property (nonatomic, strong) UIStepper *stepper;

@end

@implementation _FBTweakTableViewDoubleCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.textField.keyboardType = UIKeyboardTypeNumberPad;

        self.stepper = [UIStepper new];
        [self.stepper addTarget:self action:@selector(stepperChanged:) forControlEvents:UIControlEventValueChanged];
        [self.accessoryView addSubview:self.stepper];
    }
    return self;
}
- (void)setTweak:(FBDoubleTweak *)tweak
{
    [super setTweak:tweak];

    self.stepper.value = tweak.currentValue;

    if(tweak.minimumValue == tweak.maximumValue)
    {
        self.stepper.minimumValue = DBL_MIN;
        self.stepper.maximumValue = DBL_MAX;
        self.stepper.stepValue = MAX(0.01, fabs(tweak.currentValue * 0.01));
    }
    else
    {
        self.stepper.minimumValue = tweak.minimumValue;
        self.stepper.maximumValue = tweak.maximumValue;
        self.stepper.stepValue = fabs((tweak.maximumValue - tweak.minimumValue) * 0.01);
    }

    [self updateTextFieldAndStepper];
}

- (NSUInteger)numberOfDecimalsToDisplay
{
    NSString *decimals = [[[@(self.stepper.stepValue) stringValue] componentsSeparatedByString:@"."] lastObject];
    NSRange leadingZeroRange = [decimals rangeOfString:@"^0+" options:NSRegularExpressionSearch];
    if(leadingZeroRange.length > 0)
    {
        return leadingZeroRange.length + 2;
    }
    return 1;
}

- (void)updateTextFieldAndStepper
{
    self.stepper.value = self.tweak.currentValue;
    NSString *formatString = [NSString stringWithFormat:@"%@.%luf", @"%", (unsigned long)[self numberOfDecimalsToDisplay]];
    self.textField.text = [NSString stringWithFormat:formatString, self.tweak.currentValue];
}

- (void)stepperChanged:(UIStepper *)sender
{
    self.tweak.currentValue = sender.value;
    [self updateTextFieldAndStepper];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.tweak.currentValue = [textField.text doubleValue];
    [self updateTextFieldAndStepper];
}

@end
