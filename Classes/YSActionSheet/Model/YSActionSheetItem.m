//
//  YSActionSheetItem.m
//  YSActionSheetExample
//
//  Created by Yu Sugawara on 2014/07/15.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import "YSActionSheetItem.h"

static CGFloat const kYSActionSheetButtonFontSize = 20.f;

@implementation YSActionSheetItem

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image type:(YSActionSheetButtonType)type didClickButton:(YSActionSheetDidClickButton)didClickButton
{
    if (self = [super init]) {
        self.title = title;
        self.image = image;
        self.type = type;
        self.didClickButton = didClickButton;
    }
    return self;
}

+ (NSDictionary*)textAttributesForType:(YSActionSheetButtonType)type
{
    switch (type) {
        default: NSAssert1(false, @"unsupported type: %zd", type);
        case YSActionSheetButtonTypeDefault:
            return @{NSFontAttributeName : [self font],
                     NSForegroundColorAttributeName : [self defaultTextColor]};
        case YSActionSheetButtonTypeDestructive:
            return @{NSFontAttributeName : [self font],
                     NSForegroundColorAttributeName : [self destructiveTextColor]};
            break;
    }
}

+ (UIFont*)font
{
    return [UIFont systemFontOfSize:kYSActionSheetButtonFontSize];
}

+ (UIColor*)defaultTextColor
{
    return [UIColor colorWithRed:0.f green:0.478f blue:1.f alpha:1.f];
}

+ (UIColor*)destructiveTextColor
{
    return [UIColor colorWithRed:1.f green:0.0745f blue:0.f alpha:1.f];
}

@end
