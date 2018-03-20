//
//  QuickBT.swift
//  QuickBT
//
//  Created by Jesse Zhu on 2018/03/17.
//  Copyright © 2018 Jesse Zhu. All rights reserved.
//

import Foundation


public enum QuickBTNotification: String {
    case PowerChanged               = "BluetoothPowerChangedNotification"
    case AvailabilityChanged        = "BluetoothAvailabilityChangedNotification"
    case DeviceDiscovered           = "BluetoothDeviceDiscoveredNotification"
    case DeviceRemoved              = "BluetoothDeviceRemovedNotification"
    case ConnectabilityChanged      = "BluetoothConnectabilityChangedNotification"
    case DeviceUpdated              = "BluetoothDeviceUpdatedNotification"
    case DiscoveryStateChanged      = "BluetoothDiscoveryStateChangedNotification"
    case DeviceConnectSuccess       = "BluetoothDeviceConnectSuccessNotification"
    case ConnectionStatusChanged    = "BluetoothConnectionStatusChangedNotification"
    case DeviceDisconnectSuccess    = "BluetoothDeviceDisconnectSuccessNotification"
    
    public static let allNotifications: [QuickBTNotification] = [.PowerChanged, .AvailabilityChanged, .DeviceDiscovered, .DeviceRemoved, .ConnectabilityChanged, .DeviceUpdated, .DiscoveryStateChanged, .DeviceConnectSuccess, .ConnectionStatusChanged, .DeviceDisconnectSuccess]
}



public protocol QuickBTDelegate {
    func receivedQuickBTNotification(notification: QuickBTNotification)
}



public class QuickBT {
    
    static let sharedInstance = QuickBT()
    
    public var delegate: QuickBTDelegate? = nil
    public var availableDevices: [BluetoothDeviceHandler] {
        get {
            return Array(_availableDevices)
        }
    }
    
    private let bluetoothManagerHandler = BluetoothManagerHandler.sharedInstance()!
    private var _availableDevices = Set<BluetoothDeviceHandler>()
    private var tokenCache = [QuickBTNotification: NSObjectProtocol]()
    
    public init() {
        
        for quickBTNotification in QuickBTNotification.allNotifications {
            print("Registered \(quickBTNotification)")
            
            let notification = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: quickBTNotification.rawValue), object: nil, queue: OperationQueue.main) { [unowned self] (notification) in
                let quickBTNotification = QuickBTNotification.init(rawValue: notification.name.rawValue)!
                switch quickBTNotification {
                case .DeviceDiscovered:
                    let quickBTDevice = self.extractQuickBTDevice(from: notification)
                    self._availableDevices.insert(quickBTDevice)
                case .DeviceRemoved:
                    let quickBTDevice = self.extractQuickBTDevice(from: notification)
                    if let i = self._availableDevices.index(where: { $0.address == quickBTDevice.address }) {
                        self._availableDevices.remove(self._availableDevices[i])
                    }
                default:
                    break
                }
                if (self.delegate != nil) {
                    self.delegate?.receivedQuickBTNotification(notification: quickBTNotification)
                }
            }
            self.tokenCache[quickBTNotification] = notification
        }
    }
    
    deinit {
        for key in tokenCache.keys {
            NotificationCenter.default.removeObserver(tokenCache[key]!)
        }
    }
    
    public func enableBluetooth() {
        bluetoothManagerHandler.enable()
    }
    
    public func disableBluetooth() {
        bluetoothManagerHandler.disable()
    }
    
    public func bluetoothIsEnabled() -> Bool {
        return bluetoothManagerHandler.enabled()
    }
    
    public func startScanForDevices() {
        self.resetAvailableDevices()
        bluetoothManagerHandler.startScan()
        DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
            self.stopScanForDevices()
        }
    }
    
    public func stopScanForDevices() {
        bluetoothManagerHandler.stopScan()
    }
    
    public func isScanning() -> Bool {
        return bluetoothManagerHandler.isScanning()
    }
    
    private func resetAvailableDevices() {
        _availableDevices.removeAll()
    }
    
    private func extractQuickBTDevice(from notification: Notification) -> BluetoothDeviceHandler {
        return BluetoothDeviceHandler(notification: notification)!
    }
}

