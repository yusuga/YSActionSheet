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

+ (instancetype)itemWithText:(NSString *)text
               textAlignment:(NSTextAlignment)textAlignment
                    textType:(YSActionSheetButtonType)textType
                       image:(UIImage *)image
               accessoryView:(UIView *)accessoryView
              didClickButton:(YSActionSheetDidClickButton)didClickButton
{
    YSActionSheetItem *item = [[YSActionSheetItem alloc] init];
    item.text = text;
    item.textAlignment = textAlignment;
    item.buttonType = textType;
    item.image = image;
    item.accessoryView = accessoryView;
    item.didClickButton = didClickButton;
    return item;
}

+ (instancetype)activityIndicatorItem;
{
    YSActionSheetItem *item = [[YSActionSheetItem alloc] init];
    item.activityIndicatorShown = YES;
    return item;
}

+ (instancetype)activityIndicatorItemWithImage:(UIImage *)image
{
    YSActionSheetItem *item = [self activityIndicatorItem];
    item.image = image;
    return item;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (NSAttributedString *)attributedText
{
    if (!self.text) return nil;
    return [[NSAttributedString alloc] initWithString:self.text
                                           attributes:[[self class] textAttributesForType:self.buttonType]];
}

#pragma mark - Utitliy

+ (NSDictionary *)textAttributesForType:(YSActionSheetButtonType)type
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
