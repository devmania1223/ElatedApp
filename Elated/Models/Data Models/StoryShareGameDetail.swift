//
//  StoryShareGameDetail.swift
//  Elated
//
//  Created by Marlon on 10/6/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import SwiftyJSON

enum StoryShareColor: String {
    
    case red = "D96969"
    case blue = "4A91D4"
    case orange = "FF8F1F"
    case mustard = "D1B200"
    case pink = "FF82BA"
    case green = "54C479"
    case violet = "8A4AD4"
    case gray = "737373"
    
    func getColor() -> UIColor {
        return UIColor(hexString: self.rawValue)
    }
        
    func getName() -> String {
        switch self {
        case .red:
            return "Red"
        case .blue:
            return "Blue"
        case .orange:
            return "Orange"
        case .mustard:
            return "Mustard"
        case .pink:
            return "Pink"
        case .green:
            return "Green"
        case .violet:
            return "Violet"
        case .gray:
            return "Gray"
        }
    }
    
}

struct StoryShareGameDetail {
    
    var id: Int?
    var created: String?
    var modified: String?
    var phrases = [Phrase]()
    var sentence: String?
    var phraseCounter: Int = 0
    var inviter: Invitee?
    var invitee: Invitee?
    var currentPlayerTurn: Int?
    var inviterTextColor: StoryShareColor?
    var inviteeTextColor: StoryShareColor?
    var sparkFlirt: SparkFlirtInfo!
    var gameStatus: SparkFlirtGameStatus = .pending
    
    init(_ json: JSON) {
        id = json["id"].intValue
        created = json["created"].stringValue
        modified = json["modified"].stringValue
        phrases = json["phrases"].arrayValue.map { Phrase($0) }
        sentence = json["sentence"].stringValue
        phraseCounter = json["phrase_counter"].intValue
        inviter = Invitee(json["inviter"])
        invitee = Invitee(json["invitee"])
        currentPlayerTurn = json["current_player_turn"].intValue
        inviterTextColor = StoryShareColor(rawValue: json["inviter_text_color"].stringValue)
        inviteeTextColor = StoryShareColor(rawValue: json["invitee_text_color"].stringValue)
        sparkFlirt = SparkFlirtInfo(json["sparkflirt"])
        gameStatus = SparkFlirtGameStatus(rawValue: json["game_status"].stringValue.uppercased()) ?? .pending
    }
    
}

struct Phrase {
    
    var user: Int = 0
    var phrase: String = ""
    var counter: Int = 0
    
    init(_ json: JSON) {
        user = json["user"].intValue
        phrase = json["phrase"].stringValue
        counter = json["counter"].intValue
    }
    
}

