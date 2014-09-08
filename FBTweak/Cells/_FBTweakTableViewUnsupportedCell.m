//
//  _FBTweakTableViewUnsupportedCell.m
//  FBTweak
//
//  Created by Maria Fossli on 05.09.14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

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
