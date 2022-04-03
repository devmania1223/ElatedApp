//
//  ThisOrThatResponse.swift
//  Elated
//
//  Created by John Lester Celis on 4/8/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ThisOrThatResponse: BaseResponse {
    
    var msg: String?

    var time: Int?
    
    var code: Int?
    
    var success: Bool?

    var tot_threshold: Bool?
    
    var thisorthat = [ToTQuestions]()
    
    init(_ json: JSON) {
        baseInit(json)
        thisorthat = json["data"].arrayValue.map { ToTQuestions($0) }
    }
}

enum ToTQuestionKind: Int {
    case unknown
    case one
    case many
    case other
    case orderedChoices
    case shortText
    case longText
    case height
    case list
}

struct ToTQuestions {
    var id: Int?
    var required: Bool?
    var question: String?
    var kind: ToTQuestionKind
    var choices = [ToTChoices]()
    
    init(_ json: JSON) {
        id = json["id"].intValue
        required = json["required"].boolValue
        question = json["text"].stringValue
        kind = ToTQuestionKind(rawValue: json["kind"].intValue) ?? .unknown
        choices = json["choices"].arrayValue.map { ToTChoices($0) }
    }
}

struct ToTChoices {
    var id: Int?
    var subset = [ToTChoices]()
    var text: String?
    var order: Int?
    init(_ json: JSON) {
        id = json["id"].intValue
        subset = json["subset"].arrayValue.map { ToTChoices($0) }
        text = json["text"].stringValue
        order = json["kind"].intValue
    }
}

