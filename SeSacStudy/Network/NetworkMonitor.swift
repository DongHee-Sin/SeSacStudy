//
//  NetworkMonitor.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/11/14.
//

import Foundation
import Network


final class NetworkMonitor {
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    static let shared = NetworkMonitor()
    
    
    
    
    // MARK: - Propertys
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    
    private(set) var isConnected: Bool = false
    
    
    
    
    // MARK: - Methods
    func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
    }
    
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
