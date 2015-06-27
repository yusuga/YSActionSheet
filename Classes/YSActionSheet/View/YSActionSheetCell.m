//
//  YSActionSheetCell.m
//  YSActionSheetExample
//
//  Created by Yu Sugawara on 2015/03/11.
//  Copyright (c) 2015年 Yu Sugawara. All rights reserved.
//

#import "YSActionSheetCell.h"
#import "YSActionSheetUtility.h"

@interface YSActionSheetCell ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation YSActionSheetCell

+ (UINib*)nib
{
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
}

- (void)configureWithItem:(YSActionSheetItem *)item
{
    self.textLabel.attributedText = [item attributedText];
    self.textLabel.textAlignment = item.textAlignment;
    
    self.imageView.image = item.image;
    
    self.accessoryView = item.accessoryView;
    
    [self activityIndicatorShown:item.activityIndicatorShown];
    
    [self setNeedsDisplay];
}

- (void)activityIndicatorShown:(BOOL)shown
{
    self.textLabel.alpha = !shown;
    self.detailTextLabel.alpha = !shown;

    self.activityIndicatorView.alpha = shown;
    if (shown) {
        [self.activityIndicatorView startAnimating];
    } else {
        [self.activityIndicatorView stopAnimating];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (self.highlighted) {
        [[YSActionSheetUtility highlightedContentBackgroundColor] set];
    } else {
        [[YSActionSheetUtility contentBackgroundColor] set];
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextFillRect(context, CGRectMake(rect.origin.x,
                                          rect.origin.y,
                                          rect.size.width,
                                          rect.size.height - 1.f/[UIScreen mainScreen].scale));
}

@end
