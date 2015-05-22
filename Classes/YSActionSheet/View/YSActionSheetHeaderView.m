//
//  YSActionSheetHeaderView.m
//  YSActionSheetExample
//
//  Created by Yu Sugawara on 5/23/15.
//  Copyright (c) 2015 Yu Sugawara. All rights reserved.
//

#import "YSActionSheetHeaderView.h"
#import "YSActionSheetUtility.h"

@interface YSActionSheetHeaderView ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewBottomConstraint;

@end

@implementation YSActionSheetHeaderView

- (id)init
{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
    self = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
    self.contentView.backgroundColor = [YSActionSheetUtility contentBackgroundColor];
    self.contentViewBottomConstraint.constant = 1.f/[UIScreen mainScreen].scale;
    return self;
}

@end
