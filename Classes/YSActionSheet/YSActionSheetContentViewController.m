//
//  YSActionSheetContentViewController.m
//  YSActionSheetExample
//
//  Created by Yu Sugawara on 2014/07/15.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import "YSActionSheetContentViewController.h"
#import "YSActionSheetItem.h"

@interface YSActionSheetContentViewController ()

@property (weak, nonatomic) NSArray *items;

@end

@implementation YSActionSheetContentViewController

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
    cell.imageView.image = item.image;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    YSActionSheetItem *item = self.items[indexPath.row];
    if (item.didClickButton) {
        item.didClickButton();
    }
    if (self.didSelectRow) {
        self.didSelectRow();
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self class] cellHeight];
}

#pragma mark - settings

+ (CGFloat)cellHeight
{
    return 44.f;
}

@end
