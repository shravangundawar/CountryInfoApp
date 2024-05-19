//
//  BluetoothUseCase.swift
//  CountryInfoApp
//
//  Created by Shravan Gundawar on 19/05/24.
//

import Foundation

class BluetoothUseCase {
    //MARK: Properties
    private let repository: BluetoothDeviceRepository

    init(repository: BluetoothDeviceRepository) {
        self.repository = repository
    }

    //MARK: Methods
    func startScan() {
        repository.startScanning()
    }

    func stopScan() {
        repository.stopScanning()
    }

    func getDevices() -> [BluetoothDeviceModel] {
        return repository.devices
    }
}
