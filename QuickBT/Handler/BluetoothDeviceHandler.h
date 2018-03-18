//
//  BluetoothDeviceHandler.h
//  QuickBT
//
//  Created by Jesse Zhu on 2018/03/17.
//  Copyright © 2018 Jesse Zhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BluetoothDevice.h"

@interface BluetoothDeviceHandler : NSObject

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* address;
@property (assign, nonatomic) NSUInteger majorClass;
@property (assign, nonatomic) NSUInteger minorClass;
@property (assign, nonatomic) NSInteger type;
@property (assign, nonatomic) BOOL supportsBatteryLevel;
@property (weak, nonatomic) BluetoothDevice *device;

- (instancetype)initWithNotification:(NSNotification*) notification;

@end
