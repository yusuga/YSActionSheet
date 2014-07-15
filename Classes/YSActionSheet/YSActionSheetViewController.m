//
//  YSActionSheetViewController.m
//  YSActionSheetExample
//
//  Created by Yu Sugawara on 2014/07/15.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import "YSActionSheetViewController.h"
#import "YSActionSheetContentViewController.h"

@interface YSActionSheetViewController () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *cancelTapGestureRecognizer;

@property (weak, nonatomic, readwrite) UIWindow *previousKeyWindow;
@property (nonatomic) UIWindow *window;

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *actionSheetView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (copy, nonatomic) NSString *cancelButtonTitle;

@property (weak, nonatomic) YSActionSheetContentViewController *contentViewController;
@property (weak, nonatomic) NSArray *items;

@end

@implementation YSActionSheetViewController

+ (instancetype)viewControllerWithCancelButtonTitle:(NSString *)cancelButtonTitle
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"YSActionSheet" bundle:nil];
    YSActionSheetViewController *vc = [sb instantiateInitialViewController];
    vc.cancelButtonTitle = cancelButtonTitle;
    return vc;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.cancelButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
    
    YSActionSheetContentViewController *contentViewController;
    for (YSActionSheetContentViewController *childVC in self.childViewControllers) {
        if ([childVC isKindOfClass:[YSActionSheetContentViewController class]]) {
            contentViewController = childVC;
            break;
        }
    }
    NSAssert1([contentViewController isKindOfClass:[YSActionSheetContentViewController class]], @"vc: %@", contentViewController);
    self.contentViewController = contentViewController;
    [self.contentViewController setActionSheetItems:self.items];
    
    __weak typeof(self) wself = self;
    self.contentViewController.didSelectRow = ^{
        [wself dismiss];
    };
    
    [self configureContainerViewLayout];
}

- (void)configureContainerViewLayout
{
    CGFloat cellHeight = [[self.contentViewController class] cellHeight];
    CGFloat allCellHeight = cellHeight*[self.items count];
    CGFloat containerHeight = self.containerView.bounds.size.height;
    if (allCellHeight < containerHeight) {
        CGRect f = self.containerView.frame;
        f.origin.y += containerHeight - allCellHeight;
        f.size.height = allCellHeight;
        self.containerView.frame = f;
        
        self.contentViewController.tableView.scrollEnabled = NO;
    } else {
        self.contentViewController.tableView.scrollEnabled = YES;
    }
}

- (void)showWithItems:(NSArray *)items
{
    self.items = items;
    
    self.previousKeyWindow = [UIApplication sharedApplication].keyWindow;
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.window.opaque = NO;
    self.window.rootViewController = self;
    [self.window makeKeyAndVisible];
    [self.window addSubview:self.view];    
    self.view.frame = self.window.bounds;
    
    CGRect f = self.actionSheetView.frame;
    f.origin.y = self.view.bounds.size.height;
    self.actionSheetView.frame = f;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundView.alpha = 1.f;
        self.actionSheetView.frame = self.window.bounds;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundView.alpha = 0.f;
        CGRect f = self.actionSheetView.frame;
        f.origin.y = self.actionSheetView.bounds.size.height;
        self.actionSheetView.frame = f;
    } completion:^(BOOL finished) {
        for (UIView *view in @[self.view, self.window]) {
            [view removeFromSuperview];
        }
        
        self.window = nil;
        [self.previousKeyWindow makeKeyAndVisible];
    }];
}

- (void)updateItemTitle:(NSString *)title image:(UIImage *)image atIndex:(NSUInteger)index
{
    [self.contentViewController updateItemTitle:title image:image atIndex:index];
}

#pragma mark -

- (IBAction)cancelButtonDidPush:(id)sender
{
    [self dismiss];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UITapGestureRecognizer *)gestureRecognizer
{
    if (self.cancelTapGestureRecognizer == gestureRecognizer) {
        CGPoint location = [gestureRecognizer locationInView:self.actionSheetView];
        if (CGRectContainsPoint(self.containerView.frame, location)) {
            return NO;
        }
    }
    return YES;
}

@end
