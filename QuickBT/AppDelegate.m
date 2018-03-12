//
//  AppDelegate.m
//  QuickBT
//
//  Created by Jesse Zhu on 2018/03/13.
//  Copyright © 2018 Jesse Zhu. All rights reserved.
//

#import "AppDelegate.h"
#import "BluetoothManagerHandler.h"

NSString * const NOTIFICATIONS[] = { @"BluetoothPowerChangedNotification", @"BluetoothAvailabilityChangedNotification", @"BluetoothDeviceDiscoveredNotification", @"BluetoothDeviceRemovedNotification", @"BluetoothConnectabilityChangedNotification", @"BluetoothDeviceUpdatedNotification", @"BluetoothDiscoveryStateChangedNotification", @"BluetoothDeviceConnectSuccessNotification", @"BluetoothConnectionStatusChangedNotification", @"BluetoothDeviceDisconnectSuccessNotification" };

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (NSArray *)allNotifications
{
    static NSArray *_notifications;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _notifications = @[ @"BluetoothPowerChangedNotification", @"BluetoothAvailabilityChangedNotification", @"BluetoothDeviceDiscoveredNotification", @"BluetoothDeviceRemovedNotification", @"BluetoothConnectabilityChangedNotification", @"BluetoothDeviceUpdatedNotification", @"BluetoothDiscoveryStateChangedNotification", @"BluetoothDeviceConnectSuccessNotification", @"BluetoothConnectionStatusChangedNotification", @"BluetoothDeviceDisconnectSuccessNotification" ];
    });
    return _notifications;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    BluetoothManagerHandler *bluetoothManagerHandle = [BluetoothManagerHandler sharedInstance];
    [bluetoothManagerHandle enable];
    [bluetoothManagerHandle startScan];
    for (NSString *notification in [[self class] allNotifications]) {
        [[NSNotificationCenter defaultCenter] addObserverForName:notification
                                                          object:nil
                                                           queue:[NSOperationQueue mainQueue]
                                                      usingBlock:^(NSNotification * _Nonnull note) {
                                                          NSLog(@"%@", note.name);
                                                          if ([note.name isEqual: @"BluetoothDeviceDiscoveredNotification"]) {
                                                              BluetoothDevice *device = note.object;
                                                              NSLog(@"%@", device.name);
                                                              if ([device.name isEqualToString:@"MDR-1000X"]) {
                                                                  [bluetoothManagerHandle connectDevice:device withServices:0x00000010];
                                                              }
                                                          } else if ([note.name isEqualToString:@"BluetoothDeviceConnectSuccessNotification"]) {
                                                              [bluetoothManagerHandle stopScan];
                                                              exit(0);
                                                          }
                                                      }];
    }
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
