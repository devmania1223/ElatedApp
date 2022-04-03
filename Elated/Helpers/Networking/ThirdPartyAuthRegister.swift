//
//  ThirdPartyAuthRegister.swift
//  Elated
//
//  Created by Marlon on 6/26/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import Moya

enum ThirdPartyAuthType: String {
    case facebook = "Facebook"
    case google = "Google"
    case apple = "Apple"
}

enum ThirdPartyAuthRegister {
    case register(token: String, email: String, type: ThirdPartyAuthType, socialMediaID: String)
}

extension ThirdPartyAuthRegister: TargetType {
    
    var baseURL: URL {
        return URL(string: Environment.rootURLString + "/api/v1/social_media")!
    }
    
    var path: String {
        switch self {
        case .register:
            return "/auth/register/"
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
        case let .register(token, email, type, id):
            return .requestParameters(parameters: ["access_token": token,
                                                   "email": email,
                                                   "social_media": type.rawValue,
                                                   "social_media_id": id],
                                      encoding: JSONEncoding.default)
        }
    }
     
    var headers: [String : String]? {
        return NetworkManager.commonHeaders
    }
    
}
