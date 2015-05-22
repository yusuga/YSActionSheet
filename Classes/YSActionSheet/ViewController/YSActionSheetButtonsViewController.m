//
//  YSActionSheetContentViewController.m
//  YSActionSheetExample
//
//  Created by Yu Sugawara on 2014/07/15.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import "YSActionSheetButtonsViewController.h"
#import "YSActionSheetItem.h"
#import "YSActionSheetHeaderView.h"
#import "YSActionSheetUtility.h"

static NSString * const kHeaderIdentifier = @"Header";
static CGFloat const kCellHeight = 44.f;
static CGFloat const kSectionHeaderHeight = 20.f;

@interface YSActionSheetButtonsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic, readwrite) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerBackgroundColorBottomConstraint;

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *headerBackgroundColorView;
@property (weak, nonatomic) IBOutlet UILabel *headerTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *footerBackgroundColorView;

@property (nonatomic) BOOL centeringText;
@property (nonatomic) BOOL multipleSection;

@property (nonatomic) NSArray *items;
@property (nonatomic) NSArray *sectionTitles;

@end

@implementation YSActionSheetButtonsViewController

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

- (void)setItems:(NSArray *)items
{
    _items = items;
    
    self.centeringText = YES;
    
    if (self.multipleSection) {
        for (NSArray *secItems in items) {
            for (YSActionSheetItem *item in secItems) {
                if (item.image) {
                    self.centeringText = NO;
                    break;
                }
            }
        }
    } else {
        for (YSActionSheetItem *item in items) {
            if (item.image) {
                self.centeringText = NO;
                break;
            }
        }
    }
}

- (void)setSectionTitles:(NSArray *)sectionTitles
                   items:(NSArray *)items
{
    self.multipleSection = YES;
    self.sectionTitles = sectionTitles;
    self.items = items;
}

- (void)updateItemTitle:(NSString *)title
                  image:(UIImage *)image
            forIndexPath:(NSIndexPath *)indexPath
{
    YSActionSheetItem *item = [self itemForIndexPath:indexPath];
    if (item) {
        if (title) {
            item.title = title;
        }
        if (image) {
            item.image = image;
        }
        [self.tableView reloadData];
    }
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    YSActionSheetItem *item = [self itemForIndexPath:indexPath];
    
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