//
//  TableViewController.m
//  YSActionSheetExample
//
//  Created by Yu Sugawara on 2015/03/09.
//  Copyright (c) 2015年 Yu Sugawara. All rights reserved.
//

#import "TableViewController.h"
#import <RMUniversalAlert/RMUniversalAlert.h>
#import "YSActionSheet.h"
#import <YSImageFilter/UIImage+YSImageFilter.h>

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

#if 1
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cat"]];
#else
    self.view.backgroundColor = [UIColor blueColor];
#endif
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSString *title = @"TITLE";
    NSString *cancel = @"Cancel";
    NSArray *buttonTitles = ^NSArray*{
        NSMutableArray *titles = @[].mutableCopy;
        for (NSUInteger count = 0; count < (indexPath.section ? 10 : 3); count++) {
            [titles addObject:[NSString stringWithFormat:@"other%zd", count+1]];
        }
        return [NSArray arrayWithArray:titles];
    }();
    
    switch (indexPath.row) {
        case 0:
        {
            [RMUniversalAlert showActionSheetInViewController:self
                                                    withTitle:title
                                                      message:nil
                                            cancelButtonTitle:cancel
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:buttonTitles
                           popoverPresentationControllerBlock:^(RMPopoverPresentationController *popover) {
                               popover.sourceView = self.view;
                               popover.sourceRect = cell.frame;
                           } tapBlock:^(RMUniversalAlert *alert, NSInteger buttonIndex) {
                               
                           }];
            return;
        }
        default:
            break;
    }
    
    YSActionSheet *actionSheet = [[YSActionSheet alloc] init];
    
    YSImageFilter *filter = [[YSImageFilter alloc] init];
    filter.size = CGSizeMake(32, 32);
    
    
    for (NSString *buttonTitle in buttonTitles) {
        [actionSheet addItem:[[YSActionSheetItem alloc] initWithTitle:buttonTitle
                                                                image:[[UIImage imageNamed:@"cat"] ys_filter:filter]
                                                                 type:YSActionSheetButtonTypeDefault
                                                       didClickButton:^(NSInteger selectedIndex) {
                                                           NSLog(@"did click %zd", selectedIndex);
                                                       }]];
    }
    
    [actionSheet setDidDismissViewcontrollerCompletion:^{
        NSLog(@"did dismiss");
    }];
    
    [actionSheet setCancelButtonDidPush:^{
        NSLog(@"did cancel");
    }];
    
    if (indexPath.row == 1) {
        [actionSheet setHeaderTitle:title];
    } else {
        UILabel *label = [[UILabel alloc] init];
        label.text = title;
        [label sizeToFit];
        [actionSheet setHeaderTitleView:label];
    }
    
    [actionSheet show];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor]; // workaround in iPad
}

@end
