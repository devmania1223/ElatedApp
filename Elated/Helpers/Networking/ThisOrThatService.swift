//
//  ThisOrThatService.swift
//  Elated
//
//  Created by Marlon on 2021/3/16.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import Moya

enum ThisOrThatService {
    case getAnswers(page: Int)
    case createAnswers(question: Int, text: String)
    case getAnswerByPath(id: Int)
    case updateAnswerFull(id: Int, question: Int, text: String)
    case updateAnswerPartial(id: Int, question: Int, text: String)
    case deleteAnswer(id: Int)
    case getQuestions(page: Int)
    case getOnboardingQuestions
    case setAnswer(id: Int, text: String, trigger: Int)
}

extension ThisOrThatService: TargetType {
    
    var baseURL: URL {
        return URL(string: Environment.rootURLString + "/api/v1/thisorthat")!
    }
    
    var path: String {
        //TODO: Remove the stupid "/" at the end after the API is fixed
        switch self {
        case .getAnswers,
             .createAnswers:
            return "/answers/"
        case let .getAnswerByPath(id),
             let .updateAnswerFull(id, _, _),
             let .updateAnswerPartial(id, _, _),
             let .deleteAnswer(id):
            return "/answers/\(id)/"
        case .getQuestions:
            return "/questions/"
        case .getOnboardingQuestions:
            return "/questions/get_questions/"
        case let .setAnswer(id, _, _):
            return "/questions/\(id)/answer/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAnswers,
             .getAnswerByPath,
             .getOnboardingQuestions,
             .getQuestions:
            return .get
        case .createAnswers,
             .setAnswer:
            return .post
        case .updateAnswerFull:
            return .put
        case .updateAnswerPartial:
            return .patch
        case .deleteAnswer:
            return .delete
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case let .getAnswers(page),
             let .getQuestions(page):
            return .requestParameters(parameters: ["page": page],
                                      encoding: URLEncoding.default)
        case let .createAnswers(question, text),
             let .updateAnswerFull(_, question, text),
             let .updateAnswerPartial(_, question, text):
            return .requestParameters(parameters: ["question": question,
                                                   "text": text],
                                      encoding: JSONEncoding.default)
        case let .setAnswer(_, text, trigger):
            return .requestParameters(parameters: ["text": text,
                                                   "value_preferences": trigger],
                                      encoding: JSONEncoding.default)
        case .deleteAnswer,
             .getAnswerByPath,
             .getOnboardingQuestions:
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

