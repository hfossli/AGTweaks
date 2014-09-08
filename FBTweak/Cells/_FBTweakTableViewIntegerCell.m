/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import "_FBTweakTableViewIntegerCell.h"

@interface _FBTweakTableViewIntegerCell ()

@property (nonatomic, strong) UIStepper *stepper;

@end

@implementation _FBTweakTableViewIntegerCell

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
- (void)setTweak:(FBIntegerTweak *)tweak
{
    [super setTweak:tweak];

    self.stepper.value = tweak.currentValue;

    if(tweak.minimumValue == tweak.maximumValue && tweak.minimumValue == 0)
    {
        self.stepper.minimumValue = DBL_MIN;
        self.stepper.maximumValue = DBL_MAX;
        self.stepper.stepValue = MAX(1.0, fabs(tweak.currentValue / 100.0));
    }
    else
    {
        self.stepper.minimumValue = tweak.minimumValue;
        self.stepper.maximumValue = tweak.maximumValue;
        self.stepper.stepValue = MAX(1.0, (tweak.maximumValue - tweak.minimumValue) / 100.0);
    }

    [self updateTextFieldAndStepper];
}

- (void)updateTextFieldAndStepper
{
    self.stepper.value = self.tweak.currentValue;
    self.textField.text = [NSString stringWithFormat:@"%li", (long)self.tweak.currentValue];
}

- (void)stepperChanged:(UIStepper *)sender
{
    self.tweak.currentValue = sender.value;
    [self updateTextFieldAndStepper];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.tweak.currentValue = [textField.text integerValue];
    [self updateTextFieldAndStepper];
}

@end
