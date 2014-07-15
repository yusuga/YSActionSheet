//
//  YSActionSheetViewController.h
//  YSActionSheetExample
//
//  Created by Yu Sugawara on 2014/07/15.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSActionSheetItem.h"

@interface YSActionSheetViewController : UIViewController

+ (instancetype)viewController;

@property (copy, nonatomic) NSString *cancelButtonTitle;
@property (copy, nonatomic) void(^didDismissViewcontroller)(void);

- (void)addItem:(YSActionSheetItem*)item;
- (void)updateItemTitle:(NSString*)title image:(UIImage*)image atIndex:(NSUInteger)index;

- (void)show;

@end
