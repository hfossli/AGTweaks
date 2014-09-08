//
//  FBTweakDemoController.m
//  FBTweakExample
//
//  Created by Maria Fossli on 05.09.14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "FBTweakDemoController.h"
#import <FBTweak/Tweaks.h>

@interface FBTweakDemoController ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation FBTweakDemoController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    FBTweakBindObject(self, title, @"Controller", @"Settings", @"Title", @"test");
    FBTweakBindObject(self.view, backgroundColor, @"Window", @"Background", @"Color", [UIColor colorWithWhite:0.9 alpha:1.0]);
    
    [self setupLabel];
    [self setupButton];
}

- (void)setupLabel
{
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height * 0.75)];
    self.label.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.numberOfLines = 0;
    self.label.userInteractionEnabled = YES;
    self.label.backgroundColor = [UIColor clearColor];
    self.label.textColor = [UIColor blackColor];
    self.label.font = [UIFont systemFontOfSize:FBTweakValue(@"Content", @"Text", @"Size", 60.0)];
    [self.view addSubview:self.label];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapped)];
    [self.label addGestureRecognizer:tapRecognizer];
    
    FBTweakBindObject(self.label, text, @"Content", @"Text", @"String", @"Tweaks");
    FBTweakBindValue(self.label, alpha, @"Content", @"Text", @"Alpha", 0.5, 0.0, 1.0);
}

- (void)setupButton
{
    CGRect tweaksButtonFrame = self.view.bounds;
    tweaksButtonFrame.origin.y = self.label.bounds.size.height;
    tweaksButtonFrame.size.height = tweaksButtonFrame.size.height - self.label.bounds.size.height;
    
    UIButton *tweaksButton = [[UIButton alloc] initWithFrame:tweaksButtonFrame];
    tweaksButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    [tweaksButton setTitle:@"Show Tweaks" forState:UIControlStateNormal];
    [tweaksButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [tweaksButton addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tweaksButton];
    
    FBDoubleTweak *animationDurationTweak = FBTweakValueInline(@"Content", @"Animation", @"Duration", 0.5);
    animationDurationTweak.stepValue = 0.005;
    animationDurationTweak.precisionValue = 3.0;
}

- (void)buttonTapped
{
    [[FBTweakShakeWindow activeTweakShakeWindow] presentTweaks];
}

- (void)labelTapped
{
    NSTimeInterval duration = FBTweakValue(@"Content", @"Animation", @"Duration", 0.5);
    [UIView animateWithDuration:duration animations:^{
        CGFloat scale = FBTweakValue(@"Content", @"Animation", @"Scale", 2.0);
        self.label.transform = CGAffineTransformMakeScale(scale, scale);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:duration animations:^{
            self.label.transform = CGAffineTransformIdentity;
        }];
    }];
}

@end