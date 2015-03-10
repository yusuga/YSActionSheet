//
//  YSActionSheetContentViewController.m
//  YSActionSheetExample
//
//  Created by Yu Sugawara on 2014/07/15.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import "YSActionSheetButtonsViewController.h"
#import "YSActionSheetItem.h"

@interface YSActionSheetButtonsViewController ()

@property (weak, nonatomic) NSArray *items;
@property (nonatomic) BOOL centeringText;

@end

@implementation YSActionSheetButtonsViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.items = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];    
}

- (void)setActionSheetItems:(NSArray*)items
{
    self.items = items;
    
    self.centeringText = YES;
    for (YSActionSheetItem *item in items) {
        if (item.image) {
            self.centeringText = NO;
            break;
        }
    }
    [self.tableView reloadData];
}

- (CGFloat)viewHeight
{
    CGFloat cellHeight = [[self class] cellHeight];
    CGFloat viewHeight = cellHeight*[self.items count];
    if (!self.navigationController.navigationBarHidden) {
        viewHeight += self.navigationController.navigationBar.intrinsicContentSize.height;
    }
    return viewHeight;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    YSActionSheetItem *item = self.items[indexPath.row];
    
    cell.textLabel.attributedText = [[NSAttributedString alloc] initWithString:item.title
                                                                    attributes:[YSActionSheetItem textAttributesForType:item.type]];
    if (self.centeringText) {
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.imageView.image = nil;
    } else {
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.imageView.image = item.image;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YSActionSheetItem *item = self.items[indexPath.row];
    if (item.didClickButton) {
        item.didClickButton(indexPath.row);
    }
    if (self.didSelectRow) {
        self.didSelectRow();
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self class] cellHeight];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    /* http://stackoverflow.com/questions/25770119/ios-8-uitableview-separator-inset-0-not-working/25877725#25877725 */
    
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - settings

+ (CGFloat)cellHeight
{
    return 44.f;
}

@end
