//
//  YSActionSheet.h
//  YSActionSheetExample
//
//  Created by Yu Sugawara on 2014/07/15.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSActionSheetItem.h"

@interface YSActionSheet : UIViewController

///--------------------------
/// @name Single section item
///--------------------------

/**
 *  Set cell items in single section.
 *
 *  @param items NSArray of YSActionSheetItem.
 */
- (void)setItems:(NSArray *)items;

/**
 *  Replace cell item in single section.
 *
 *  @param item Item of cell.
 *  @param index index of cell.
 */
- (void)replaceItem:(YSActionSheetItem *)item
           forIndex:(NSUInteger)index;

///----------------------------
/// @name Multiple section item
///----------------------------

/**
 *  Set cell items in multiple section.
 *
 *  @param sectionTitles NSArray of NSString.
 *  @param items NSArray of NSArray of YSActionSheetItem
 */
- (void)setSectionTitles:(NSArray *)sectionTitles
                   items:(NSArray *)items;

/**
 *  Set cell items in multiple section.
 *
 *  @param sectionViews NSArray of UIView
 *  @param items NSArray of NSArray of YSActionSheetItem
 */
- (void)setSectionViews:(NSArray *)sectionViews
                  items:(NSArray *)items;

/**
 *  Update cell item in multiple section.
 *
 *  @param item Item of cell
 *  @param indexPath Index path of cell.
 */
- (void)replaceItem:(YSActionSheetItem *)item
       forIndexPath:(NSIndexPath *)indexPath;

///------------
/// @name Items
///------------

/**
 *  Items of action sheet.
 *
 */
- (NSArray *)items;

///-------------
/// @name Header
///-------------

/**
 *  Set header title.
 *  
 *  @warning It may not be displayed by the entire height.
 */
- (void)setHeaderTitle:(NSString*)title;

/**
 *  Set header view.
 *
 *  @warning It may not be displayed by the entire height.
 */
- (void)setHeaderTitleView:(UIView*)titleView;

///-------------
/// @name Cancel
///-------------

/**
 *  Set cancel button title. Default is 'Cancel'.
 */
- (void)setCancelButtonTitle:(NSString*)title;

/**
 *  Called after the block is pressed the cancel button.
 */
@property (copy, nonatomic) void(^didCancel)(void);

///--------------
/// @name Heights
///--------------

/**
 *  The height of each row (table cell) in the table view.
 */
- (void)setRowHeight:(CGFloat)rowHeight;

/**
 *  The height of section title headers in the table view.
 */
- (void)setSectionHeaderHeight:(CGFloat)sectionHeaderHeight;

///-----------
/// @name Show
///-----------

/**
 *  Displays the receiver using animation.
 */
- (void)show;

///------------------
/// @name Reload Data
///------------------

/**
 *  Reloads the items of the action sheet.
 *
 *  Note: -[UITableVeiw reloadRowsAtIndexPaths:withRowAnimation:]だと描画が乱れるので使用していない。
 */
- (void)reloadData;

///--------------
/// @name Dismiss
///--------------

/**
 *  The block to execute after the view controller is dismissed.
 */
@property (copy, nonatomic) void(^didDismiss)(void);

///------------
/// @name State
///------------

/**
 *  A Boolean value that indicates whether the receiver is displayed.
 *
 *  @return If YES, the receiver is displayed; otherwise, NO.
 */
- (BOOL)isVisible;

///-------------
/// @name Window
///-------------

/**
 *  The positioning of windows relative to each other. The default value is UIWindowLevelStatusBar - 1.
 */
@property (nonatomic) UIWindowLevel windowLevel;

@end
