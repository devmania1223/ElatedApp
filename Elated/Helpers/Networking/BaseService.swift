//
//  BaseService.swift
//  Elated
//
//  Created by Marlon on 5/20/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import Moya

enum BaseService {
    case inquiry(subject: String, email: String, body: String)
}

extension BaseService: TargetType {
    
    var baseURL: URL {
        return URL(string: Environment.rootURLString + "/api/v1")!
    }
    
    var path: String {
        switch self {
        case .inquiry:
            return "/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .inquiry:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case let .inquiry(subject, email, body):
            let user = MemCached.shared.userInfo
            return .requestParameters(parameters: ["name": "\(user?.firstName ?? "Fname") \(user?.lastName ?? "Lname")",
                                                   "subject": subject.capitalized,
                                                   "body": body,
                                                   "email": email],
                                      encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return NetworkManager.commonHeaders
        }
    }

}
