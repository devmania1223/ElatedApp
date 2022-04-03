//
//  EmojiGoService.swift
//  Elated
//
//  Created by Marlon on 2021/3/15.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import Moya

enum EmojiGoService {
    case getEmojigo(page: Int? = nil)
    case inviteEmojigo(inviter: Int, invitee: Int)
    case getEmogigoDetails(id: Int)
    case updateEmogigoFull(id: Int, emojigo: [String], inviter: Int, invitee: Int, turn: Int)
    case updateEmogigoPartial(id: Int, emojigo: [String], inviter: Int, invitee: Int, turn: Int)
    
    //new apis
    case sendAnswer(_ gameID: Int, answer: String)
    case sendQuestion(_ gameID: Int, id: Int?, question: String?)
    case cancel(_ gameID: Int)
    case resetTimer(_ gameID: Int)
    case skipTurn(_ gameID: Int)
    case getQuestion(_ gameID: Int)
}

extension EmojiGoService: TargetType {
    var baseURL: URL {
        return URL(string: Environment.rootURLString + "/api/v1/emojigo")!
    }
    
    var path: String {
        //TODO: Remove the stupid "/" at the end after the API is fixed
        switch self {
        case .getEmojigo, .inviteEmojigo:
            return "/"
        case let .getEmogigoDetails(id),
             let .updateEmogigoFull(id, _, _, _, _),
             let .updateEmogigoPartial(id, _, _, _, _):
            return "/\(id)/"
        case let .sendAnswer(gameID, _):
            return "/\(gameID)/answer/"
        case let .sendQuestion(gameID, _, _):
            return "/\(gameID)/question/"
        case let .cancel(gameID):
            return "/\(gameID)/cancel/"
        case let .resetTimer(gameID):
            return "/\(gameID)/resetTimer/"
        case let .skipTurn(gameID):
            return "/\(gameID)/skip/"
        case let .getQuestion(gameID):
            return "/\(gameID)/questions/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getEmojigo,
             .getEmogigoDetails,
             .getQuestion:
            return .get
        case .inviteEmojigo,
             .sendAnswer,
             .sendQuestion,
             .cancel,
             .resetTimer,
             .skipTurn:
            return .post
        case .updateEmogigoFull:
            return .put
        case .updateEmogigoPartial:
            return .patch
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case let .getEmojigo(page):
            let parameter: [String: Any] = page != nil ? ["page": page!] : [:]
            return .requestParameters(parameters: parameter,
                                      encoding: URLEncoding.default)
        case let .inviteEmojigo(inviter, invitee):
            return .requestParameters(parameters: ["inviter": inviter,
                                                   "invitee": invitee],
                                      encoding: JSONEncoding.default)
        case .getEmogigoDetails,
             .cancel,
             .resetTimer,
             .skipTurn,
             .getQuestion:
            return .requestPlain
        case let .updateEmogigoFull(_, emojigo, inviter, invitee, turn),
             let .updateEmogigoPartial(_, emojigo, inviter, invitee, turn):
            return .requestParameters(parameters: ["emojigo": emojigo,
                                                   "inviter": inviter,
                                                   "invitee": invitee,
                                                   "turn": turn],
                                      encoding: JSONEncoding.default)
        case let .sendAnswer(_, answer):
            return .requestParameters(parameters: ["answer": answer],
                                      encoding: JSONEncoding.default)
        case let .sendQuestion(_, id, question):
            var parameters = [String: Any]()
            if let id = id {
                parameters["question_id"] = id
            }
            if let question = question {
                parameters["question_text"] = question
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

