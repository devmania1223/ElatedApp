//
//  ThirdPartyService.swift
//  Elated
//
//  Created by Marlon on 2021/3/16.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import Moya

enum ThirdPartyService {
    case getPlaces(keyword: String)
    case getSocialTwitterPost(page: Int)
    case createSocialTwitterPost(content: String)
}

extension ThirdPartyService: TargetType {
    var baseURL: URL {
        return URL(string: Environment.rootURLString + "/api/v1")!
    }
    
    var path: String {
        switch self {
        case .getPlaces:
            return "/places/search_places/"
        case .getSocialTwitterPost,
             .createSocialTwitterPost:
            return "/social/twitter/post/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPlaces, .getSocialTwitterPost:
            return .get
        case .createSocialTwitterPost:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case let .getPlaces(keyword):
            return .requestParameters(parameters: ["keyword": keyword],
                                      encoding: URLEncoding.default)
        case let .getSocialTwitterPost(page):
            return .requestParameters(parameters: ["page": page],
                                      encoding: URLEncoding.default)
        case let .createSocialTwitterPost(content):
            return .requestParameters(parameters: ["content": content],
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

