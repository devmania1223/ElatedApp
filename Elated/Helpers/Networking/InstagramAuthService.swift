//
//  InstagramAuthService.swift
//  Elated
//
//  Created by Marlon on 6/2/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import Moya

enum InstagramAuthService {
    case accessToken(code: String)
    case getMedia
    case uploadMedia(mediaURL: String, sourceID: String, caption: String)
    case getUsername
}

extension InstagramAuthService: TargetType {
    
    var baseURL: URL {
        return URL(string: Environment.rootURLString + "/api/v1/instagram")!
    }
    
    var path: String {
        switch self {
        case .accessToken:
            return "/auth/access_token/"
        case .getMedia:
            return "/media/"
        case .uploadMedia:
            return "/upload/"
        case .getUsername:
            return "/username/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .accessToken:
            return .post
        case .getMedia,
             .getUsername:
            return .get
        case .uploadMedia:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case let .accessToken(code):
            return .requestParameters(parameters: ["code": code,
                                                   "redirect_uri" : Environment.instagramURLScheme],
                                      encoding: JSONEncoding.default)
        case .getMedia,
             .getUsername:
            return .requestPlain
        case let .uploadMedia(mediaURL, sourceID, caption):
            return .requestParameters(parameters: ["caption": caption,
                                                   "image" : mediaURL,
                                                   "source_id" : sourceID],
                                      encoding: JSONEncoding.default)
        }
    }
     
    var headers: [String : String]? {
        return NetworkManager.commonHeaders
    }
    
}


