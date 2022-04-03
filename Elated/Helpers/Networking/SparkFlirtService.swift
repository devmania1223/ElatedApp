//
//  SparkFlirtService.swift
//  Elated
//
//  Created by Marlon on 2021/3/16.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import Moya

enum SparkFlirtService {
    case getSparkFlirts(page: Int)
    case getSparkFlirtsAccount(page: Int)
    case getSparkFlirtsPuchaseHistory(page: Int)
    case createSparkFlirtsAccount(user: Int)
    case generateSpartFlirtAccount(user: Int)
    case getSparkFlirtsAccountByPath(id: Int)
    case updateSparkFlirtAccountFull(id: Int, user: Int)
    case updateSparkFlirtAccountPartial(id: Int, user: Int)
    case deleteSparkFlirt(id: Int)
    case getActiveSparkFlirt(page: Int)
    case getHistorySparkFlirt(page: Int)
    case getIncomingSparkFlirt(page: Int)
    case getSentSparkFlirt(page: Int)
    case getGetSparkFlirt(page: Int)
    case getSparkFlirtByPath(id: Int)
    case getUnusedSparkFlirt
    case updateSparkFlirtFull(id: Int,
                            gameTitle: String,
                            gameStatus: String,
                            sparkFlirtAccount: Int,
                            hostUser: Int,
                            invitedUser: Int)
    case updateSparkFlirtPartial(id: Int,
                               gameTitle: String,
                               gameStatus: String,
                               sparkFlirtAccount: Int,
                               hostUser: Int,
                               invitedUser: Int)
    case getSparkFlirtHistory(id: Int)
    case getSparkFlirtDetail(id: Int)
    case acceptSparkFlirtInvite(id: Int, accept: Bool)
    case inviteSparkFlirtUser(id: Int)
    case revokeSparkFlirtInvite(id: Int, reason: String? = nil)
    case startSparkFlirtGame(id: Int, game: String)
    case getSuccessfullSparkFlirts
    //POST
    case getGames(status: [SparkFlirtStatus])
    
}

extension SparkFlirtService: TargetType {
    var baseURL: URL {
        switch self {
        case .getSparkFlirtsPuchaseHistory:
            return URL(string: Environment.rootURLString + "/api/v1/orders")!
        case .getUnusedSparkFlirt:
            return URL(string: Environment.rootURLString + "/api/v1/sparkflirt_accounts")!
        default:
            return URL(string: Environment.rootURLString + "/api/v1/sparkflirts")!
        }
    }
    
