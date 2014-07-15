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

@property (copy, nonatomic) NSString *cancelButtonTitle; // default is Cancel

- (void)showWithItems:(NSArray*)items didDismissViewcontroller:(void(^)(void))didDismissViewcontroller;
- (void)updateItemTitle:(NSString*)title image:(UIImage*)image atIndex:(NSUInteger)index;

@end
