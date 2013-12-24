//
//  ViewController.m
//  BleCentralDemo
//
//  Created by Marshal Wu on 13-12-24.
//  Copyright (c) 2013年 Marshal Wu. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface ViewController () <CBCentralManagerDelegate>

@property (strong, nonatomic) CBCentralManager *centralManger;
@property (strong, nonatomic) NSMutableArray *peripherals;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    self.centralManger = [[CBCentralManager alloc] initWithDelegate:self
                                                              queue:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state == CBCentralManagerStatePoweredOn) {
        [self.centralManger scanForPeripheralsWithServices:nil
                                                   options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@(YES)}];
        NSLog(@">>>BLE状态正常");
    }else{
        NSLog(@">>>设备不支持BLE或者未打开");
    }
}

- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI
{
    NSLog(@">>>>扫描周边设备 .. 设备id:%@, rssi: %@",[peripheral.identifier UUIDString],RSSI);
}

@end
