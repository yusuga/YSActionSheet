//
//  YSActionSheetContentViewController.h
//  YSActionSheetExample
//
//  Created by Yu Sugawara on 2014/07/15.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSActionSheetButtonsViewController : UIViewController

@property (weak, nonatomic, readonly) IBOutlet UITableView *tableView;

- (void)setActionSheetItems:(NSArray*)items;
@property (nonatomic) NSString *headerTitle;
@property (nonatomic) UIView *headerTitleView;

@property (copy, nonatomic) void(^didSelectRow)(void);

@end
