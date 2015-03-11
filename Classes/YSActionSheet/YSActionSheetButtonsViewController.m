//
//  YSActionSheetContentViewController.m
//  YSActionSheetExample
//
//  Created by Yu Sugawara on 2014/07/15.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import "YSActionSheetButtonsViewController.h"
#import "YSActionSheetItem.h"

@interface YSActionSheetButtonsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic, readwrite) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerBackgroundColorBottomConstraint;

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *headerTitleLabel;

@property (weak, nonatomic) NSArray *items;
@property (nonatomic) BOOL centeringText;

@end

@implementation YSActionSheetButtonsViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.items = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (NSClassFromString(@"UIBlurEffect") && NSClassFromString(@"UIVisualEffectView")) {
        self.tableView.backgroundView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    }
    
    CGRect frame = CGRectMake(0.f, 0.f, self.tableView.bounds.size.width, self.tableView.bounds.size.height);
    self.tableView.tableHeaderView.frame = frame;
    self.tableView.tableFooterView.frame = frame;
    
    self.headerBackgroundColorBottomConstraint.constant = 1.f/[UIScreen mainScreen].scale;
}

- (void)viewWillLayoutSubviews
{
    BOOL headerTitleEnabled = YES;
    if (self.headerTitle.length) {
        self.headerTitleLabel.text = self.headerTitle;
    } else if (self.headerTitleView) {
        if (!self.headerTitleView.superview) {
            [self.headerView addSubview:self.headerTitleView];
            [self.headerTitleView setTranslatesAutoresizingMaskIntoConstraints:NO];
            
            [self.headerTitleView addConstraint:[NSLayoutConstraint constraintWithItem:self.headerTitleView
                                                                             attribute:NSLayoutAttributeWidth
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:nil
                                                                             attribute:NSLayoutAttributeWidth
                                                                            multiplier:1.f
                                                                              constant:self.headerTitleView.bounds.size.width]];
            [self.headerTitleView addConstraint:[NSLayoutConstraint constraintWithItem:self.headerTitleView
                                                                             attribute:NSLayoutAttributeHeight
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:nil
                                                                             attribute:NSLayoutAttributeHeight
                                                                            multiplier:1.0
                                                                              constant:self.headerTitleView.bounds.size.height]];
            [self.headerView addConstraint:[NSLayoutConstraint constraintWithItem:self.headerTitleView
                                                                        attribute:NSLayoutAttributeCenterX
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.headerView
                                                                        attribute:NSLayoutAttributeCenterX
                                                                       multiplier:1.f
                                                                         constant:0.f]];
            [self.headerView addConstraint:[NSLayoutConstraint constraintWithItem:self.headerTitleView
                                                                        attribute:NSLayoutAttributeCenterY
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.headerView
                                                                        attribute:NSLayoutAttributeCenterY
                                                                       multiplier:1.f
                                                                         constant:0.f]];
        }
    } else {
        headerTitleEnabled = NO;
    }
    
    CGFloat maxHeight = self.view.bounds.size.height;
    CGFloat allCellHeight = [self allCellHeight];
    CGFloat heightConstant = 0.f;
    
    if (allCellHeight > maxHeight) {
        self.headerView.hidden = YES;
        self.tableView.scrollEnabled = YES;
        heightConstant = maxHeight;
        headerTitleEnabled = NO;
    } else if (headerTitleEnabled && allCellHeight + self.headerView.bounds.size.height > maxHeight) {
        self.headerView.hidden = YES;
        self.tableView.scrollEnabled = NO;
        heightConstant = allCellHeight;
        headerTitleEnabled = NO;
    } else if (headerTitleEnabled && allCellHeight + self.headerView.bounds.size.height < maxHeight) {
        self.headerView.hidden = NO;
        self.tableView.scrollEnabled = NO;
        heightConstant = allCellHeight + self.headerView.bounds.size.height;
    } else {
        self.headerView.hidden = NO;
        self.tableView.scrollEnabled = NO;
        heightConstant = allCellHeight;
    }
    
    self.tableViewHeightConstraint.constant = heightConstant;
    
    UIEdgeInsets contentInset = ^UIEdgeInsets{
        UIEdgeInsets insets = self.tableView.contentInset;
        insets.top = -self.tableView.tableHeaderView.bounds.size.height;
        if (headerTitleEnabled) {
            insets.top += self.headerView.bounds.size.height;
        }
        insets.bottom = -self.tableView.tableFooterView.bounds.size.height;
        return insets;
    }();
    
    self.tableView.contentInset = contentInset;
}

- (void)setActionSheetItems:(NSArray*)items
{
    self.items = items;
    
    self.centeringText = YES;
    for (YSActionSheetItem *item in items) {
        if (item.image) {
            self.centeringText = NO;
            break;
        }
    }
    [self.tableView reloadData];
}

- (CGFloat)allCellHeight
{
    return [[self class] cellHeight]*[self.items count];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    YSActionSheetItem *item = self.items[indexPath.row];
    
    cell.textLabel.attributedText = [[NSAttributedString alloc] initWithString:item.title
                                                                    attributes:[YSActionSheetItem textAttributesForType:item.type]];
    if (self.centeringText) {
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.imageView.image = nil;
    } else {
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.imageView.image = item.image;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YSActionSheetItem *item = self.items[indexPath.row];
    if (item.didClickButton) {
        item.didClickButton(indexPath.row);
    }
    if (self.didSelectRow) {
        self.didSelectRow();
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self class] cellHeight];
}

#pragma mark - settings

+ (CGFloat)cellHeight
{
    return 44.f;
}

@end
