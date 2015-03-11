//
//  YSActionSheetViewController.m
//  YSActionSheetExample
//
//  Created by Yu Sugawara on 2014/07/15.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import "YSActionSheetViewController.h"
#import "YSActionSheetButtonsViewController.h"
#import "YSActionSheetItem.h"

@interface YSActionSheetViewController () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *cancelTapGestureRecognizer;

@property (weak, nonatomic, readwrite) UIWindow *previousKeyWindow;
@property (nonatomic) UIWindow *window;

@property (weak, nonatomic) IBOutlet UIView *actionSheetArea;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *actionSheetAreaWidthConstraint;
@property (weak, nonatomic) IBOutlet UIView *buttonsContainerView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (weak, nonatomic) YSActionSheetButtonsViewController *buttonsViewController;
@property (nonatomic) NSMutableArray *items;

@end

@implementation YSActionSheetViewController

+ (instancetype)viewController
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"YSActionSheet" bundle:nil];
    YSActionSheetViewController *vc = [sb instantiateInitialViewController];
    return vc;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.items = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.cancelButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
    
    YSActionSheetButtonsViewController *buttonsVC;
    for (YSActionSheetButtonsViewController *vc in self.childViewControllers) {
        if ([vc isKindOfClass:[YSActionSheetButtonsViewController class]]) {
            buttonsVC = vc;
            break;
        }
    }
    
    NSAssert1([buttonsVC isKindOfClass:[YSActionSheetButtonsViewController class]], @"vc: %@", buttonsVC);
    self.buttonsViewController = buttonsVC;
    [self.buttonsViewController setActionSheetItems:self.items];
    
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

#pragma mark - Item

- (void)addItem:(YSActionSheetItem *)item
{
    [self.items addObject:item];
}

- (void)updateItemTitle:(NSString *)title image:(UIImage *)image atIndex:(NSUInteger)index
{
    YSActionSheetItem *item = self.items[index];
    if (item) {
        if (title) {
            item.title = title;
        }
        if (image) {
            item.image = image;
        }
        [self.buttonsViewController.tableView reloadData];
    }
}

#pragma mark - show, dismiss

- (void)show
{
    self.previousKeyWindow = [UIApplication sharedApplication].keyWindow;
    if ([self.previousKeyWindow.rootViewController isKindOfClass:[self class]]) {
        DDLogError(@"Double startup of the %@", NSStringFromClass([self class]));
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
  
    if (self.headerTitle.length) {
        [self.buttonsViewController setHeaderTitle:self.headerTitle];
    } else if (self.headerTitleView) {
        [self.buttonsViewController setHeaderTitleView:self.headerTitleView];
    }
    
    self.actionSheetArea.frame = ^CGRect{
        CGRect frame = self.actionSheetArea.frame;
        frame.origin.y = self.view.bounds.size.height;
        return frame;
    }();
    
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
         for (UIView *view in @[self.view, self.window]) {
             [view removeFromSuperview];
         }
         
         self.window = nil;
         [self.previousKeyWindow makeKeyAndVisible];
         
         if (self.didDismissViewcontroller) self.didDismissViewcontroller();
     }];
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
