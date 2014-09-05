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
