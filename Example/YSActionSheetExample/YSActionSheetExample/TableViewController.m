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
    
    NSString *title = indexPath.section == 5 ? nil : @"TITLE";
    NSString *cancel = @"Cancel";
    NSArray *buttonTitles = ^NSArray*{
        NSMutableArray *titles = @[].mutableCopy;
        NSUInteger maxCount = ^NSUInteger{
            NSUInteger maxCount = 3;
            CGSize size = [UIScreen mainScreen].bounds.size;
            
            switch (indexPath.section) {
                case 1:
                case 2:
                {
                    CGFloat height = MAX(size.width, size.height) - 8.f - 8.f - 60.f - 8.f;
                    maxCount = ceil(height/44.f);
                    if (indexPath.section == 2) {
                        maxCount += 1;
                    }
                    break;
                }
                case 3:
                {
                    CGFloat height = MIN(size.width, size.height) - 8.f - 8.f - 60.f - 8.f;
                    maxCount = floor(height/44.f);
                }
                default:
                    break;
            }
            return maxCount;
        }();
        
        for (NSUInteger count = 0; count < maxCount; count++) {
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
    
    if (indexPath.section == 4) {
        [actionSheet setHeaderTitleView:[[UISwitch alloc] init]];
    } else {
        [actionSheet setHeaderTitle:title];
    }
    
    [actionSheet show];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor]; // workaround in iPad
}

@end
