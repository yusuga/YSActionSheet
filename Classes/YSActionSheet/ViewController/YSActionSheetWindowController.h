//
//  YSActionSheetWindowController.h
//  YSActionSheetExample
//
//  Created by Yu Sugawara on 2014/07/15.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSActionSheetItem.h"
#import "YSActionSheetTableViewController.h"

@interface YSActionSheetWindowController : UIViewController

+ (instancetype)viewController;

- (void)setCancelButtonTitle:(NSString *)title;
@property (copy, nonatomic) void(^didDismissViewcontroller)(void);
@property (copy, nonatomic) void(^didCancel)(void);

@property (nonatomic, readonly) YSActionSheetTableViewController *buttonsViewController;

- (void)show;
- (BOOL)isVisible;

@end
