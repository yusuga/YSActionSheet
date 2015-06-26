//
//  YSActionSheet.m
//  YSActionSheetExample
//
//  Created by Yu Sugawara on 2014/07/15.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import "YSActionSheet.h"
#import "YSActionSheetWindowController.h"

@interface YSActionSheet ()

@property (nonatomic) YSActionSheetWindowController *windowController;

@end

@implementation YSActionSheet

#pragma mark - Initial

- (instancetype)init
{
    if (self = [super init]) {
        YSActionSheetWindowController *vc = [YSActionSheetWindowController viewController];
        self.windowController = vc;
    }
    return self;
}

#pragma mark - Single section item

- (void)setItems:(NSArray *)items
{
    [self.windowController.tableViewController setItems:items];
}

- (void)updateItem:(YSActionSheetItem *)item forIndex:(NSUInteger)index
{
    [self updateItem:item forIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
}

#pragma mark - Multiple section item

- (void)setSectionTitles:(NSArray *)sectionTitles
                   items:(NSArray *)items
{
    NSAssert2([sectionTitles count] == [items count], @"[sectionTitles count](%zd) != [items count](%zd)", [sectionTitles count], [items count]);
    [self.windowController.tableViewController setSectionTitles:sectionTitles
                                                                     items:items];
}

- (void)updateItem:(YSActionSheetItem *)item forIndexPath:(NSIndexPath *)indexPath
{
    [self.windowController.tableViewController updateItem:item
                                                        forIndexPath:indexPath];
}

#pragma mark - Items

- (NSArray *)items
{
    return self.windowController.tableViewController.items;
}

#pragma mark - Header

- (void)setHeaderTitle:(NSString *)title
{
    self.windowController.tableViewController.headerTitle = title;
}

- (void)setHeaderTitleView:(UIView *)titleView
{
    self.windowController.tableViewController.headerTitleView = titleView;
}

#pragma mark - Cancel

- (void)setCancelButtonTitle:(NSString *)title
{
    [self.windowController setCancelButtonTitle:title];
}

- (void)setCancelButtonDidPush:(void (^)(void))didCancel
{
    self.windowController.didCancel = didCancel;
}

#pragma mark - Heights

- (void)setRowHeight:(CGFloat)rowHeight
{
    self.windowController.tableViewController.rowHeight = rowHeight;
}

- (void)setSectionHeaderHeight:(CGFloat)sectionHeaderHeight
{
    self.windowController.tableViewController.sectionHeaderHeight = sectionHeaderHeight;
}

#pragma mark - Show

- (void)show
{
    [self.windowController show];
}

- (void)reloadData
{
    [self.windowController.tableViewController.tableView reloadData];
}

#pragma mark - Dismiss

- (void)setDidDismissViewcontrollerCompletion:(void (^)(void))didDismissViewcontroller
{
    self.windowController.didDismissViewcontroller = didDismissViewcontroller;
}

#pragma mark - State

- (BOOL)isVisible
{
    return [self.windowController isVisible];
}

@end
