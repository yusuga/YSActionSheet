//
//  YSActionSheetTableViewController.h
//  YSActionSheetExample
//
//  Created by Yu Sugawara on 2014/07/15.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSActionSheetItem.h"

@interface YSActionSheetTableViewController : UIViewController

+ (instancetype)viewController;

@property (weak, nonatomic, readonly) IBOutlet UITableView *tableView;

- (void)setItems:(NSArray *)items;                      // NSArray of YSActionSheetItem
- (void)setSectionTitles:(NSArray *)sectionTitles       // NSArray of NSString
                   items:(NSArray *)items;              // NSArray of NSArray of YSActionSheetItem

- (void)replaceItem:(YSActionSheetItem *)item
       forIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, readonly) NSArray *items;

@property (copy, nonatomic) NSString *headerTitle;
@property (nonatomic) UIView *headerTitleView;

@property (nonatomic) CGFloat rowHeight;
@property (nonatomic) CGFloat sectionHeaderHeight;

@property (copy, nonatomic) void(^didSelectRow)(void);

@end
