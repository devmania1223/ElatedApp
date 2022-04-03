//
//  StoryShareService.swift
//  Elated
//
//  Created by Marlon on 2021/3/16.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import Moya

enum StoryShareService {
    case getStoryShare(_ page: Int? = nil)
    case getStoryShareByPath(id: Int)
    case cancel(id: Int)
    case sendPharse(id: Int, phrase: String)
    case sendColor(id: Int, color: String)
    case period(id: Int)
}

extension StoryShareService: TargetType {
    var baseURL: URL {
        return URL(string: Environment.rootURLString + "/api/v1/storyshare")!
    }
    
    var path: String {
        //TODO: Remove the stupid "/" at the end after the API is fixed
        switch self {
        case .getStoryShare:
            return "/"
        case let .getStoryShareByPath(id):
            return "/\(id)/"
        case let .cancel(id):
            return "/\(id)/cancel/"
        case let .sendPharse(id, _):
            return "/\(id)/phrase/"
        case let .sendColor(id, _):
            return "/\(id)/color/"
        case let .period(id):
            return "/\(id)/period/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getStoryShare,
             .getStoryShareByPath:
            return .get
        case .sendPharse,
             .sendColor,
             .cancel,
             .period:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case let .getStoryShare(page):
            let params = page == nil ? [:] : ["page": page!]
            return .requestParameters(parameters: params,
                                      encoding: URLEncoding.default)
        case .getStoryShareByPath,
             .cancel,
             .period:
            return .requestPlain
        case let .sendPharse(_, phrase):
            return .requestParameters(parameters: ["phrase": phrase],
                                      encoding: JSONEncoding.default)
        case let .sendColor(_, color):
            return .requestParameters(parameters: ["color": color],
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

