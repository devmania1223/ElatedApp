//
//  BashoServices.swift
//  Elated
//
//  Created by Marlon on 2021/3/15.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import Moya

enum BashoService {
    case getBasho(page: Int? = nil)
    case inviteBasho(inviter: Int, invitee: Int)
    case getBashoByPath(id: Int)
//    case updateBashoFull(id: Int,
//                             basho: [String],
//                             currentLine: Int,
//                             currentSyllablesCount: Int,
//                             invitee: Int,
//                             inviter: Int,
//                             currentPlayerTurn: Int)
    case updateBashoGame(id: Int,
                        basho: [String],
                        currentLine: Int,
                        currentSyllablesCount: Int)
    case sendBasho(id: Int, userId: Int, line: String, time: Int)
    case getWordDefinition(userId: Int, word: String)
    case getWordSyllables(userId: Int, word: String)
    case getAlgoliaBashoWordQuery(query: String, syllables: String)
    case cancel(id: Int)
    case resetTimer(id: Int)
    case skipTurn(id: Int)
    
}

extension BashoService: TargetType {
    
    var baseURL: URL {
        switch self {
        case .getAlgoliaBashoWordQuery:
            return URL(string: Environment.rootURLString + "/api/v1/algolia/basho")!
        default:
            return URL(string: Environment.rootURLString + "/api/v1/basho")!
        }
    }
    
    var path: String {
        switch self {
        case .getBasho,
             .inviteBasho:
            return "/"
        case let .getBashoByPath(id),
             //let .updateBashoFull(id, _, _, _, _, _, _),
             let .updateBashoGame(id, _, _, _):
            return "/\(id)/"
        case let .getWordDefinition(userId, word):
            return "/\(userId)/word/\(word)/definitions/"
        case let .getWordSyllables(userId, word):
            return "/\(userId)/word/\(word)/syllables/"
        case .getAlgoliaBashoWordQuery:
            return "/suggestions/"
        case let .sendBasho(id, _, _, _):
            return "/\(id)/send/"
        case let .cancel(id):
            return "/\(id)/cancel/"
        case let .resetTimer(id):
            return "/\(id)/reset_timer/"
        case let .skipTurn(id):
            return "/\(id)/skip/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getBasho,
             .getBashoByPath,
             .getWordDefinition,
             .getWordSyllables,
             .getAlgoliaBashoWordQuery:
            return .get
        case .inviteBasho,
             .cancel,
             .resetTimer,
             .sendBasho,
             .skipTurn:
            return .post
//        case .updateBashoFull:
//            return .put
        case .updateBashoGame:
            return .patch
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case let .getBasho(page):
            let parameter: [String: Any] = page != nil ? ["page": page!] : [:]
            return .requestParameters(parameters: parameter,
                                      encoding: URLEncoding.default)
        case let .inviteBasho(inviter, invitee):
            return .requestParameters(parameters: ["inviter": inviter,
                                                   "invitee": invitee],
                                      encoding: JSONEncoding.default)
        case .getBashoByPath,
             .getWordDefinition,
             .getWordSyllables,
             .cancel,
             .resetTimer,
             .skipTurn:
            return .requestPlain
        case //let .updateBashoFull(_, basho, currentLine, currentSyllablesCount, invitee, inviter, currentPlayerTurn),
             let .updateBashoGame(_, basho, currentLine, currentSyllablesCount):
            return .requestParameters(parameters: ["basho": basho,
                                                   "current_line": currentLine,
                                                   "current_syllables_count": currentSyllablesCount],
                                      encoding: JSONEncoding.default)
        case let .getAlgoliaBashoWordQuery(query, syllables):
            return .requestParameters(parameters: ["query": query,
                                                   "syllables": syllables],
                                      encoding: URLEncoding.default)
        case let .sendBasho(_, userId, line, time):
            return .requestParameters(parameters: ["basho": ["completed_by": userId,
                                                            "line": line,
                                                            "time": time]],
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
