//
//  YSActionSheetUtility.m
//  YSActionSheetExample
//
//  Created by Yu Sugawara on 5/23/15.
//  Copyright (c) 2015 Yu Sugawara. All rights reserved.
//

#import "YSActionSheetUtility.h"

@implementation YSActionSheetUtility

+ (BOOL)hasBlurEffect
{
    return NSClassFromString(@"UIBlurEffect") && NSClassFromString(@"UIVisualEffectView");
}

+ (UIColor *)viewBackgroundColor
{
    if ([self hasBlurEffect]) {
        return [[UIColor blackColor] colorWithAlphaComponent:0.4f];
    } else {
        return [self contentBackgroundColor];
    }
}

+ (UIColor *)contentBackgroundColor
{
    if ([self hasBlurEffect]) {
        return [UIColor colorWithWhite:1.f alpha:0.8f];
    } else {
        return [UIColor colorWithWhite:1.f alpha:1.f];
    }
}

+ (UIColor *)highlightedContentBackgroundColor
{
    if ([self hasBlurEffect]) {
        return [UIColor colorWithWhite:1.f alpha:0.6f];
    } else {
        return [UIColor colorWithWhite:1.f alpha:0.95f];
    }
}

@end
