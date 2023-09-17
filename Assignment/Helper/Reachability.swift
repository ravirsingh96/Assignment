//
//  Reachability.swift
//

import Foundation
import Reachability

class NetworkReachability {
    
    static let shared = NetworkReachability()
    private var reachability: Reachability
    var isInternetReachable = false
    
    private init() {
        self.reachability = try! Reachability()
    }
    
    func startNotifier() {
        do {
            try reachability.startNotifier()
            isInternetReachable = reachability.connection != .unavailable
            
            reachability.whenReachable = { reachability in
                self.isInternetReachable = true
                
            }
            reachability.whenUnreachable = { _ in
                print("Not reachable")
                self.isInternetReachable = false
            }
        } catch {
            print("Unable to start notifier")
        }
    }
    
    
}
