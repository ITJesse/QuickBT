//
//  ViewController.m
//  QuickBT
//
//  Created by Jesse Zhu on 2018/03/13.
//  Copyright © 2018 Jesse Zhu. All rights reserved.
//

#import "ViewController.h"
#import "BluetoothManagerHandler.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *bluetoothPowerSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *bluetoothScanSwitch;
@property (weak, nonatomic) BluetoothManagerHandler *bluetoothManagerHandler;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.bluetoothManagerHandler = [BluetoothManagerHandler sharedInstance];
    [self.bluetoothPowerSwitch setOn:[self.bluetoothManagerHandler enabled]];
    [self.bluetoothScanSwitch setOn:[self.bluetoothManagerHandler isScanning]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBluetoothPowerButtonSwitch:(id)sender {
    if ([self.bluetoothManagerHandler enabled]) {
        [self.bluetoothManagerHandler disable];
    } else {
        [self.bluetoothManagerHandler enable];
    }
}

- (IBAction)onBluetoothScanButtonSwitch:(id)sender {
    NSLog(@"here");
    if ([self.bluetoothManagerHandler isScanning]) {
        [self.bluetoothManagerHandler stopScan];
    } else {
        [self.bluetoothManagerHandler startScan];
    }
}
@end
