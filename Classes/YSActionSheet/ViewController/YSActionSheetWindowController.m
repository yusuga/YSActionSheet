//
//  YSActionSheetWindowController.m
//  YSActionSheetExample
//
//  Created by Yu Sugawara on 2014/07/15.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import "YSActionSheetWindowController.h"
#import "YSActionSheetItem.h"
#import "YSActionSheetUtility.h"

@interface YSActionSheetWindowController () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *cancelTapGestureRecognizer;

@property (weak, nonatomic, readwrite) UIWindow *previousKeyWindow;
@property (nonatomic) UIWindow *window;

@property (nonatomic, readwrite) YSActionSheetTableViewController *buttonsViewController;

@property (weak, nonatomic) IBOutlet UIView *actionSheetArea;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *actionSheetAreaWidthConstraint;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation YSActionSheetWindowController

+ (instancetype)viewController
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"YSActionSheet" bundle:nil];
    YSActionSheetWindowController *vc = [sb instantiateInitialViewController];
    vc.buttonsViewController = [YSActionSheetTableViewController viewController];
    return vc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    __weak typeof(self) wself = self;
    self.buttonsViewController.didSelectRow = ^{
        [wself dismiss];
    };
}

- (void)viewWillLayoutSubviews
{
    /* ActionSheetArea constraint */
    
    self.actionSheetAreaWidthConstraint.constant = MIN(self.view.bounds.size.width, self.view.bounds.size.height);
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.actionSheetAreaWidthConstraint.constant /= 2.f;
    }
}

- (void)setCancelButtonTitle:(NSString *)title
{
    [self.cancelButton setTitle:title forState:UIControlStateNormal];
}

#pragma mark - show, dismiss

- (void)show
{
    self.previousKeyWindow = [UIApplication sharedApplication].keyWindow;
    if ([self.previousKeyWindow.rootViewController isKindOfClass:[self class]]) {
        dd_func_warn(@"Double startup of the %@", NSStringFromClass([self class]));
        return;
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.windowLevel = UIWindowLevelStatusBar + CGFLOAT_MIN;
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
    
    self.buttonsViewController.view.frame = self.contentView.bounds;
    [self.contentView addSubview:self.buttonsViewController.view];
    [self addChildViewController:self.buttonsViewController];
    [self.buttonsViewController didMoveToParentViewController:self];
    
    [UIView animateWithDuration:0.4
                          delay:0.15
         usingSpringWithDamping:1.f
          initialSpringVelocity:0.f
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
         
         if (self.didDismissViewcontroller) self.didDismissViewcontroller();
     }];
}

- (BOOL)isVisible
{
    return self.window != nil;
}

#pragma mark - button action

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
        if (CGRectContainsPoint(self.buttonsViewController.tableView.frame, location)) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - StatusBar

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return [self.previousKeyWindow.rootViewController preferredStatusBarStyle];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

@end
