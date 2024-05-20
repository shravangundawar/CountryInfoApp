//
//  NetworkReachabilityManager.swift
//  CountryInfoApp
//
//  Created by Shravan Gundawar on 20/05/24.
//

import Foundation
import Network

class NetworkReachability {
    static let shared = NetworkReachability()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)

    var isNetworkAvailable: Bool = false

    private init() {
        monitor.pathUpdateHandler = { path in
            self.isNetworkAvailable = path.status == .satisfied
            if self.isNetworkAvailable {
                NotificationCenter.default.post(name: .networkAvailable, object: nil)
            }
        }
        monitor.start(queue: queue)
    }
}

extension Notification.Name {
    static let networkAvailable = Notification.Name("NetworkAvailable")
}
