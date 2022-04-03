//
//  AppleAuthService.swift
//  Elated
//
//  Created by Marlon on 6/23/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import Moya

enum AppleAuthService {
    case register(token: String, code: String, fname: String?, lname: String?)
}

extension AppleAuthService: TargetType {
    
    var baseURL: URL {
        return URL(string: Environment.rootURLString + "/api/v1/apple")!
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
        case let .register(token, code, fname, lname):
            return .requestParameters(parameters: ["jwt": token,
                                                   "first_name": fname ?? "",
                                                   "last_name": lname ?? "",
                                                   "authorization_code": code],
                                      encoding: JSONEncoding.default)
        }
    }
     
    var headers: [String : String]? {
        return NetworkManager.commonHeaders
    }
    
}
