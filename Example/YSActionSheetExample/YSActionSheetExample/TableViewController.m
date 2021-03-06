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
    
    if (indexPath.section < 6) {
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
    
    YSImageFilter *filter = [self imageFilter];
    
    switch (indexPath.section) {
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        {
            NSMutableArray *items = [NSMutableArray arrayWithCapacity:[buttonTitles count]];
            for (NSString *buttonTitle in buttonTitles) {
                [items addObject:[YSActionSheetItem itemWithText:buttonTitle
                                                   textAlignment:indexPath.section == 0 ? NSTextAlignmentCenter : NSTextAlignmentLeft
                                                        textType:YSActionSheetButtonTypeDefault
                                                           image:indexPath.section == 0 ? nil : [[UIImage imageNamed:@"cat"] ys_filter:filter]
                                                   accessoryView:nil
                                                  didClickButton:^BOOL(NSIndexPath *indexPath) {
                                                      NSLog(@"did click indexPath = %zd - %zd", indexPath.section, indexPath.row);
                                                      return YES;
                                                  }]];
            }
            [actionSheet setItems:[NSArray arrayWithArray:items]];
            break;
        }
        case 6:
        {
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
                    [secItems addObject:[YSActionSheetItem itemWithText:[NSString stringWithFormat:@"Title %zd - %zd", section, row]
                                                          textAlignment:NSTextAlignmentLeft
                                                               textType:YSActionSheetButtonTypeDefault
                                                                  image:[[UIImage imageNamed:@"cat"] ys_filter:filter]
                                                          accessoryView:nil
                                                         didClickButton:^BOOL(NSIndexPath *indexPath) {
                                                             NSLog(@"did click indexPath = %zd - %zd", indexPath.section, indexPath.row);
                                                             return YES;
                                                         }]];
                }
                [items addObject:[NSArray arrayWithArray:secItems]];
            }
            
            [actionSheet setSectionTitles:[NSArray arrayWithArray:titles]
                                    items:[NSArray arrayWithArray:items]];
            break;
        }
        case 7:
        {
            switch (indexPath.row) {
                case 0:
                {
                    [actionSheet setSectionTitles:@[@"Section 0", @"Section 1"]
                                            items:@[@[[YSActionSheetItem activityIndicatorItem]],
                                                    @[[YSActionSheetItem activityIndicatorItem]]]];
                    break;
                }
                case 1:
                    [actionSheet setSectionTitles:@[@"Section 0", @"Section 1"]
                                            items:@[@[[YSActionSheetItem activityIndicatorItemWithImage:[[UIImage imageNamed:@"cat"] ys_filter:filter]]],
                                                    @[[YSActionSheetItem activityIndicatorItemWithImage:[[UIImage imageNamed:@"cat"] ys_filter:filter]]]]];
                    break;
                case 2:
                {
                    UILabel *label = [[UILabel alloc] init];
                    label.text = @"Accessory";
                    label.textColor = [UIColor lightGrayColor];
                    label.font = [UIFont systemFontOfSize:12.f];
                    [label sizeToFit];                    
                    
                    [actionSheet setItems:@[[YSActionSheetItem itemWithText:@"TEXT"
                                                              textAlignment:NSTextAlignmentLeft
                                                                   textType:YSActionSheetButtonTypeDefault
                                                                      image:[[UIImage imageNamed:@"cat"] ys_filter:filter]
                                                              accessoryView:label
                                                             didClickButton:^BOOL(NSIndexPath *indexPath) {
                                                                 NSLog(@"did click indexPath = %zd - %zd", indexPath.section, indexPath.row);
                                                                 return YES;
                                                             }]]];
                    break;
                }
                case 3:
                {
                    [actionSheet setSectionTitles:@[@"Section height 40"]
                                            items:@[@[[YSActionSheetItem itemWithText:@"Row height 80"
                                                                      textAlignment:NSTextAlignmentLeft
                                                                           textType:YSActionSheetButtonTypeDefault
                                                                              image:[[UIImage imageNamed:@"cat"] ys_filter:[self imageFilter]]
                                                                      accessoryView:nil
                                                                     didClickButton:^BOOL(NSIndexPath *indexPath) {
                                                                         NSLog(@"did click indexPath = %zd - %zd", indexPath.section, indexPath.row);
                                                                         return YES;
                                                                     }]]]];
                    [actionSheet setRowHeight:80.];
                    [actionSheet setSectionHeaderHeight:40.];
                    break;
                }
                case 4:
                {
                    YSImageFilter *filter = [self imageFilter];
                    
                    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:@"Custom(Bold 15, BlackColor)"
                                                                                  attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:15.],
                                                                                               NSForegroundColorAttributeName : [UIColor blackColor]}];
                    
                    NSArray *items = @[[YSActionSheetItem itemWithText:@"TypeDefault"
                                                         textAlignment:NSTextAlignmentLeft
                                                              textType:YSActionSheetButtonTypeDefault
                                                                 image:[[UIImage imageNamed:@"cat"] ys_filter:filter]
                                                         accessoryView:nil
                                                        didClickButton:^BOOL(NSIndexPath *indexPath) {
                                                            NSLog(@"did click indexPath = %zd - %zd", indexPath.section, indexPath.row);
                                                            return YES;
                                                        }],
                                       [YSActionSheetItem itemWithText:@"TypeDestructive"
                                                         textAlignment:NSTextAlignmentLeft
                                                              textType:YSActionSheetButtonTypeDestructive
                                                                 image:[[UIImage imageNamed:@"cat"] ys_filter:filter]
                                                         accessoryView:nil
                                                        didClickButton:^BOOL(NSIndexPath *indexPath) {
                                                            NSLog(@"did click indexPath = %zd - %zd", indexPath.section, indexPath.row);
                                                            return YES;
                                                        }],
                                       [YSActionSheetItem itemWithAttributedText:attrStr
                                                                   textAlignment:NSTextAlignmentLeft
                                                                           image:[[UIImage imageNamed:@"cat"] ys_filter:filter]
                                                                   accessoryView:nil
                                                                  didClickButton:^BOOL(NSIndexPath *indexPath) {
                                                                      NSLog(@"did click indexPath = %zd - %zd", indexPath.section, indexPath.row);
                                                                      return YES;
                                                                  }]];
                    [actionSheet setItems:items];
                    break;
                }
                case 5:
                {
                    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:@"Click Disabled"
                                                                                  attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18.],
                                                                                               NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
                    YSActionSheetItem *item = [YSActionSheetItem itemWithAttributedText:attrStr
                                                                          textAlignment:NSTextAlignmentCenter
                                                                                  image:nil
                                                                          accessoryView:nil
                                                                         didClickButton:^BOOL(NSIndexPath *indexPath) {
                                                                             abort();
                                                                         }];
                    item.clickDisabled = YES;
                    [actionSheet setItems:@[item]];
                    break;
                }
                case 6:
                {
                    NSMutableArray *items = [NSMutableArray arrayWithCapacity:[buttonTitles count]];
                    for (NSString *buttonTitle in buttonTitles) {
                        [items addObject:[YSActionSheetItem itemWithText:buttonTitle
                                                           textAlignment:indexPath.section == 0 ? NSTextAlignmentCenter : NSTextAlignmentLeft
                                                                textType:YSActionSheetButtonTypeDefault
                                                                   image:indexPath.section == 0 ? nil : [[UIImage imageNamed:@"cat"] ys_filter:filter]
                                                           accessoryView:nil
                                                          didClickButton:^BOOL(NSIndexPath *indexPath) {
                                                              NSLog(@"did click indexPath = %zd - %zd", indexPath.section, indexPath.row);
                                                              return YES;
                                                          }]];
                    }
                    [actionSheet setItems:[NSArray arrayWithArray:items]];
                    break;
                }
                default:
                    abort();
            }
            break;
        }
        case 8:
        {
            NSMutableArray *items = [NSMutableArray array];
            NSMutableArray *views = [NSMutableArray array];
            NSUInteger sectionMax = 0;
            NSUInteger rowMax = 0;
            
            switch (indexPath.row) {
                case 0:
                    sectionMax = 3;
                    rowMax = 1;
                    break;
                case 1:
                    sectionMax = 2;
                    rowMax = 3;
                    break;
                case 2:
                    sectionMax = 3;
                    rowMax = 4;
                    break;
                case 3:
                    sectionMax = 4;
                    rowMax = 2;
                    break;
                default:
                    abort();
                    break;
            }
            
            for (NSUInteger section = 0; section < sectionMax; section++) {
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0., 0., 0., 60.)];
                view.backgroundColor = [UIColor blueColor];
                [view addSubview:[[UISwitch alloc] init]];
                if (indexPath.row == 3) {
                    [views addObject:section == 0 ? view : [NSNull null]];
                } else {
                    [views addObject:view];
                }
                
                NSMutableArray *secItems = [NSMutableArray array];
                for (NSUInteger row = 0; row < rowMax; row++) {
                    [secItems addObject:[YSActionSheetItem itemWithText:[NSString stringWithFormat:@"Title %zd - %zd", section, row]
                                                          textAlignment:NSTextAlignmentLeft
                                                               textType:YSActionSheetButtonTypeDefault
                                                                  image:[[UIImage imageNamed:@"cat"] ys_filter:filter]
                                                          accessoryView:nil
                                                         didClickButton:^BOOL(NSIndexPath *indexPath) {
                                                             NSLog(@"did click indexPath = %zd - %zd", indexPath.section, indexPath.row);
                                                             return YES;
                                                         }]];
                }
                [items addObject:[secItems copy]];
            }
            
            [actionSheet setSectionViews:[views copy]
                                   items:[items copy]];
            break;
        }
        default:
            break;
    }
    
    __weak typeof(self) wself = self;
    actionSheet.didDismiss = ^{
        NSLog(@"did dismiss");
        NSParameterAssert(wself.actionSheet);
        NSParameterAssert(!wself.actionSheet.isVisible);
        wself.actionSheet = nil;
    };
    
    actionSheet.didCancel = ^{
        NSLog(@"did cancel");
    };
    
    if (indexPath.section == 4) {
        UISwitch *headerSwitch = [[UISwitch alloc] init];
        [headerSwitch addTarget:self
                         action:@selector(headerSwitchDidChange:)
               forControlEvents:UIControlEventValueChanged];
        [actionSheet setHeaderTitleView:headerSwitch];
    } else if ([indexPath compare:[NSIndexPath indexPathForRow:6 inSection:7]] == NSOrderedSame) {
        UISwitch *headerSwitch = [[UISwitch alloc] init];
        [headerSwitch addTarget:self
                         action:@selector(hiddenSwitchChanged:)
               forControlEvents:UIControlEventValueChanged];
        [actionSheet setHeaderTitleView:headerSwitch];
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

- (void)headerSwitchDidChange:(UISwitch *)sender
{
    YSActionSheetItem *item = [self.actionSheet.items firstObject];
    item.image = [[UIImage imageNamed:[NSString stringWithFormat:@"cat%@", sender.on ? @"2" : @""]] ys_filter:[self imageFilter]];
    [self.actionSheet reloadData];
}

- (void)hiddenSwitchChanged:(UISwitch *)sender
{
    YSActionSheetItem *item = [self.actionSheet.items firstObject];
    item.hidden = sender.on;
    [self.actionSheet reloadData];
}

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
    
    dd_func_info(nil);
    __weak YSActionSheet *weakActionSheet = self.actionSheet;
    [self.actionSheet replaceItem:[YSActionSheetItem itemWithText:@"UPDATE"
                                                   textAlignment:NSTextAlignmentLeft
                                                        textType:YSActionSheetButtonTypeDefault
                                                           image:[[UIImage imageNamed:@"cat2"] ys_filter:[self imageFilter]]
                                                   accessoryView:nil
                                                  didClickButton:^BOOL(NSIndexPath *indexPath) {
                                                      NSLog(@"did click indexPath = %zd - %zd", indexPath.section, indexPath.row);
                                                      [RMUniversalAlert showAlertInViewController:weakActionSheet
                                                                                        withTitle:@"Title"
                                                                                          message:nil
                                                                                cancelButtonTitle:@"OK"
                                                                           destructiveButtonTitle:nil
                                                                                otherButtonTitles:nil
                                                                                         tapBlock:nil];
                                                      return NO;
                                                  }] forIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

#pragma mark -

- (YSImageFilter *)imageFilter
{
    YSImageFilter *filter = [[YSImageFilter alloc] init];
    filter.size = CGSizeMake(32, 32);
    filter.mask = YSImageFilterMaskRoundedCornersIOS7RadiusRatio;

    return filter;
}

@end
