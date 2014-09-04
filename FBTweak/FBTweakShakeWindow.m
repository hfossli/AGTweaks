/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.

 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import "FBTweakEnabled.h"
#import "FBTweakStore.h"
#import "FBTweakShakeWindow.h"
#import "FBTweakViewController.h"

static FBTweakViewController *controller;

@interface FBTweakShakeWindow ()

@property (nonatomic, strong) FBTweakViewController *tweaksController;
@property (nonatomic, assign) BOOL shaking;

@end

// Minimum shake time required to present tweaks on device.
static NSTimeInterval _FBTweakShakeWindowMinTimeInterval = 0.4;

@implementation FBTweakShakeWindow

- (void)presentTweaks
{
    UIViewController *visibleViewController = self.rootViewController;
    while (visibleViewController.presentedViewController != nil)
    {
        visibleViewController = visibleViewController.presentedViewController;
    }

    if(self.tweaksController == nil)
    {
        FBTweakStore *store = [FBTweakStore sharedInstance];
        self.tweaksController = [[FBTweakViewController alloc] initWithStore:store];
        self.tweaksController.tweaksDelegate = self;
    }

    // Prevent double-presenting the tweaks view controller.
    if (![visibleViewController isKindOfClass:[FBTweakViewController class]])
    {
        [visibleViewController presentViewController:self.tweaksController animated:YES completion:NULL];
    }
}

#pragma mark - Delegate

- (void)tweakViewControllerPressedDone:(FBTweakViewController *)tweakViewController
{
    [[NSNotificationCenter defaultCenter] postNotificationName:FBTweakShakeViewControllerDidDismissNotification object:tweakViewController];
    [tweakViewController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Shake motion

- (BOOL)shouldPresentTweaks
{
#if FB_TWEAK_ENABLED
# if TARGET_IPHONE_SIMULATOR
    return YES;
# else
    return _shaking && [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
# endif
#endif
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        self.shaking = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, _FBTweakShakeWindowMinTimeInterval * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            if ([self shouldPresentTweaks])
            {
                [self presentTweaks];
            }
        });
    }
    [super motionBegan:motion withEvent:event];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        self.shaking = NO;
    }
    [super motionEnded:motion withEvent:event];
}

@end
