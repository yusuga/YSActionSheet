//
//  YSActionSheet.m
//  YSActionSheetExample
//
//  Created by Yu Sugawara on 2014/07/15.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import "YSActionSheet.h"
#import "YSActionSheetTableViewController.h"
#import "YSActionSheetItem.h"
#import "YSActionSheetUtility.h"

@interface YSActionSheet () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *actionSheetArea;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *actionSheetAreaWidthConstraint;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (nonatomic) NSString *cancelButtonTitle;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *cancelTapGestureRecognizer;

@property (nonatomic) UIWindow *window;
@property (weak, nonatomic, readwrite) UIWindow *previousKeyWindow;
@property (nonatomic) YSActionSheetTableViewController *tableViewController;

@end

@implementation YSActionSheet

#pragma mark - Initial

- (instancetype)init
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"YSActionSheet" bundle:nil];
    self = [sb instantiateInitialViewController];
    if (self) {
        self.tableViewController = [YSActionSheetTableViewController viewController];
        self.windowLevel = UIWindowLevelStatusBar - 1.;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.cancelButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
    
    __weak typeof(self) wself = self;
    self.tableViewController.didSelectRow = ^{
        [wself dismiss];
    };
}

- (void)viewWillLayoutSubviews
{
    /* ActionSheetArea constraint */
    
    self.actionSheetAreaWidthConstraint.constant = MIN(self.view.bounds.size.width, self.view.bounds.size.height);
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.actionSheetAreaWidthConstraint.constant /= 2.;
    }
}

#pragma mark - Single section item

- (void)setItems:(NSArray *)items
{
    [self.tableViewController setItems:items];
}

- (void)replaceItem:(YSActionSheetItem *)item forIndex:(NSUInteger)index
{
    [self replaceItem:item forIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
}

#pragma mark - Multiple section item

- (void)setSectionTitles:(NSArray *)sectionTitles
                   items:(NSArray *)items
{
    NSAssert2([sectionTitles count] == [items count], @"[sectionTitles count](%zd) != [items count](%zd)", [sectionTitles count], [items count]);
    [self.tableViewController setSectionTitles:sectionTitles
                                         items:items];
}

- (void)setSectionViews:(NSArray *)sectionViews
                  items:(NSArray *)items
{
    [self.tableViewController setSectionViews:sectionViews
                                        items:items];
}

- (void)replaceItem:(YSActionSheetItem *)item forIndexPath:(NSIndexPath *)indexPath
{
    [self.tableViewController replaceItem:item
                             forIndexPath:indexPath];
}

#pragma mark - Items

- (NSArray *)items
{
    return self.tableViewController.items;
}

#pragma mark - Header

- (void)setHeaderTitle:(NSString *)title
{
    self.tableViewController.headerTitle = title;
}

- (void)setHeaderTitleView:(UIView *)titleView
{
    self.tableViewController.headerTitleView = titleView;
}

#pragma mark - Cancel

- (void)setCancelButtonTitle:(NSString *)title
{
    _cancelButtonTitle = [title copy];
    if (self.cancelButton) {
        [self.cancelButton setTitle:title forState:UIControlStateNormal];
    }
}

#pragma mark - Heights

- (void)setRowHeight:(CGFloat)rowHeight
{
    self.tableViewController.rowHeight = rowHeight;
}

- (void)setSectionHeaderHeight:(CGFloat)sectionHeaderHeight
{
    self.tableViewController.sectionHeaderHeight = sectionHeaderHeight;
}

#pragma mark - Show

- (void)show
{
    self.previousKeyWindow = [UIApplication sharedApplication].keyWindow;
    if ([self.previousKeyWindow.rootViewController isKindOfClass:[self class]]) {
#ifdef DDLogWarn
        DDLogWarn(@"Double startup of the %@", NSStringFromClass([self class]));
#endif
        return;
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.windowLevel = [self windowLevel];
    self.window.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.window.opaque = NO;
    self.window.rootViewController = self;
    [self.window makeKeyAndVisible];
    [self.window addSubview:self.view];
    self.view.frame = self.window.bounds;
    
    self.actionSheetArea.frame = ^CGRect{
        CGRect frame = self.actionSheetArea.frame;
        frame.origin.y = self.view.bounds.size.height;
        return frame;
    }();
    
    self.tableViewController.view.frame = self.contentView.bounds;
    [self.contentView addSubview:self.tableViewController.view];
    [self addChildViewController:self.tableViewController];
    [self.tableViewController didMoveToParentViewController:self];
    
    [UIView animateWithDuration:0.4
                          delay:0.15
         usingSpringWithDamping:1.
          initialSpringVelocity:0.
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^
     {
         self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
         self.actionSheetArea.frame = ^CGRect{
             CGRect frame = self.actionSheetArea.frame;
             frame.origin.y = 0.f;
             return frame;
         }();
     } completion:NULL];
}

#pragma mark - Reload Data

- (void)reloadData
{
    [self.tableViewController.tableView reloadData];
    [self.tableViewController.tableView setNeedsLayout];
    [self.tableViewController.tableView layoutIfNeeded];
}

#pragma mark - Dismiss

- (void)dismiss
{
    [UIView animateWithDuration:0.4
                          delay:0.
         usingSpringWithDamping:1.f
          initialSpringVelocity:0.f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^
     {
         self.view.backgroundColor = [UIColor clearColor];
         self.actionSheetArea.frame = ^CGRect{
             CGRect frame = self.actionSheetArea.frame;
             frame.origin.y = self.view.bounds.size.height;
             return frame;
         }();
     } completion:^(BOOL finished) {
         [self.view removeFromSuperview];
         [self.window removeFromSuperview];
         self.window = nil;
         
         [self.previousKeyWindow makeKeyAndVisible];
         
         if (self.didDismiss) self.didDismiss();
     }];
}

#pragma mark - State

- (BOOL)isVisible
{
    return self.window != nil;
}

#pragma mark - Button action

- (IBAction)cancelButtonDidPush:(id)sender
{
    if (self.didCancel) self.didCancel();
    [self dismiss];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UITapGestureRecognizer *)gestureRecognizer
{
    if (self.cancelTapGestureRecognizer == gestureRecognizer) {
        CGPoint location = [gestureRecognizer locationInView:self.actionSheetArea];
        if (CGRectContainsPoint(self.tableViewController.tableView.frame, location)) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - StatusBar

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return [UIApplication sharedApplication].statusBarStyle;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

@end
