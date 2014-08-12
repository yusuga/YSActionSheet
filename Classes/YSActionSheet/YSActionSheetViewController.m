//
//  YSActionSheetViewController.m
//  YSActionSheetExample
//
//  Created by Yu Sugawara on 2014/07/15.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import "YSActionSheetViewController.h"
#import "YSActionSheetContentViewController.h"
#import "YSActionSheetItem.h"

@interface YSActionSheetViewController () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *cancelTapGestureRecognizer;

@property (weak, nonatomic, readwrite) UIWindow *previousKeyWindow;
@property (nonatomic) UIWindow *window;

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *actionSheetView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (nonatomic) NSString *headerTitle;
@property (nonatomic) UIView *headerTitleView;

@property (weak, nonatomic) YSActionSheetContentViewController *contentViewController;
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
    
    YSActionSheetContentViewController *contentViewController;
    for (UINavigationController *nc in self.childViewControllers) {
        if ([nc isKindOfClass:[UINavigationController class]]) {
            YSActionSheetContentViewController *topVC = (id)nc.topViewController;
            if ([topVC isKindOfClass:[YSActionSheetContentViewController class]]) {
                contentViewController = topVC;
                break;
            }
        }
    }
    NSAssert1([contentViewController isKindOfClass:[YSActionSheetContentViewController class]], @"vc: %@", contentViewController);
    self.contentViewController = contentViewController;
    [self.contentViewController setActionSheetItems:self.items];
    
    __weak typeof(self) wself = self;
    self.contentViewController.didSelectRow = ^{
        [wself dismiss];
    };
}

#pragma mark - item

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
        [self.contentViewController.tableView reloadData];
    }
}

#pragma mark - show, dismiss

- (void)show
{
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

    UIView *titleView;
    if (self.headerTitleView) {
        titleView = self.headerTitleView;
    } else if (self.headerTitle.length) {
        UILabel *label = [[UILabel alloc] init];
        label.text = self.headerTitle;
        label.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
        label.textColor = [UIColor lightGrayColor];
        [label sizeToFit];
        titleView = label;
    }
    self.contentViewController.navigationItem.titleView = titleView;
    [self.contentViewController.navigationController setNavigationBarHidden:titleView ? NO : YES animated:NO];
    [self configureContainerViewLayout];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundView.alpha = 1.f;
        self.actionSheetView.frame = self.window.bounds;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)configureContainerViewLayout
{
    CGFloat cellHeight = [[self.contentViewController class] cellHeight];
    CGFloat allCellHeight = cellHeight*[self.items count];
    if (self.contentViewController.navigationItem.titleView) {
        allCellHeight += self.contentViewController.navigationController.navigationBar.bounds.size.height;
    }
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
        CGPoint location = [gestureRecognizer locationInView:self.actionSheetView];
        if (CGRectContainsPoint(self.containerView.frame, location)) {
            return NO;
        }
    }
    return YES;
}

@end
