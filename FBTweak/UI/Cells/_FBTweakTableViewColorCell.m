/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import <FBTweak/_FBTweakTableViewColorCell.h>

@interface _FBLabeledSlider : UISlider

@property (nonatomic, strong, readonly) UILabel *textLabel;

@end

@implementation _FBLabeledSlider

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _textLabel = [UILabel new];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.textLabel];
    }
    return self;
}

- (void)addSubview:(UIView *)view
{
    [super addSubview:view];
    
    if([self.subviews lastObject] != self.textLabel)
    {
        [self bringSubviewToFront:self.textLabel];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect trackRect = [self thumbRectForBounds:self.bounds trackRect:[self trackRectForBounds:self.bounds] value:self.value];
    self.textLabel.frame = trackRect;
}

@end

@interface _FBTweakTableViewColorCell ()

@property (nonatomic, strong) UIView *preview;
@property (nonatomic, strong) _FBLabeledSlider *slider1;
@property (nonatomic, strong) _FBLabeledSlider *slider2;
@property (nonatomic, strong) _FBLabeledSlider *slider3;
@property (nonatomic, strong) _FBLabeledSlider *slider4;

@end

@implementation _FBTweakTableViewColorCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.preview = [UIView new];
        [self.contentView addSubview:self.preview];
        
        self.slider1 = [self createSlider];
        [self.contentView addSubview:self.slider1];
        
        self.slider2 = [self createSlider];
        [self.contentView addSubview:self.slider2];
        
        self.slider3 = [self createSlider];
        [self.contentView addSubview:self.slider3];
        
        self.slider4 = [self createSlider];
        [self.contentView addSubview:self.slider4];
    }
    return self;
}

- (UIScrollView *)findScrollViewAmongSubviewsOfView:(UIView *)view
{
    for(UIView *subview in view.subviews)
    {
        if([subview isKindOfClass:[UIScrollView class]])
        {
            return (UIScrollView *)subview;
        }
        else
        {
            UIScrollView *scrollView = [self findScrollViewAmongSubviewsOfView:subview];
            if(scrollView)
            {
                return scrollView;
            }
        }
    }
    return nil;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    UIScrollView *scrollView = [self findScrollViewAmongSubviewsOfView:self];
    if([view isKindOfClass:[UISlider class]])
    {
        UISlider *slider = (id)view;
        CGRect trackRect = [slider thumbRectForBounds:slider.bounds trackRect:[slider trackRectForBounds:slider.bounds] value:slider.value];
        CGPoint touchPoint = [self convertPoint:point toView:slider];
        scrollView.scrollEnabled = CGRectContainsPoint(trackRect, touchPoint) ? NO : YES;
    }
    else
    {
        scrollView.scrollEnabled = YES;
    }
    return view;
}

- (_FBLabeledSlider *)createSlider
{
    _FBLabeledSlider *slider = [_FBLabeledSlider new];
    slider.minimumValue = 0.0;
    slider.maximumValue = 1.0;
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    return slider;
}

- (void)setTweak:(FBObjectTweak *)tweak
{
    NSParameterAssert([tweak.defaultValue isKindOfClass:[UIColor class]]);
    [super setTweak:tweak];
    
    [self updateSliders];
    [self updateText];
    [self updatePreview];
}

+ (CGFloat)neededHeightForTweak:(FBTweak *)tweak
{
    return 196;
}

- (void)updatePreview
{
    self.preview.backgroundColor = (UIColor *)self.tweak.currentValue;
}

- (void)updateSliders
{
    CGFloat a, b, c, d;
    [(UIColor *)self.tweak.currentValue getRed:&a green:&b blue:&c alpha:&d];
    
    self.slider1.value = a;
    self.slider2.value = b;
    self.slider3.value = c;
    self.slider4.value = d;
    
    self.slider1.textLabel.text = @"R";
    self.slider2.textLabel.text = @"G";
    self.slider3.textLabel.text = @"B";
    self.slider4.textLabel.text = @"A";
}

- (void)updateText
{
    CGFloat a, b, c, d;
    [(UIColor *)self.tweak.currentValue getRed:&a green:&b blue:&c alpha:&d];
    self.textField.text = [NSString stringWithFormat:
                           @"%i, %i, %i, %i",
                           (int)(a * 255.0),
                           (int)(b * 255.0),
                           (int)(c * 255.0),
                           (int)(d * 255.0)];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSArray *values = [textField.text componentsSeparatedByString:@","];
    if(values.count != 4)
    {
        [self updateText];
    }
    else
    {
        CGFloat a = [(NSString *)values[0] doubleValue] / 255.0;
        CGFloat b = [(NSString *)values[1] doubleValue] / 255.0;
        CGFloat c = [(NSString *)values[2] doubleValue] / 255.0;
        CGFloat d = [(NSString *)values[3] doubleValue] / 255.0;
        
        self.tweak.currentValue = [UIColor colorWithRed:a green:b blue:c alpha:d];
        
        [self updateSliders];
        [self updatePreview];
    }
}

- (void)sliderValueChanged:(UISlider *)sender
{
    CGFloat a = self.slider1.value;
    CGFloat b = self.slider2.value;
    CGFloat c = self.slider3.value;
    CGFloat d = self.slider4.value;
    
    self.tweak.currentValue = [UIColor colorWithRed:a green:b blue:c alpha:d];
    
    [self updateText];
    [self updatePreview];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect previewFrame = CGRectMake(self.textLabel.frame.origin.x, 46, 50, 135);
    self.preview.frame = previewFrame;
    
    CGRect sliderFrame;
    sliderFrame.origin.x = 85;
    sliderFrame.origin.y = 48.0;
    sliderFrame.size.width = self.bounds.size.width - sliderFrame.origin.x - 6;
    sliderFrame.size.height = 25.0;
    
    self.slider1.frame = sliderFrame;
    
    sliderFrame.origin.y += 36;
    self.slider2.frame = sliderFrame;
    
    sliderFrame.origin.y += 36;
    self.slider3.frame = sliderFrame;
    
    sliderFrame.origin.y += 36;
    self.slider4.frame = sliderFrame;
}

@end
