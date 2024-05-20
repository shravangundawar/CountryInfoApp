//
//  BluetoothViewController.swift
//  CountryInfoApp
//
//  Created by Shravan Gundawar on 18/05/24.
//

import UIKit
import Combine

class BluetoothViewController: UIViewController {
    //MARK: IBOutlets
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var devicesTableView: UITableView!
    
    //MARK: Properties
    private var bluetoothVM: BluetoothViewModel?
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bluetoothDeviceRepo = BluetoothDeviceRepository()
        let bluetoothUseCase = BluetoothUseCase(repository: bluetoothDeviceRepo)
        bluetoothVM = BluetoothViewModel(useCase: bluetoothUseCase)
        bindViewModel()
    }
    
    //MARK: IBAction
    @IBAction func scanButtonTapped(_ sender: Any) {
        bluetoothVM?.startScan()
    }
    
    //MARK: Methods
    private func bindViewModel() {
        bluetoothVM?.$devices
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.devicesTableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

//MARK: TableView DataSource
extension BluetoothViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bluetoothVM?.devices.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "DeviceCell")
        guard let device = bluetoothVM?.devices[indexPath.row] else { return UITableViewCell() }
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "BT-\(device.name) \nUUID- \(device.identifier.uuidString)"
        return cell
    }
}

//MARK: TableView Delegate
extension BluetoothViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
}
