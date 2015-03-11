//
//  main.m
//  YSActionSheetExample
//
//  Created by Yu Sugawara on 2014/07/15.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import <YSCocoaLumberjackHelper/YSCocoaLumberjackHelper.h>

int main(int argc, char * argv[])
{
    @autoreleasepool {
        [YSCocoaLumberjackHelper launchLogger];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
