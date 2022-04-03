//
//  SpotifyThirdPartyAuthService.swift
//  Elated
//
//  Created by Marlon on 7/8/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import Moya

enum SpotifyThirdPartyAuthService {
    case register(token: String)
    case getArtists
    case getProfile
}

extension SpotifyThirdPartyAuthService: TargetType {
    
    var baseURL: URL {
        return URL(string: Environment.rootURLString + "/api/v1/spotify")!
    }
    
    var path: String {
        switch self {
        case .register:
            return "/auth/access_token_spotify/"
        case .getArtists:
            return "/followed_artists/"
        case .getProfile:
            return "/profile/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .register:
            return .post
        case .getArtists,
             .getProfile:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case let .register(token):
            let parameter: [String: String] = ["access_token": token] //WEIRD API DONOT DELETE THIS!!!
            return .requestParameters(parameters: parameter,
                                      encoding: JSONEncoding.default)
        case .getArtists,
             .getProfile:
            return .requestPlain
        }
    }
     
    var headers: [String : String]? {
        return NetworkManager.commonHeaders
    }
    
}
