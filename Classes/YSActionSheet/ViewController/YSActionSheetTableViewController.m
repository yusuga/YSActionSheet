//
//  YSActionSheetTableViewController.m
//  YSActionSheetExample
//
//  Created by Yu Sugawara on 2014/07/15.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import "YSActionSheetTableViewController.h"
#import "YSActionSheetCell.h"
#import "YSActionSheetHeaderView.h"
#import "YSActionSheetUtility.h"

static NSString * const kCellIdentifier = @"Cell";
static NSString * const kHeaderIdentifier = @"Header";
static CGFloat const kCellHeight = 44.f;
static CGFloat const kSectionHeaderHeight = 20.f;

@interface YSActionSheetTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic, readwrite) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerBackgroundColorBottomConstraint;

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *headerBackgroundColorView;
@property (weak, nonatomic) IBOutlet UILabel *headerTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *footerBackgroundColorView;

@property (nonatomic) BOOL multipleSection;

@property (nonatomic, readwrite) NSArray *items;
@property (nonatomic) NSArray *sectionTitles;

@end

@implementation YSActionSheetTableViewController

+ (instancetype)viewController
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"YSActionSheet" bundle:nil];
    return [sb instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([YSActionSheetUtility hasBlurEffect]) {
        self.tableView.backgroundView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    }
    
    CGRect frame = CGRectMake(0.f, 0.f, self.tableView.bounds.size.width, self.tableView.bounds.size.height);
    self.tableView.tableHeaderView.frame = frame;
    self.tableView.tableFooterView.frame = frame;
    
    self.headerBackgroundColorView.backgroundColor = [YSActionSheetUtility contentBackgroundColor];
    self.headerBackgroundColorBottomConstraint.constant = 1.f/[UIScreen mainScreen].scale;
    
    self.footerBackgroundColorView.backgroundColor = [YSActionSheetUtility contentBackgroundColor];
    
    [self.tableView registerNib:[YSActionSheetCell nib] forCellReuseIdentifier:kCellIdentifier];
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
    CGFloat contentHeight = [self allContentHeight];
    CGFloat heightConstant = 0.f;
    
    if (contentHeight > maxHeight) {
        self.headerView.hidden = YES;
        self.tableView.scrollEnabled = YES;
        heightConstant = maxHeight;
        headerTitleEnabled = NO;
    } else if (headerTitleEnabled && contentHeight + self.headerView.bounds.size.height > maxHeight) {
        self.headerView.hidden = YES;
        self.tableView.scrollEnabled = NO;
        heightConstant = contentHeight;
        headerTitleEnabled = NO;
    } else if (headerTitleEnabled && contentHeight + self.headerView.bounds.size.height < maxHeight) {
        self.headerView.hidden = NO;
        self.tableView.scrollEnabled = NO;
        heightConstant = contentHeight + self.headerView.bounds.size.height;
    } else {
        self.headerView.hidden = NO;
        self.tableView.scrollEnabled = NO;
        heightConstant = contentHeight;
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

- (void)setSectionTitles:(NSArray *)sectionTitles
                   items:(NSArray *)items
{
    self.multipleSection = YES;
    self.sectionTitles = sectionTitles;
    self.items = items;
}

- (void)updateItem:(YSActionSheetItem *)item
      forIndexPath:(NSIndexPath *)indexPath
{
    if (self.multipleSection) {
        NSMutableArray *items = [self.items mutableCopy];
        NSMutableArray *secItems = [items[indexPath.section] mutableCopy];
        [secItems replaceObjectAtIndex:indexPath.row withObject:item];
        [items replaceObjectAtIndex:indexPath.section withObject:[NSArray arrayWithArray:secItems]];
        self.items = [NSArray arrayWithArray:items];
    } else {
        NSMutableArray *items = [self.items mutableCopy];
        [items replaceObjectAtIndex:indexPath.row withObject:item];
        self.items = [NSArray arrayWithArray:items];
    }

    [self.tableView reloadData];
}

- (CGFloat)allContentHeight
{
    CGFloat cellHeight = [self cellHeight];
    
    if (self.multipleSection) {
        NSUInteger count = 0;
        
        for (NSArray *secItems in self.items) {
            count += [secItems count];
        }
        return cellHeight*count + [[self sectionTitles] count]*[self sectionHeaderHeight];
    } else {
        return cellHeight*[self.items count];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.multipleSection ? [self.items count] : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.multipleSection ? [self.items[section] count] : [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YSActionSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    [cell configureWithItem:[self itemForIndexPath:indexPath]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    YSActionSheetItem *item = [self itemForIndexPath:indexPath];
    return !item.activityIndicatorShown;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YSActionSheetItem *item = [self itemForIndexPath:indexPath];
    if (item.didClickButton) {
        item.didClickButton(indexPath);
    }
    if (self.didSelectRow) {
        self.didSelectRow();
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self cellHeight];
}

#pragma mark Header

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.multipleSection && [self.sectionTitles count]) {
        YSActionSheetHeaderView *view = [[YSActionSheetHeaderView alloc] init];
        view.titleLabel.text = self.sectionTitles[section];
        if ([tableView respondsToSelector:@selector(layoutMargins)]) {
            view.titleLabelLeadingConstraint.constant = tableView.layoutMargins.left;
        }
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.multipleSection && [self.sectionTitles count] ? [self sectionHeaderHeight] : 0.f;
}

#pragma mark - Utility

- (YSActionSheetItem *)itemForIndexPath:(NSIndexPath *)indexPath
{
    return self.multipleSection ? self.items[indexPath.section][indexPath.row] : self.items[indexPath.row];
}

- (CGFloat)cellHeight
{
    return kCellHeight;
}

- (CGFloat)sectionHeaderHeight
{
    return kSectionHeaderHeight;
}

@end
