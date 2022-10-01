//
//  NetworkChecker.swift
//  ProjectManager
//
//  Created by 1 on 2022/03/24.
//

import Foundation
import Network
import UIKit

final class NetworkChecker {
    
    static public let shared = NetworkChecker()
    
    var isOn: Bool = true
    var connType: ConnectionType = .wifi
    
    private var monitor: NWPathMonitor
    private var queue = DispatchQueue.global()
    
    private init() {
        self.monitor = NWPathMonitor()
        self.queue = DispatchQueue.global(qos: .background)
        self.monitor.start(queue: queue)
    }
    
    func start() {
        self.monitor.pathUpdateHandler = { path in
            isOn = path.status == .satisfied
            connType = checkConnectionTypeForPath(path)
            
            print("📡\(isOn)")
            
            if isOn == false {
                presentNetworkNotiAlertController()
            }
        }
        
    }
    
    func stop() {
        monitor.cancel()
    }
    
    func checkConnectionTypeForPath(_ path: NWPath) -> ConnectionType {
        if path.usesInterfaceType(.wifi) {
            return .wifi
        } else if path.usesInterfaceType(.wiredEthernet) {
            return .ethernet
        } else if path.usesInterfaceType(.cellular) {
            return .cellular
        }
        
        return .unknown
    }
    
    private func presentNetworkNotiAlertController() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.first,
                  let rootViewController = window.rootViewController else {
                return
            }
            let alertController = UIAlertController(
                title: NetworkCheckerAlert.disconnectionTitle.rawValue,
                message: NetworkCheckerAlert.disconnectionMessage.rawValue,
                preferredStyle: .alert)
            let okAction = UIAlertAction(
                title: NetworkCheckerAlert.confirom.rawValue,
                style: .default,
                handler: nil)
            alertController.addAction(okAction)
            
            rootViewController.present(
                alertController, animated: false,
                completion: nil)
        }
    }
}
