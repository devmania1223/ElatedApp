//
//  NetworkManager.swift
//  Elated
//
//  Created by Marlon on 2021/2/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    
    static var commonHeaders: [String: String] {
        get {
            var arr = [
                "Content-Type": "application/json",
                "Accept": "application/json",
            ]
            
            if let token = UserDefaults.standard.token {
                arr["Authorization"] = "Token \(token)"
            }
            
            return arr
        }
    }
    
    static var isConnectedToInternet: Bool {
        get {
            return NetworkReachabilityManager()?.isReachable ?? false
        }
    }
    
}
