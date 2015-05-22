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

@property (nonatomic) YSActionSheet *actionSheet;

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
    
    if (indexPath.section != 6) {
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
    }
    
    YSActionSheet *actionSheet = [[YSActionSheet alloc] init];
    
    YSImageFilter *filter = [[YSImageFilter alloc] init];
    filter.size = CGSizeMake(32, 32);
    
    if (indexPath.section == 6) {
        NSMutableArray *items = [NSMutableArray array];
        NSMutableArray *titles = [NSMutableArray array];
        NSUInteger sectionMax = 0;
        NSUInteger rowMax = 0;
        
        switch (indexPath.row) {
            case 0:
                sectionMax = 3;
                rowMax = 2;
                break;
            case 1:
                sectionMax = 2;
                rowMax = 4;
                break;
            case 2:
                sectionMax = 3;
                rowMax = 5;
                break;
            default:
                abort();
                break;
        }
        
        for (NSUInteger section = 0; section < sectionMax; section++) {
            [titles addObject:[NSString stringWithFormat:@"Section %zd", section]];
            NSMutableArray *secItems = [NSMutableArray array];
            for (NSUInteger row = 0; row < rowMax; row++) {
                [secItems addObject:[[YSActionSheetItem alloc] initWithTitle:[NSString stringWithFormat:@"Title %zd - %zd", section, row]
                                                                       image:[[UIImage imageNamed:@"cat"] ys_filter:filter]
                                                                        type:YSActionSheetButtonTypeDefault
                                                              didClickButton:^(NSIndexPath *indexPath) {
                                                                  NSLog(@"did click indexPath = %zd - %zd", indexPath.section, indexPath.row);
                                                              }]];
            }
            [items addObject:[NSArray arrayWithArray:secItems]];
        }
        
        [actionSheet setSectionTitles:[NSArray arrayWithArray:titles]
                                items:[NSArray arrayWithArray:items]];
    } else {
        NSMutableArray *items = [NSMutableArray arrayWithCapacity:[buttonTitles count]];
        for (NSString *buttonTitle in buttonTitles) {
            [items addObject:[[YSActionSheetItem alloc] initWithTitle:buttonTitle
                                                                image:indexPath.section == 0 ? nil : [[UIImage imageNamed:@"cat"] ys_filter:filter]
                                                                 type:YSActionSheetButtonTypeDefault
                                                       didClickButton:^(NSIndexPath *indexPath) {
                                                           NSLog(@"did click indexPath = %zd - %zd", indexPath.section, indexPath.row);
                                                       }]];
        }
        [actionSheet setItems:[NSArray arrayWithArray:items]];
    }
    
    __weak typeof(self) wself = self;
    [actionSheet setDidDismissViewcontrollerCompletion:^{
        NSLog(@"did dismiss");
        NSParameterAssert(wself.actionSheet);
        NSParameterAssert(!wself.actionSheet.isVisible);
        wself.actionSheet = nil;
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
    
    self.actionSheet = actionSheet;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor]; // workaround in iPad
}

#pragma mark -

- (IBAction)delayUpdateItemButtonDidPush:(id)sender
{
    [self performSelector:@selector(updateItem) withObject:nil afterDelay:3.];
}

- (void)updateItem
{
    if (!self.actionSheet.isVisible) {
        DDLogWarn(@"actionSheet is not displayed.");
        return ;
    }
    
    YSImageFilter *filter = [[YSImageFilter alloc] init];
    filter.size = CGSizeMake(32, 32);
    
    dd_func_info(nil);
    [self.actionSheet updateItemTitle:@"UPDATE"
                                image:[[UIImage imageNamed:@"cat2"] ys_filter:filter]
                         forIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

@end
