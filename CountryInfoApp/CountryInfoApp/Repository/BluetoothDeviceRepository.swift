//
//  BluetoothDeviceRepository.swift
//  CountryInfoApp
//
//  Created by Shravan Gundawar on 19/05/24.
//

import Foundation
import CoreBluetooth

protocol BluetoothRepository {
    var devices: [BluetoothDeviceModel] { get }
    func startScanning()
    func stopScanning()
}


class BluetoothDeviceRepository: NSObject, BluetoothRepository, CBCentralManagerDelegate {
    private var centralManager: CBCentralManager?
    private var discoveredPeripherals: [UUID: (peripheral: CBPeripheral, name: String)] = [:]
    
    var devices: [BluetoothDeviceModel] {
        return discoveredPeripherals.values.map { BluetoothDeviceModel(name: $0.name, identifier: $0.peripheral.identifier) }
    }
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func startScanning() {
        discoveredPeripherals.removeAll()
        centralManager?.scanForPeripherals(withServices: nil, options: nil)
    }

    func stopScanning() {
        centralManager?.stopScan()
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            startScanning()
        } else {
            // Handle different states
            print("Bluetooth is not available.")
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        let name = advertisementData[CBAdvertisementDataLocalNameKey] as? String ?? peripheral.name ?? "Unknown"
        discoveredPeripherals[peripheral.identifier] = (peripheral, name)
    }
}
