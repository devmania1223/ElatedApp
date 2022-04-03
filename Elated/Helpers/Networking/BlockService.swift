//
//  BlockService.swift
//  Elated
//
//  Created by Marlon on 2021/3/15.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import Moya

enum BlockService {
    case getBlockUser(page: Int)
    case blockUser(blocker: Int, blocked: Int)
    case getBlockUserByPath(id: Int)
    case updateBlockUserFull(id: Int, blocker: Int, blocked: Int)
    case updateBlockUserPartial(id: Int, blocker: Int, blocked: Int)
    case deleteBlockUser(id: Int)
}

extension BlockService: TargetType {
    var baseURL: URL {
        return URL(string: Environment.rootURLString + "/api/v1/block/user")!
    }
    
    var path: String {
        //TODO: Remove the stupid "/" at the end after the API is fixed
        switch self {
        case .getBlockUser,
             .blockUser:
            return "/"
        case let .getBlockUserByPath(id),
             let .updateBlockUserFull(id, _, _),
             let .updateBlockUserPartial(id, _, _),
             let .deleteBlockUser(id):
            return "/\(id)/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getBlockUser,
             .getBlockUserByPath:
            return .get
        case .blockUser:
            return .post
        case .updateBlockUserFull:
            return .put
        case .updateBlockUserPartial:
            return .patch
        case .deleteBlockUser:
            return .delete
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case let .getBlockUser(page):
            return .requestParameters(parameters: ["page": page],
                                      encoding: URLEncoding.default)
        case let .blockUser(blocker, blocked),
             let .updateBlockUserFull(_, blocker, blocked),
             let .updateBlockUserPartial(_, blocker, blocked):
            return .requestParameters(parameters: ["blocker": blocker,
                                                   "blocked": blocked],
                                      encoding: JSONEncoding.default)
        case .getBlockUserByPath,
             .deleteBlockUser:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return NetworkManager.commonHeaders
        }
    }
    
}

