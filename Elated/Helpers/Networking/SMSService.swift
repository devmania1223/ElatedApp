//
//  SMSService.swift
//  Elated
//
//  Created by Marlon on 5/13/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import Moya

enum SMSService {
    case otp(number: String)
    case verifyPhoneNumber(number: String, code: String)
}

extension SMSService: TargetType {
    
    var baseURL: URL {
        return URL(string: Environment.rootURLString + "/api/v1/sms")!
    }
    
    var path: String {
        //TODO: Remove the stupid "/" at the end after the API is fixed
        switch self {
        case .otp:
            return "/send_otp/"
        case .verifyPhoneNumber:
            return "/verify_phonenumber/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .otp:
            return .post
        case .verifyPhoneNumber:
            return .put
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case let .otp(number):
            return .requestParameters(parameters: ["phone_no": number],
                                      encoding: JSONEncoding.default)
        case let .verifyPhoneNumber(number, code):
            return .requestParameters(parameters: ["phone_no": number,
                                                   "code": code],
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

