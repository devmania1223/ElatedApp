//
//  EmojiGoDetail.swift
//  Elated
//
//  Created by Marlon on 9/3/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import SwiftyJSON

enum EmogiGoTurnType: String {
    case question = "QUESTION"
    case answer = "ANSWER"
}

struct EmojiGoGameDetail {
    
    var id: Int?
    var created: String?
    var modified: String?
    var emojigo = [EmojiGo]()
    var inviter: Invitee?
    var invitee: Invitee?
    var currentPlayerTurn: Int?
    var turnType: EmogiGoTurnType = .question
    var round: Int = 1
    var inviteeSkips: Int = 0
    var inviteeReset: Int = 0
    var inviterSkips: Int = 0
    var inviterReset: Int = 0
    var sparkFlirt: SparkFlirtInfo!
    var gameStatus: SparkFlirtGameStatus = .pending
    var isKeyboard: Bool = false
    
    init(_ json: JSON) {
        id = json["id"].intValue
        created = json["created"].stringValue
        modified = json["modified"].stringValue
        emojigo = json["emojigo"].arrayValue.map { EmojiGo($0) }
        inviter = Invitee(json["inviter"])
        invitee = Invitee(json["invitee"])
        currentPlayerTurn = json["current_player_turn"].intValue
        inviteeSkips = json["invitee_skips"].intValue
        inviteeReset = json["invitee_reset"].intValue
        inviterSkips = json["inviter_skips"].intValue
        inviterReset = json["inviter_reset"].intValue
        sparkFlirt = SparkFlirtInfo(json["sparkflirt"])
        turnType = EmogiGoTurnType(rawValue: json["turn_type"].stringValue.uppercased()) ?? .question
        round = json["current_round"].intValue
        gameStatus = SparkFlirtGameStatus(rawValue: json["game_status"].stringValue.uppercased()) ?? .pending
        isKeyboard = json["is_keyboard"].boolValue
    }
    
}

struct EmojiGo {
    
    var round: Int = 1
    var answer: EmojiGoAnswer?
    var question: EmojiGoQuestion?
    
    init(_ json: JSON) {
        round = json["round"].intValue
        answer = EmojiGoAnswer(json["answer"])
        question = EmojiGoQuestion(json["question"])
    }
    
}


