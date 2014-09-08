/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.

 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import "FBTweakStore.h"
#import "FBTweakViewController.h"
#import "_FBTweakCategoryViewController.h"
#import "_FBTweakCollectionViewController.h"

NSString *const FBTweakShakeViewControllerDidDismissNotification = @"FBTweakShakeViewControllerDidDismissNotification";

@interface FBTweakViewController () <_FBTweakCategoryViewControllerDelegate, _FBTweakCollectionViewControllerDelegate>

@property (nonatomic, strong) FBTweakStore *store;

@end

@implementation FBTweakViewController

- (instancetype)initWithStore:(FBTweakStore *)store
{
    self = [super init];
    if(self)
    {
        self.store = store;

        _FBTweakCategoryViewController *categoryViewController = [[_FBTweakCategoryViewController alloc] initWithStore:store];
        categoryViewController.delegate = self;
        [self pushViewController:categoryViewController animated:NO];
    }
    return self;
}

- (void)tweakCategoryViewController:(_FBTweakCategoryViewController *)viewController selectedCategory:(FBTweakCategory *)category
{
    _FBTweakCollectionViewController *collectionViewController = [[_FBTweakCollectionViewController alloc] initWithTweakCategory:category];
    collectionViewController.delegate = self;
    [self pushViewController:collectionViewController animated:YES];
}

- (void)tweakCategoryViewControllerSelectedDone:(_FBTweakCategoryViewController *)viewController
{
    [self.tweaksDelegate tweakViewControllerPressedDone:self];
    [self save];
}

- (void)tweakCollectionViewControllerSelectedDone:(_FBTweakCollectionViewController *)viewController
{
    [self.tweaksDelegate tweakViewControllerPressedDone:self];
    [self save];
}

- (void)save
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSUserDefaults standardUserDefaults] synchronize];
    });
}

@end
