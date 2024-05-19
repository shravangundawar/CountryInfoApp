//
//  BluetoothViewModel.swift
//  CountryInfoApp
//
//  Created by Shravan Gundawar on 19/05/24.
//

import Foundation
import Foundation
import Combine

class BluetoothViewModel: ObservableObject {
    //MARK: Properties
    @Published var devices: [BluetoothDeviceModel] = []
    private var useCase: BluetoothUseCase
    private var cancellables: Set<AnyCancellable> = []

    init(useCase: BluetoothUseCase) {
        self.useCase = useCase
    }

    //MARK: Methods
    func startScan() {
        useCase.startScan()
        Timer.publish(every: 2.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateDevices()
            }
            .store(in: &cancellables)
    }

    func stopScan() {
        useCase.stopScan()
    }

    private func updateDevices() {
        devices = useCase.getDevices()
    }
}
