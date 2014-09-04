//
//  _NEWFBTweakTableViewCell.h
//  FBTweak
//
//  Created by Maria Fossli on 02.09.14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBTweak.h"

/*
 Responsibility:
 - sets up accessoryView
 - sets up default styling
 - layout accessoryView appropriately
 */

@interface _FBTweakTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic, strong) FBTweak *tweak;

@property (nonatomic, strong, readonly) UITextField *textField;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

+ (CGFloat)neededHeightForTweak:(FBTweak *)tweak;

@end
