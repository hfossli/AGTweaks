//
//  _NEWFBTweakTableViewCell.m
//  FBTweak
//
//  Created by Maria Fossli on 02.09.14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "_NEWFBTweakTableViewCell.h"

@interface _NEWFBTweakTableViewCell ()

@property (nonatomic, strong, readwrite) UITextField *textField;

@end

@implementation _NEWFBTweakTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    [NSException raise:NSInternalInconsistencyException format:@"Use designated initializer"];
    return nil;
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self)
    {
        CGRect accessoryViewFrame = self.bounds;
        accessoryViewFrame.size.width = 100;
        accessoryViewFrame.origin.x = self.bounds.size.width - accessoryViewFrame.size.width;
        self.accessoryView = [[UIView alloc] initWithFrame:accessoryViewFrame];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.textField = [[UITextField alloc] init];
        self.textField.textAlignment = NSTextAlignmentRight;
        self.textField.delegate = self;
        self.textField.returnKeyType = UIReturnKeyDone;
        self.textField.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.textField];

//        self.accessoryView.backgroundColor = [UIColor colorWithHue:0.2 saturation:1.0 brightness:1.0 alpha:0.2];
//        self.contentView.backgroundColor = [UIColor colorWithHue:0.7 saturation:1.0 brightness:1.0 alpha:0.2];
//        self.textField.backgroundColor = [UIColor colorWithHue:0.5 saturation:1.0 brightness:1.0 alpha:0.2];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setTweak:(FBTweak *)tweak
{
    _tweak = tweak;

    [self setNeedsLayout];
}

#pragma mark - Callbacks

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
}

#pragma mark - Layout

+ (CGFloat)neededHeightForTweak:(FBTweak *)tweak
{
    return 50.0;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self updateSizeAndPositionOfTextLabel];
    [self updateSizeAndPositionOfAccessoryView];
    [self updateSizeAndPositionOfContentView];
    [self updateSizeAndPositionOfTextField];
}

- (void)updateSizeAndPositionOfTextLabel
{
    [self.textLabel sizeToFit];
    
    CGRect textLabelFrame = self.textLabel.frame;
    textLabelFrame.origin.y = floor((self.bounds.size.height - textLabelFrame.size.height) / 2.0);
    self.textLabel.frame = textLabelFrame;
}

- (void)updateSizeAndPositionOfTextField
{
    CGRect textFieldFrame = self.textField.frame;
    textFieldFrame.origin.x = CGRectGetMaxX(self.textLabel.frame) + 5;
    textFieldFrame.origin.y = 1;
    textFieldFrame.size.width = self.contentView.bounds.size.width - textFieldFrame.origin.x - 6;
    textFieldFrame.size.height = self.bounds.size.height - textFieldFrame.origin.y;
    self.textField.frame = textFieldFrame;
}

- (void)updateSizeAndPositionOfContentView
{
    CGRect contentViewFrame = self.bounds;
    contentViewFrame.size.width = self.accessoryView.frame.origin.x;
    self.contentView.frame = contentViewFrame;
}

- (void)updateSizeAndPositionOfAccessoryView
{
    CGRect unionOfSubviewFrames = CGRectMake(self.bounds.size.width, self.bounds.size.height, 0, 0);

    for(int i = 0; i < self.accessoryView.subviews.count; i++)
    {
        UIView *subview = self.accessoryView.subviews[i];
        if(i == 0)
        {
            unionOfSubviewFrames = subview.frame;
        }
        else
        {
            unionOfSubviewFrames = CGRectUnion(unionOfSubviewFrames, subview.frame);
        }
    }

    CGRect accessoryViewFrame = unionOfSubviewFrames;
    accessoryViewFrame.origin.x = self.bounds.size.width - accessoryViewFrame.size.width - 6;
    accessoryViewFrame.origin.y = floor((self.bounds.size.height - accessoryViewFrame.size.height) / 2.0);
    self.accessoryView.frame = accessoryViewFrame;
}

@end