    var path: String {
        switch self {
        case .getUnusedSparkFlirt:
            return "/get_unused_sparkflirts/"
        case .getSparkFlirts,
             .getSparkFlirtsPuchaseHistory:
            return "/"
        case .getSparkFlirtsAccount,
             .createSparkFlirtsAccount:
            return "/account/"
        case .generateSpartFlirtAccount:
            return "/account/generate_sparkflirt/"
        case let .getSparkFlirtsAccountByPath(id),
             let .updateSparkFlirtAccountFull(id, _),
             let .updateSparkFlirtAccountPartial(id, _),
             let .deleteSparkFlirt(id):
            return "/account/\(id)/"
        case .getActiveSparkFlirt:
            return "/get_active_sparkflirts/"
        case .getHistorySparkFlirt:
            return "/get_history_sparkflirts/"
        case .getIncomingSparkFlirt:
            return "/get_incoming_sparkflirts/"
        case .getSentSparkFlirt:
            return "/get_sent_sparkflirts/"
        case .getGetSparkFlirt:
            return "/get_sparkflirts/"
        case let .getSparkFlirtByPath(id),
             let .updateSparkFlirtFull(id, _,_,_,_,_),
             let .updateSparkFlirtPartial(id, _,_,_,_,_):
            return "/\(id)/"
        case let .getSparkFlirtHistory(id):
            return "/\(id)/get_history/"
        case let .getSparkFlirtDetail(id):
            return "/\(id)/get_sparkflirt_detail/"
        case let .acceptSparkFlirtInvite(id, _):
            return "/\(id)/invite_accept/"
        case .inviteSparkFlirtUser(_):
            return "/invite_user/"
        case let .revokeSparkFlirtInvite(id, _):
            return "/\(id)/cancel/"
        case let .startSparkFlirtGame(id, _):
            return "/\(id)/start_game/"
        case .getGames:
            return "/games/"
        case .getSuccessfullSparkFlirts:
            return "/users/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getSparkFlirts,
             .getSparkFlirtsAccount,
             .getSparkFlirtsAccountByPath,
             .getSparkFlirtsPuchaseHistory,
             .getActiveSparkFlirt,
             .getHistorySparkFlirt,
             .getIncomingSparkFlirt,
             .getSentSparkFlirt,
             .getGetSparkFlirt,
             .getSparkFlirtByPath,
             .getSparkFlirtHistory,
             .getSparkFlirtDetail,
             .getUnusedSparkFlirt,
             .getSuccessfullSparkFlirts:
            return .get
        case .createSparkFlirtsAccount,
             .generateSpartFlirtAccount,
             .acceptSparkFlirtInvite,
             .inviteSparkFlirtUser,
             .revokeSparkFlirtInvite,
             .startSparkFlirtGame,
             .getGames:
            return .post
        case .updateSparkFlirtAccountFull,
             .updateSparkFlirtFull:
            return .put
        case .updateSparkFlirtAccountPartial,
             .updateSparkFlirtPartial:
            return .patch
        case .deleteSparkFlirt:
            return .delete
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case let .getSparkFlirts(page),
             let .getSparkFlirtsAccount(page),
             let .getSparkFlirtsPuchaseHistory(page),
             let .getActiveSparkFlirt(page),
             let .getHistorySparkFlirt(page),
             let .getIncomingSparkFlirt(page),
             let .getSentSparkFlirt(page),
             let .getGetSparkFlirt(page),
             let .getSparkFlirtByPath(page):
            return .requestParameters(parameters: ["page": page],
                                      encoding: URLEncoding.default)
        case let .createSparkFlirtsAccount(user),
             let .generateSpartFlirtAccount(user),
             let .updateSparkFlirtAccountFull(_, user),
             let .updateSparkFlirtAccountPartial(_, user):
            return .requestParameters(parameters: ["user": user],
                                      encoding: JSONEncoding.default)
        
        case .getSparkFlirtsAccountByPath,
             .deleteSparkFlirt,
             .getSparkFlirtHistory,
             .getSparkFlirtDetail,
             .getUnusedSparkFlirt,
             .getSuccessfullSparkFlirts:
            return .requestPlain
            
        case  let .acceptSparkFlirtInvite(_, accept):
            return .requestParameters(parameters: ["accept": accept],
                                      encoding: JSONEncoding.default)
            
        case let .inviteSparkFlirtUser(id):
            return .requestParameters(parameters: ["user_id": id],
                                      encoding: JSONEncoding.default)
            
        case let .updateSparkFlirtFull(_, gameTitle, gameStatus, sparkFlirtAccount, hostUser, invitedUser),
             let .updateSparkFlirtPartial(_, gameTitle, gameStatus, sparkFlirtAccount, hostUser, invitedUser):
            return .requestParameters(parameters: ["game_title": gameTitle,
                                                   "game_status": gameStatus,
                                                   "sparkflirt_account": sparkFlirtAccount,
                                                   "host_user": hostUser,
                                                   "invited_user": invitedUser],
                                      encoding: JSONEncoding.default)
        case let .revokeSparkFlirtInvite(_, reason):
            return .requestParameters(parameters: ["reason": reason ?? ""],
                                      encoding: JSONEncoding.default)
        case let .startSparkFlirtGame(_, game):
            return .requestParameters(parameters: ["game_title": game],
                                      encoding: JSONEncoding.default)
        case let .getGames(status):
            return .requestParameters(parameters: ["status": status.map { $0.rawValue }],
                                      encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return NetworkManager.commonHeaders
    }
    
}

