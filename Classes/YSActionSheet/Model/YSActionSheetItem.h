//
//  YSActionSheetItem.h
//  YSActionSheetExample
//
//  Created by Yu Sugawara on 2014/07/15.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YSActionSheet;
typedef void(^YSActionSheetDidClickButton)(NSIndexPath *indexPath);

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

+ (instancetype)activityIndicatorItem;

@property (copy, nonatomic) NSString *text;
@property (nonatomic) NSTextAlignment textAlignment;    // Defailt is NSTextAlignmentCenter
@property (nonatomic) YSActionSheetButtonType textType;
@property (nonatomic) UIImage *image;
@property (nonatomic) UIView *accessoryView;
@property (copy, nonatomic) YSActionSheetDidClickButton didClickButton;
@property (nonatomic) BOOL activityIndicatorShown;

- (NSAttributedString *)attributedText;

@end
