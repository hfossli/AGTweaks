/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import "FBTweakCollection.h"
#import "FBTweakCategory.h"
#import "_FBTweakCollectionViewController.h"
#import "FBTweaks.h"
#import "_FBTweakTableViewCells.h"

@interface _FBTweakCollectionViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong, readwrite) FBTweakCategory *tweakCategory;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *sortedCollections;
@property (nonatomic, strong) UIControl *overlay;

@end

@implementation _FBTweakCollectionViewController

- (instancetype)initWithTweakCategory:(FBTweakCategory *)category
{
    self = [super init];
    if(self)
    {
        self.tweakCategory = category;
        self.title = self.tweakCategory.name;
        
        self.sortedCollections = [self.tweakCategory.tweakCollections sortedArrayUsingComparator:^(FBTweakCollection *a, FBTweakCollection *b) {
            return [a.name localizedStandardCompare:b.name];
        }];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [self.view addSubview:self.tableView];

    self.overlay = [[UIControl alloc] initWithFrame:self.view.bounds];
    self.overlay.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
    self.overlay.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.overlay.hidden = YES;
    self.overlay.alpha = 0.0;
    [self.overlay addTarget:self action:@selector(dismissKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.overlay];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc
{
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

- (void)done
{
    [self.delegate tweakCollectionViewControllerSelectedDone:self];
}

#pragma mark - Keyboard

- (void)keyboardFrameChanged:(NSNotification *)notification
{
    CGRect endFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    endFrame = [self.view.window convertRect:endFrame fromWindow:nil];
    endFrame = [self.view convertRect:endFrame fromView:self.view.window];
    
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    void (^animations)() = ^{
        UIEdgeInsets contentInset = self.tableView.contentInset;
        contentInset.bottom = (self.view.bounds.size.height - CGRectGetMinY(endFrame));
        self.tableView.contentInset = contentInset;
        
        UIEdgeInsets scrollIndicatorInsets = self.tableView.scrollIndicatorInsets;
        scrollIndicatorInsets.bottom = (self.view.bounds.size.height - CGRectGetMinY(endFrame));
        self.tableView.scrollIndicatorInsets = scrollIndicatorInsets;
    };
    
    UIViewAnimationOptions options = (curve << 16) | UIViewAnimationOptionBeginFromCurrentState;
    
    [UIView animateWithDuration:duration delay:0 options:options animations:animations completion:NULL];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    self.overlay.hidden = NO;
    [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.overlay.alpha = 1.0;
    } completion:^(BOOL finished) {
        if(finished)
        {
            self.overlay.hidden = NO;
        }
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.overlay.hidden = NO;
    [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.overlay.alpha = 0.0;
    } completion:^(BOOL finished) {
        if(finished)
        {
            self.overlay.hidden = YES;
        }
    }];
}

- (void)dismissKeyboard
{
    [self.view endEditing:NO];
}

#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sortedCollections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    FBTweakCollection *collection = self.sortedCollections[section];
    return collection.tweaks.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    FBTweakCollection *collection = self.sortedCollections[section];
    return collection.name;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FBTweakCollection *collection = self.sortedCollections[indexPath.section];
    FBTweak *tweak = collection.tweaks[indexPath.row];
    Class cellClass = [self cellClassForTweak:tweak];
    return [cellClass neededHeightForTweak:tweak];
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FBTweakCollection *collection = self.sortedCollections[indexPath.section];
    FBTweak *tweak = collection.tweaks[indexPath.row];
    Class cellClass = [self cellClassForTweak:tweak];

    NSString *cellIdentifier = NSStringFromClass(cellClass);
    _FBTweakTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        cell = [[cellClass alloc] initWithReuseIdentifier:cellIdentifier];
    }
    cell.tweak = tweak;
    return cell;
}

#pragma mark Reset

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    FBTweakCollection *collection = self.sortedCollections[indexPath.section];
    FBTweak *tweak = collection.tweaks[indexPath.row];
    [tweak reset];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Reset";
}

#pragma mark - Utility

- (Class)cellClassForTweak:(FBTweak *)tweak
{
    if([tweak isKindOfClass:[FBBoolTweak class]])
    {
        return [_FBTweakTableViewBoolCell class];
    }
    else if([tweak isKindOfClass:[FBIntegerTweak class]])
    {
        return [_FBTweakTableViewIntegerCell class];
    }
    else if([tweak isKindOfClass:[FBDoubleTweak class]])
    {
        return [_FBTweakTableViewDoubleCell class];
    }
    else if([tweak isKindOfClass:[FBStringTweak class]])
    {
        return [_FBTweakTableViewStringCell class];
    }
    else if([tweak isKindOfClass:[FBObjectTweak class]])
    {
        FBObjectTweak *objectTweak = (FBObjectTweak *)tweak;
        if([objectTweak.defaultValue isKindOfClass:[UIColor class]])
        {
            return [_FBTweakTableViewColorCell class];
        }
        else if([objectTweak.defaultValue isKindOfClass:[NSString class]])
        {
            return [_FBTweakTableViewStringCell class];
        }
        return [_FBTweakTableViewUnsupportedCell class];
    }
    else if([tweak isKindOfClass:[FBActionTweak class]])
    {
        return [_FBTweakTableViewActionCell class];
    }
    else if([tweak isKindOfClass:[FBSelectValueTweak class]])
    {
        FBSelectValueTweak *selectValueTweak = (FBSelectValueTweak *)tweak;
        CGFloat charactersPerPoint = 10.0 / 100.0;
        CGFloat space = self.view.bounds.size.width;
        NSUInteger maxLength = space * charactersPerPoint;
        BOOL gotLongWords = [selectValueTweak.strings indexOfObjectPassingTest:^BOOL(NSString *strings, NSUInteger idx, BOOL *stop) {
            return strings.length > maxLength;
        }] != NSNotFound;

        if(gotLongWords)
        {
            return [_FBTweakTableViewSelectAmongManyValuesCell class];
        }
        return [_FBTweakTableViewSelectAmongFewValuesCell class];
    }
    else
    {
        return [_FBTweakTableViewUnsupportedCell class];
    }
}

@end
