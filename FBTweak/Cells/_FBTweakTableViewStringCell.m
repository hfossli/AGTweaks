//
// Created by Agens AS for FBTweak on 04.09.14.
//

#import "_FBTweakTableViewStringCell.h"

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

- (void)setTweak:(FBStringTweak *)tweak
{
    [super setTweak:tweak];

    self.textField.text = tweak.currentValue;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.tweak.currentValue = textField.text;
}

@end
