//
//  YSActionSheetCell.h
//  YSActionSheetExample
//
//  Created by Yu Sugawara on 2015/03/11.
//  Copyright (c) 2015年 Yu Sugawara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSActionSheetItem.h"

@interface YSActionSheetCell : UITableViewCell

+ (UINib*)nib;

- (void)configureWithItem:(YSActionSheetItem *)item;

@end
