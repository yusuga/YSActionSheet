//
//  YSActionSheet.m
//  YSActionSheetExample
//
//  Created by Yu Sugawara on 2014/07/15.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import "YSActionSheet.h"
#import "YSActionSheetViewController.h"

@interface YSActionSheet ()

@property (nonatomic) YSActionSheetViewController *actionSheetViewController;

@end

@implementation YSActionSheet

#pragma mark - Initial

- (instancetype)init
{
    if (self = [super init]) {
        YSActionSheetViewController *vc = [YSActionSheetViewController viewController];
        self.actionSheetViewController = vc;
    }
    return self;
}

#pragma mark - Single section item

- (void)setItems:(NSArray *)items
{
    [self.actionSheetViewController.buttonsViewController setItems:items];
}

- (void)updateItemTitle:(NSString *)title image:(UIImage *)image forIndex:(NSUInteger)index
{
    [self.actionSheetViewController.buttonsViewController updateItemTitle:title
                                                                    image:image
                                                             forIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
}

#pragma mark - Multiple section item

- (void)setSectionTitles:(NSArray *)sectionTitles
                   items:(NSArray *)items
{
    NSAssert2([sectionTitles count] == [items count], @"[sectionTitles count](%zd) != [items count](%zd)", [sectionTitles count], [items count]);
    [self.actionSheetViewController.buttonsViewController setSectionTitles:sectionTitles
                                                                     items:items];
}

- (void)updateItemTitle:(NSString *)title image:(UIImage *)image forIndexPath:(NSIndexPath *)indexPath
{
    [self.actionSheetViewController.buttonsViewController updateItemTitle:title
                                                                    image:image
                                                             forIndexPath:indexPath];
}

#pragma mark - Header

- (void)setHeaderTitle:(NSString *)title
{
    self.actionSheetViewController.buttonsViewController.headerTitle = title;
}

- (void)setHeaderTitleView:(UIView *)titleView
{
    self.actionSheetViewController.buttonsViewController.headerTitleView = titleView;
}

#pragma mark - Cancel

- (void)setCancelButtonTitle:(NSString *)title
{
    [self.actionSheetViewController setCancelButtonTitle:title];
}

- (void)setCancelButtonDidPush:(void (^)(void))didCancel
{
    self.actionSheetViewController.didCancel = didCancel;
}

#pragma mark - Show

- (void)show
{
    [self.actionSheetViewController show];
}

#pragma mark - Dismiss

- (void)setDidDismissViewcontrollerCompletion:(void (^)(void))didDismissViewcontroller
{
    self.actionSheetViewController.didDismissViewcontroller = didDismissViewcontroller;
}

#pragma mark - State

- (BOOL)isVisible
{
    return [self.actionSheetViewController isVisible];
}

@end
