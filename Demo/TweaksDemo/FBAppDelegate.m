/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import "FBAppDelegate.h"
#import "Tweaks.h"
#import "FBTweakDemoController.h"

@interface FBAppDelegate () <FBTweakObserver, FBTweakViewControllerDelegate>

@end

@implementation FBAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[FBTweakShakeWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [[FBTweakDemoController alloc] init];
    
    [self someBasicInlineExamples];
    [self explicitExample];
    
    return YES;
}

FBTweakAction(@"Actions", @"Global", @"One", ^{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"Global alert test #1." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Done", nil];
    [alert show];
});

FBTweakAction(@"Actions", @"Global", @"Two", ^{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"Global alert test #2." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Done", nil];
    [alert show];
});

- (void)someBasicInlineExamples
{
    {
        BOOL value = FBTweakValue(@"Category", @"Collection", @"Bool", YES);
        NSLog(@"Bool: %@", value ? @"TRUE" : @"FALSE");
    }
    {
        NSInteger value = FBTweakValue(@"Category", @"Collection", @"Integer", 2);
        NSLog(@"Integer: %li", (long)value);
    }
    {
        NSInteger value = FBTweakValue(@"Category", @"Collection", @"Integer min/max", 2, 1, 3);
        NSLog(@"Integer min/max: %li", (long)value);
    }
    {
        double value = FBTweakValue(@"Category", @"Collection", @"Double", 5.5);
        NSLog(@"Double: %f", value);
    }
    {
        double value = FBTweakValue(@"Category", @"Collection", @"Double min/max", 9.4, 9.0, 10.0);
        NSLog(@"Double min/max: %f", value);
    }
    {
        NSString *string = FBTweakObject(@"Category", @"Collection", @"String", @"Some text");
        NSLog(@"String: %@", string);
    }
    {
        UIColor *color = FBTweakObject(@"Category", @"Collection", @"Color", [UIColor colorWithRed:0.25 green:0.87 blue:1.0 alpha:1.0]);
        NSLog(@"Color: %@", color);
    }
    {
        NSString *string = FBTweakSelectString(@"Category", @"Collection", @"Select", 0, @"Flat", @"Skeumorphic");
        NSLog(@"Selected string: %@", string);
    }
    {
        NSString *string = FBTweakSelectString(@"Category", @"Collection", @"Select among many", 1,
                                               @"Speedy",
                                               @"Slow",
                                               @"Sluggish",
                                               @"Whopping",
                                               @"Vile",
                                               @"Antsy");
        NSLog(@"Selected string among many: %@", string);
    }
    {
        FBTweakAction(@"Category", @"Collection", @"Action", ^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Action" message:@"Action triggered" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Done", nil];
            [alert show];
        });
    }
    
    FBTweakAction(@"Actions", @"Scoped", @"One", ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"Scoped alert test #1." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Done", nil];
        [alert show];
    });
    
    FBTweakAction(@"Actions", @"Scoped", @"Two", ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"Scoped alert test #2." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Done", nil];
        [alert show];
    });
}

- (void)explicitExample
{
    FBBoolTweak *tweak = [[FBBoolTweak alloc] initWithIdentifier:@"com.tweaks.example.advanced"];
    tweak.name = @"Explicit example";
    tweak.defaultValue = YES;
    
    FBTweakStore *store = [FBTweakStore sharedInstance];
    FBTweakCategory *category = [store tweakCategoryWithName:@"Category"];
    FBTweakCollection *collection = [category tweakCollectionWithName:@"Collection"];
    [collection addTweak:tweak];
}

- (void)tweakDidChange:(FBTweak *)tweak
{
}

- (void)tweakViewControllerPressedDone:(FBTweakViewController *)tweakViewController
{
}


@end
