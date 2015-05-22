//
//  YSActionSheetHeaderView.h
//  YSActionSheetExample
//
//  Created by Yu Sugawara on 5/23/15.
//  Copyright (c) 2015 Yu Sugawara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YSActionSheetHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelLeadingConstraint;

@end
