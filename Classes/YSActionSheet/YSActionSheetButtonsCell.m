//
//  YSActionSheetButtonsCell.m
//  YSActionSheetExample
//
//  Created by Yu Sugawara on 2015/03/11.
//  Copyright (c) 2015年 Yu Sugawara. All rights reserved.
//

#import "YSActionSheetButtonsCell.h"

@implementation YSActionSheetButtonsCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Workaround: Bug of Interface builder in iPad
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [self contentBackgroundColor];
    self.textLabel.backgroundColor = [UIColor clearColor];
}


- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    UIColor *color;
    if (highlighted) {
        color = [UIColor colorWithWhite:1.f alpha:0.6f];
    } else {
        color = [self contentBackgroundColor];
    }
    self.contentView.backgroundColor = color;
}

#pragma mark -

- (UIColor*)contentBackgroundColor
{
    return [UIColor colorWithWhite:1.f alpha:0.8f];
}

@end
