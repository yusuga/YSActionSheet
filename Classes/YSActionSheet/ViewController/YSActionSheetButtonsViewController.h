//
//  YSActionSheetContentViewController.h
//  YSActionSheetExample
//
//  Created by Yu Sugawara on 2014/07/15.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSActionSheetButtonsViewController : UIViewController

+ (instancetype)viewController;

@property (weak, nonatomic, readonly) IBOutlet UITableView *tableView;

- (void)setItems:(NSArray *)items;                      // NSArray of YSActionSheetItem
- (void)setSectionTitles:(NSArray *)sectionTitles       // NSArray of NSString
                   items:(NSArray *)items;              // NSArray of NSArray of YSActionSheetItem

- (void)updateItemTitle:(NSString *)title
                  image:(UIImage *)image
            forIndexPath:(NSIndexPath *)indexPath;

@property (copy, nonatomic) NSString *headerTitle;
@property (nonatomic) UIView *headerTitleView;

@property (copy, nonatomic) void(^didSelectRow)(void);

@end
