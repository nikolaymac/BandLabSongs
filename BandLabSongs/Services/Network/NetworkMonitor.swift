//
//  NetworkMonitor.swift
//  BandLabSongs
//
//  Created by Nikolay Mikhaylov on 21.03.2022.
//

import Foundation
import Network

final class NetworkMonitor {
    static var shared = NetworkMonitor()
    let monitor = NWPathMonitor()
    var isConnectionInternet = false

    func startMonitor() {
       
        monitor.start(queue: .global())
        monitor.pathUpdateHandler = { path in
            self.isConnectionInternet = path.status == .satisfied
        }
    }
}
