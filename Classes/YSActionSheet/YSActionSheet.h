//
//  YSActionSheet.h
//  YSActionSheetExample
//
//  Created by Yu Sugawara on 2014/07/15.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YSActionSheetItem.h"

@interface YSActionSheet : NSObject

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
 *  Update cell item in single section.
 *
 *  @param item Item of cell.
 *  @param index index of cell.
 */
- (void)updateItem:(YSActionSheetItem *)item
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
 *  Update cell item in multiple section.
 *
 *  @param item Item of cell
 *  @param indexPath Index path of cell.
 */
- (void)updateItem:(YSActionSheetItem *)item
      forIndexPath:(NSIndexPath *)indexPath;

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
- (void)setCancelButtonDidPush:(void(^)(void))didCancel;

///-----------
/// @name Show
///-----------

/**
 *  Displays the receiver using animation.
 */
- (void)show;

///--------------
/// @name Dismiss
///--------------

/**
 *  Dismisses the receiver using animation.
 *
 *  @param didDismissViewcontroller The block to execute after the view controller is dismissed.
 */
- (void)setDidDismissViewcontrollerCompletion:(void(^)(void))didDismissViewcontroller;

///------------
/// @name State
///------------

/**
 *  A Boolean value that indicates whether the receiver is displayed.
 *
 *  @return If YES, the receiver is displayed; otherwise, NO.
 */
- (BOOL)isVisible;

@end
