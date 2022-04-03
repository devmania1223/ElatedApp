//
//  InAppNotificationService.swift
//  Elated
//
//  Created by Rey Felipe on 11/15/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import Moya

enum InAppNotificationService {
    case deleteItem(id: Int)
    case deleteAll
    case getNotifications(page: Int)
    case getNumberOfUnreadNotifications
    case markAsRead(id: Int)
}

extension InAppNotificationService: TargetType {
    
    var baseURL: URL {
        return URL(string: Environment.rootURLString + "/api/v1/notifications")!
    }
    
    var path: String {
        switch self {
        case .deleteAll:
            return "/inapp/delete_all/"
        case .getNotifications(_):
            return "/inapp/"
        case .getNumberOfUnreadNotifications:
            return "/inapp/unread_notification/"
        case let .deleteItem(id),
            let .markAsRead(id):
            return "/inapp/\(id)/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .deleteItem:
            return .delete
        case .getNotifications,
                .getNumberOfUnreadNotifications:
            return .get
        case .deleteAll:
            return .post
        case .markAsRead:
            return .patch
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case let .getNotifications(page):
            return .requestParameters(parameters: ["page": page],
                                      encoding: URLEncoding.default)
        case .deleteAll,
                .deleteItem,
                .getNumberOfUnreadNotifications:
            return .requestPlain
        case .markAsRead:
            return .requestParameters(parameters: ["is_read": true],
                                      encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return NetworkManager.commonHeaders
    }
    
}

