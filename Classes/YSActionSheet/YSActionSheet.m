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
        self.cancelButtonTitle = @"Cancel";
    }
    return self;
}


- (void)showWithItems:(NSArray *)items
{
    YSActionSheetViewController *vc = [YSActionSheetViewController viewControllerWithCancelButtonTitle:self.cancelButtonTitle];
    [vc showWithItems:items];
    self.actionSheetViewController = vc;
}

- (void)updateItemTitle:(NSString *)title image:(UIImage *)image atIndex:(NSUInteger)index
{
    [self.actionSheetViewController updateItemTitle:title image:image atIndex:index];
}

@end
