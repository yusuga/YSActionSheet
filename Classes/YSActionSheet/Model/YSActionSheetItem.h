//
//  YSActionSheetItem.h
//  YSActionSheetExample
//
//  Created by Yu Sugawara on 2014/07/15.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YSActionSheet;
typedef BOOL(^YSActionSheetDidClickButton)(NSIndexPath *indexPath);

typedef NS_ENUM(NSInteger, YSActionSheetButtonType) {
    YSActionSheetButtonTypeDefault,
    YSActionSheetButtonTypeDestructive,
};

@interface YSActionSheetItem : NSObject

+ (instancetype)itemWithText:(NSString *)text
               textAlignment:(NSTextAlignment)textAlignment
                    textType:(YSActionSheetButtonType)textType
                       image:(UIImage *)image
               accessoryView:(UIView *)accessoryView
              didClickButton:(YSActionSheetDidClickButton)didClickButton;

+ (instancetype)itemWithAttributedText:(NSAttributedString *)attributedText
                         textAlignment:(NSTextAlignment)textAlignment
                                 image:(UIImage *)image
                         accessoryView:(UIView *)accessoryView
                        didClickButton:(YSActionSheetDidClickButton)didClickButton;

+ (instancetype)activityIndicatorItem;
+ (instancetype)activityIndicatorItemWithImage:(UIImage *)image;

@property (copy, nonatomic) NSString *text;                                 // Default attributes are used.
@property (nonatomic) NSAttributedString *attributedText;
@property (nonatomic) NSTextAlignment textAlignment;                        // Default is NSTextAlignmentCenter
@property (nonatomic) YSActionSheetButtonType buttonType;
@property (nonatomic) UIImage *image;
@property (nonatomic) UIView *accessoryView;
@property (nonatomic, getter=isClickDisabled) BOOL clickDisabled;
@property (copy, nonatomic) YSActionSheetDidClickButton didClickButton;
@property (nonatomic) BOOL activityIndicatorShown;

+ (UIFont*)defaultFont;
+ (UIColor*)defaultTextColor;
+ (UIColor*)destructiveTextColor;

@end
