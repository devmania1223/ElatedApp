//
//  NotificationService.swift
//  Elated
//
//  Created by Marlon on 8/25/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Moya

import Foundation
import Moya

enum NudgeType: String {
    case justNudge = "NUDGE"
    case sparkFlirtInvite = "NUDGE.SF.INVITE"
    case gameInvite = "NUDGE.SF.PENDING.GAME"
    case gameReminder = "NUDGE.GAME"
    case chatInvite = "CHAT INVITE"
    case chatReminder = "NUDGE.CHAT"
}

enum NotificationService {
    case registerDevice(uuid: String, token: String)
    case unregisterDevice(uuid: String)
    case sendNudge(toUser: Int, nudge: NudgeType, game: Game?, actionId: Int?)
}

extension NotificationService: TargetType {
    
    var baseURL: URL {
        switch self {
        case .sendNudge:
            return URL(string: Environment.rootURLString + "/api/v1/nudges")!
        default:
            return URL(string: Environment.rootURLString + "/api/v1/users")!
        }
    }
    
    var path: String {
        switch self {
        case .registerDevice:
            return "/device/register/"
        case .unregisterDevice:
            return "/device/unregister/"
        case .sendNudge:
            return "/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .registerDevice,
             .unregisterDevice,
             .sendNudge:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case let .registerDevice(uuid, token):
            return .requestParameters(parameters: ["apn_token": token,
                                                   "uuid": uuid],
                                      encoding: JSONEncoding.default)
        case let .unregisterDevice(uuid):
            return .requestParameters(parameters: ["uuid": uuid],
                                      encoding: JSONEncoding.default)
        case let .sendNudge(toUser, nudge, game, actionId):
            let parameters: [String: Any] = ["nudged_user": toUser,
                                             "nudge": nudge.rawValue,
                                             "game": game?.rawValue ?? "",
                                             "action_id": actionId ?? 0]
            return .requestParameters(parameters: parameters,
                                      encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return NetworkManager.commonHeaders
    }
    
}
