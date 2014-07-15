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

- (void)setCancelButtonTitle:(NSString*)title; // default is Cancel
- (void)setDidDismissViewcontrollerCompletion:(void(^)(void))didDismissViewcontroller;
- (void)addItem:(YSActionSheetItem*)item;
- (void)updateItemTitle:(NSString*)title image:(UIImage*)image atIndex:(NSUInteger)index;

- (void)show;

@end
