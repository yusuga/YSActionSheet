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

- (instancetype)initWithTitle:(NSString*)title
                        image:(UIImage*)image
                         type:(YSActionSheetButtonType)type
               didClickButton:(YSActionSheetDidClickButton)didClickButton;

@property (copy, nonatomic) NSString *title;
@property (nonatomic) UIImage *image;
@property (nonatomic) YSActionSheetButtonType type;
@property (copy, nonatomic) YSActionSheetDidClickButton didClickButton;

+ (NSDictionary*)textAttributesForType:(YSActionSheetButtonType)type;

@end
