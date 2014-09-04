/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import <FBTweak/FBTweakShakeWindow.h>
#import <FBTweak/FBTweakViewController.h>
#import <FBTweak/FBTweakMacros.h>

#import "FBAppDelegate.h"

@interface FBAppDelegate () <FBTweakObserver, FBTweakViewControllerDelegate>

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) FBTweak *flipTweak;

@end

@implementation FBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[FBTweakShakeWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [[UIViewController alloc] init];

    {
        BOOL test = FBTweakBool(@"Category", @"Collection", @"Bool", YES);
        NSLog(@"BOOL: %@", test ? @"TRUE" : @"FALSE");
    }
    {
        NSInteger test = FBTweakInteger(@"Category", @"Collection", @"Integer", 2);
        NSLog(@"Integer: %li", (long)test);
    }
    {
        NSInteger test = FBTweakInteger(@"Category", @"Collection", @"Integer min/max", 2, 1, 3);
        NSLog(@"Integer: %li", (long)test);
    }
    {
        NSInteger test = FBTweakValues(@"Category", @"Collection", @"Generic", (NSInteger) 2);
        NSLog(@"Integer: %li", (long)test);
    }
    {
        NSString *string = FBTweakString(@"Category", @"Collection", @"String", @"Dummy");
        NSLog(@"String: %@", string);
    }
    {
        NSString *string = FBTweakSelectString(@"Category", @"Collection", @"Select", 1, @"Flat", @"Skeumorphic");
        NSLog(@"Selected value: %@", string);
    }
    {
        FBTweakActions(@"Category", @"Collection", @"Action", ^{
            NSLog(@"Heisann sveisann!");
        });
    }
    
    FBBoolTweak *tweak = [[FBBoolTweak alloc] initWithIdentifier:@"com.tweaks.example.advanced"];
    tweak.name = @"Advanced Settings";
    tweak.defaultValue = YES;
    
    FBTweakStore *store = [FBTweakStore sharedInstance];
    FBTweakCategory *category = [store tweakCategoryWithName:@"Settings"];
    FBTweakCollection *collection = [category tweakCollectionWithName:@"Enable"];
    [collection addTweak:tweak];

    return YES;
}

- (void)tweakDidChange:(FBTweak *)tweak
{
}

- (void)tweakViewControllerPressedDone:(FBTweakViewController *)tweakViewController
{
}

@end

//@implementation FBAppDelegate
//
//FBTweakAction(@"Actions", @"Global", @"Hello", ^{
//  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"Global alert test." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Done", nil];
//  [alert show];
//});
//
//- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
//{
//    
//  FBTweakAction(@"Actions", @"Scoped", @"One", ^{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"Scoped alert test #1." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Done", nil];
//    [alert show];
//  });
//
//  self.window = [[FBTweakShakeWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//  self.window.backgroundColor = [UIColor whiteColor];
//  [self.window makeKeyAndVisible];
//
//  self.rootViewController = [[UIViewController alloc] init];
//  self.rootViewController.view.backgroundColor = [UIColor colorWithRed:FBTweakValue(@"Window", @"Color", @"Red", 0.9, 0.0, 1.0)
//                                                        green:FBTweakValue(@"Window", @"Color", @"Green", 0.9, 0.0, 1.0)
//                                                         blue:FBTweakValue(@"Window", @"Color", @"Blue", 0.9, 0.0, 1.0)
//                                                        alpha:1.0];
//    
//  self.window.rootViewController = self.rootViewController;
//  
//  self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.window.bounds.size.width, self.window.bounds.size.height * 0.75)];
//  self.label.textAlignment = NSTextAlignmentCenter;
//  self.label.numberOfLines = 0;
//  self.label.userInteractionEnabled = YES;
//  self.label.backgroundColor = [UIColor clearColor];
//  self.label.textColor = [UIColor blackColor];
//  self.label.font = [UIFont systemFontOfSize:FBTweakValue(@"Content", @"Text", @"Size", 60.0)];
//  FBTweakBind(self.label, text, @"Content", @"Text", @"String", @"Tweaks");
//  FBTweakBind(self.label, alpha, @"Content", @"Text", @"Alpha", 0.5, 0.0, 1.0);
//  [self.rootViewController.view addSubview:_label];
//  
//  UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapped)];
//  [self.label addGestureRecognizer:tapRecognizer];
//  
//  self.flipTweak = FBTweakInline(@"Window", @"Effects", @"Upside Down", NO);
//  [self.flipTweak addObserver:self];
//
//  CGRect tweaksButtonFrame = self.window.bounds;
//  tweaksButtonFrame.origin.y = self.label.bounds.size.height;
//  tweaksButtonFrame.size.height = tweaksButtonFrame.size.height - self.label.bounds.size.height;
//  UIButton *tweaksButton = [[UIButton alloc] initWithFrame:tweaksButtonFrame];
//  [tweaksButton setTitle:@"Show Tweaks" forState:UIControlStateNormal];
//  [tweaksButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//  [tweaksButton addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
//  [self.rootViewController.view addSubview:tweaksButton];
//    
//  FBTweak *animationDurationTweak = FBTweakInline(@"Content", @"Animation", @"Duration", 0.5);
//  animationDurationTweak.stepValue = [NSNumber numberWithFloat:0.005f];
//  animationDurationTweak.precisionValue = [NSNumber numberWithFloat:3.0f];
//  
//
//  FBTweakAction(@"Actions", @"Scoped", @"Two", ^{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"Scoped alert test #2." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Done", nil];
//    [alert show];
//  });
//
//  return YES;
//}
//
//- (void)tweakDidChange:(FBTweak *)tweak
//{
//  if (tweak == self.flipTweak) {
//    _window.layer.sublayerTransform = CATransform3DMakeScale(1.0, [_flipTweak.currentValue boolValue] ? -1.0 : 1.0, 1.0);
//  }
//}
//
//- (void)buttonTapped
//{
//  FBTweakViewController *viewController = [[FBTweakViewController alloc] initWithStore:[FBTweakStore sharedInstance]];
//  viewController.tweaksDelegate = self;
//  [self.window.rootViewController presentViewController:viewController animated:YES completion:NULL];
//}
//
//- (void)tweakViewControllerPressedDone:(FBTweakViewController *)tweakViewController
//{
//  [tweakViewController dismissViewControllerAnimated:YES completion:NULL];
//}
//
//- (void)labelTapped
//{
//  NSTimeInterval duration = FBTweakValue(@"Content", @"Animation", @"Duration", 0.5);
//  [UIView animateWithDuration:duration animations:^{
//    CGFloat scale = FBTweakValue(@"Content", @"Animation", @"Scale", 2.0);
//    self.label.transform = CGAffineTransformMakeScale(scale, scale);
//  } completion:^(BOOL finished) {
//    [UIView animateWithDuration:duration animations:^{
//      self.label.transform = CGAffineTransformIdentity;
//    }];
//  }];
//}
//
//@end
