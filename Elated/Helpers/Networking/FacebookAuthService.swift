//
//  FacebookAuthService.swift
//  Elated
//
//  Created by Marlon on 6/18/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import Moya

enum FacebookAuthService {
    case register(token: String)
}

extension FacebookAuthService: TargetType {
    
    var baseURL: URL {
        return URL(string: Environment.rootURLString + "/api/v1/facebook")!
    }
    
    var path: String {
        switch self {
        case .register:
            return "/auth/access_token/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .register:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case let .register(token):
            return .requestParameters(parameters: ["access_token": token],
                                      encoding: JSONEncoding.default)
        }
    }
     
    var headers: [String : String]? {
        return NetworkManager.commonHeaders
    }
    
}


