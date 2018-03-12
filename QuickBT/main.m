//
//  main.m
//  QuickBT
//
//  Created by Jesse Zhu on 2018/03/13.
//  Copyright © 2018 Jesse Zhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "BluetoothManagerHandler.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        [BluetoothManagerHandler sharedInstance];
        [NSThread sleepForTimeInterval:1];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
