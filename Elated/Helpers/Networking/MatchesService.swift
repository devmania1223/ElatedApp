//
//  MatchesService.swift
//  Elated
//
//  Created by Marlon on 2021/3/16.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import Moya

enum MatchesService {
    case getMatches(page: Int)
    case getFans(page: Int)
    case getFavorites(page: Int)
    case createFavorites(userID: Int)
    case deleteFavorites(id: Int)
    case getMatchesByPath(id: Int)
    case updateMatchesFull(id: Int,
                           matchType: String? = nil,
                           state: Int? = nil,
                           matchPercentage: Int? = nil)
    case updateMatchesPartial(id: Int,
                              matchType: String? = nil,
                              state: Int? = nil,
                              matchPercentage: Int? = nil)
}

extension MatchesService: TargetType {
    var baseURL: URL {
        return URL(string: Environment.rootURLString + "/api/v1/matches")!
    }
    
    var path: String {
        //TODO: Remove the stupid "/" at the end after the API is fixed
        switch self {
        case .getMatches:
            return "/"
        case .getFans:
            return "/fans/"
        case .getFavorites,
             .createFavorites:
            return "/favorites/"
        case let .deleteFavorites(id):
            return "/favorites/\(id)/"
        case let .getMatchesByPath(id),
             let .updateMatchesFull(id, _, _, _),
             let .updateMatchesPartial(id, _, _, _):
            return "/\(id)/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMatches,
             .getFans,
             .getFavorites,
             .getMatchesByPath:
            return .get
        case .createFavorites:
            return .post
        case .deleteFavorites:
            return .delete
        case .updateMatchesFull:
            return .put
        case .updateMatchesPartial:
            return .patch
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case let .getMatches(page),
             let .getFans(page),
             let .getFavorites(page):
            return .requestParameters(parameters: ["page": page],
                                      encoding: URLEncoding.default)
        case let .createFavorites(userID):
            return .requestParameters(parameters: ["user_id": userID],
                                      encoding: JSONEncoding.default)
        case .deleteFavorites,
             .getMatchesByPath:
            return .requestPlain
        case let .updateMatchesFull(_, matchType, state, matchPercentage),
             let .updateMatchesPartial(_, matchType, state, matchPercentage):
            
            var parameters = [String: Any]()
            
            if let matchType = matchType {
                parameters["match_type"] = matchType
            }
            
            if let state = state {
                parameters["state"] = state
            }
            
            if let percent = matchPercentage {
                parameters["match_percentage"] = percent
            }

            return .requestParameters(parameters: parameters,
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

