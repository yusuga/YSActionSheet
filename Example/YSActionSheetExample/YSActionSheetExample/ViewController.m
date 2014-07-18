//
//  ViewController.m
//  YSActionSheetExample
//
//  Created by Yu Sugawara on 2014/07/15.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import "ViewController.h"
#import "YSActionSheet.h"
#import <YSImageFilter/UIImage+YSImageFilter.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self showButtonDidPush:nil];
}

- (IBAction)showButtonDidPush:(id)sender
{
    YSActionSheet *actionSheet = [[YSActionSheet alloc] init];
    
    YSImageFilter *filter = [[YSImageFilter alloc] init];
    filter.size = CGSizeMake(32, 32);
    
    for (NSUInteger i = 0; i < 1; i++) {
        [actionSheet addItem:[[YSActionSheetItem alloc] initWithTitle:@"title 1"
                                                                image:[[UIImage imageNamed:@"cat"] ys_filter:filter]
                                                                 type:YSActionSheetButtonTypeDefault
                                                       didClickButton:^{
                                                           NSLog(@"did click 1");
                                                       }]];
        [actionSheet addItem:[[YSActionSheetItem alloc] initWithTitle:@"title 2"
                                                                image:nil
                                                                 type:YSActionSheetButtonTypeDestructive
                                                       didClickButton:^{
                                                           NSLog(@"did click 2");
                                                       }]];
    }
    
    [actionSheet setDidDismissViewcontrollerCompletion:^{
        NSLog(@"did dismiss");
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"TITLE";
    [label sizeToFit];
    [actionSheet setTitleView:label];
    
    [actionSheet show];
    
#if 0
    [self performSelector:@selector(updateItemForActionSheet:) withObject:actionSheet afterDelay:3.];
#endif
}

- (void)updateItemForActionSheet:(YSActionSheet*)actionSheet
{
    [actionSheet updateItemTitle:@"Updated title" image:nil atIndex:0];
}

@end
