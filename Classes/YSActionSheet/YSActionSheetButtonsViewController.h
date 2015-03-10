//
//  YSActionSheetContentViewController.h
//  YSActionSheetExample
//
//  Created by Yu Sugawara on 2014/07/15.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSActionSheetButtonsViewController : UITableViewController

- (void)setActionSheetItems:(NSArray*)items;

@property (copy, nonatomic) void(^didSelectRow)(void);

- (CGFloat)viewHeight;

@end
