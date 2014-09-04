//
// Created by Agens AS for FBTweak on 03.09.14.
//

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
