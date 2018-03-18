//
//  BluetoothDeviceHandler.m
//  QuickBT
//
//  Created by Jesse Zhu on 2018/03/17.
//  Copyright © 2018 Jesse Zhu. All rights reserved.
//

#import "BluetoothDeviceHandler.h"
#import "BluetoothDevice.h"


@interface BluetoothDeviceHandler ()

@end


@implementation BluetoothDeviceHandler

- (instancetype)initWithNotification:(NSNotification*) notification {
    BluetoothDevice *bluetoothDevice = [notification object];
    
    self = [super init];
    if (self) {
        self.name = bluetoothDevice.name;
        self.address = bluetoothDevice.address;
        self.majorClass = bluetoothDevice.majorClass;
        self.minorClass = bluetoothDevice.minorClass;
        self.type = bluetoothDevice.type;
        self.supportsBatteryLevel = bluetoothDevice.supportsBatteryLevel;
        self.device = bluetoothDevice;
    }
    return self;
}

@end
