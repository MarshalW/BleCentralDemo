//
//  ViewController.m
//  BleCentralDemo
//
//  Created by Marshal Wu on 13-12-24.
//  Copyright (c) 2013年 Marshal Wu. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface ViewController () <CBCentralManagerDelegate,CBPeripheralDelegate>

@property (strong, nonatomic) CBCentralManager *centralManger;

@property (strong,nonatomic) CBPeripheral *peripheral;

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
                                                   options:nil];
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
    NSLog(@">>>>扫描周边设备，id:%@, rssi: %@",[peripheral.identifier UUIDString],RSSI);
    
    peripheral.delegate=self;
    self.peripheral=peripheral;
    [self.centralManger connectPeripheral:self.peripheral options:nil];
}

- (void)centralManager:(CBCentralManager *)central
  didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"和周边设备连接成功。");
    [peripheral discoverServices:nil];
    NSLog(@"扫描周边设备上的服务..");
}

- (void)peripheral:(CBPeripheral *)peripheral
didDiscoverServices:(NSError *)error
{
    if (error) {
        NSLog(@"发现服务时发生错误: %@",error);
        return;
    }
    
    NSLog(@"发现服务 ..");
    
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    NSLog(@"发现服务 %@, 特性数: %d", service.UUID, [service.characteristics count]);
    
    for (CBCharacteristic *c in service.characteristics) {
        [peripheral readValueForCharacteristic:c];
        NSLog(@"特性值： %@",c.value);
    }
}

@end
