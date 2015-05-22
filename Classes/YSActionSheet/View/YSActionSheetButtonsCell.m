//
//  YSActionSheetButtonsCell.m
//  YSActionSheetExample
//
//  Created by Yu Sugawara on 2015/03/11.
//  Copyright (c) 2015年 Yu Sugawara. All rights reserved.
//

#import "YSActionSheetButtonsCell.h"
#import "YSActionSheetUtility.h"

@implementation YSActionSheetButtonsCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Workaround: Bug of Interface builder in iPad
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [YSActionSheetUtility contentBackgroundColor];
    self.textLabel.backgroundColor = [UIColor clearColor];
}


- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    UIColor *color;
    if (highlighted) {
        color = [YSActionSheetUtility highlightedContentBackgroundColor];
    } else {
        color = [YSActionSheetUtility contentBackgroundColor];
    }
    self.contentView.backgroundColor = color;
}

@end
