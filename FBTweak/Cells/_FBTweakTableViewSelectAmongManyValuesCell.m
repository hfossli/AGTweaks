/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import "_FBTweakTableViewSelectAmongManyValuesCell.h"

#define _FBBlueColor [UIColor colorWithRed:22.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0]

@interface _FBTweakTableViewSelectValueCellCell : UITableViewCell

@end

@implementation _FBTweakTableViewSelectValueCellCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleDefault;

        self.textLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;

        self.selectedBackgroundView = [UIView new];
        self.selectedBackgroundView.backgroundColor = _FBBlueColor;

        self.textLabel.highlightedTextColor = [UIColor whiteColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGRect textLabelFrame = self.bounds;
    textLabelFrame.origin.x += 10;
    textLabelFrame.size.width -= 20;
    self.textLabel.frame = textLabelFrame;
}

@end


@interface _FBTweakTableViewSelectAmongManyValuesCell () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation _FBTweakTableViewSelectAmongManyValuesCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.textField.hidden = YES;

        self.tableView = [UITableView new];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.allowsMultipleSelection = NO;
        self.tableView.allowsSelection = YES;
        self.tableView.scrollEnabled = NO;
        self.tableView.layer.cornerRadius = 6;
        self.tableView.layer.borderColor = _FBBlueColor.CGColor;
        self.tableView.layer.borderWidth = 1.0;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        if([self.tableView respondsToSelector:@selector(separatorInset)])
        {
            self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }
        self.tableView.separatorColor = _FBBlueColor;
        [self.contentView addSubview:self.tableView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGRect textLabelFrame = self.textLabel.frame;
    textLabelFrame.size.height = 50;
    textLabelFrame.origin.y = 0;
    self.textLabel.frame = textLabelFrame;

    CGRect tableViewFrame = self.bounds;
    tableViewFrame.origin.x += 12;
    tableViewFrame.size.width -= 18;
    tableViewFrame.origin.y += 40;
    tableViewFrame.size.height = self.tweak.strings.count * 44;
    self.tableView.frame = tableViewFrame;
}

- (void)setTweak:(FBSelectValueTweak *)tweak
{
    [super setTweak:tweak];

    [self.tableView reloadData];

    NSIndexPath *selectedRow = [NSIndexPath indexPathForRow:self.tweak.currentIndex inSection:0];
    [self.tableView selectRowAtIndexPath:selectedRow animated:NO scrollPosition:UITableViewScrollPositionNone];
}

+ (CGFloat)neededHeightForTweak:(FBSelectValueTweak *)tweak
{
    return 50 + (tweak.strings.count * 44.0);
}

#pragma mark - Table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweak.strings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"selectValueCell";
    _FBTweakTableViewSelectValueCellCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        cell = [[_FBTweakTableViewSelectValueCellCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = self.tweak.strings[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tweak.currentIndex = indexPath.row;
}

@end
