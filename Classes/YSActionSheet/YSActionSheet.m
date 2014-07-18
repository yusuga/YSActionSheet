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

- (instancetype)init
{
    if (self = [super init]) {
        YSActionSheetViewController *vc = [YSActionSheetViewController viewController];
        vc.cancelButtonTitle = @"Cancel";
        self.actionSheetViewController = vc;
    }
    return self;
}

- (void)setCancelButtonTitle:(NSString *)title
{
    self.actionSheetViewController.cancelButtonTitle = title;
}

- (void)setDidDismissViewcontrollerCompletion:(void (^)(void))didDismissViewcontroller
{
    self.actionSheetViewController.didDismissViewcontroller = didDismissViewcontroller;
}

- (void)setTitleView:(UIView *)titleView
{
    [self.actionSheetViewController setTitleView:titleView];
}

- (void)addItem:(YSActionSheetItem*)item
{
    [self.actionSheetViewController addItem:item];
}

- (void)updateItemTitle:(NSString *)title image:(UIImage *)image atIndex:(NSUInteger)index
{
    [self.actionSheetViewController updateItemTitle:title image:image atIndex:index];
}

- (void)show
{
    [self.actionSheetViewController show];
}

@end
