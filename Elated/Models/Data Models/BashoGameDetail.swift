//
//  Basho.swift
//  Elated
//
//  Created by Marlon on 4/13/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import SwiftyJSON

struct BashoGameDetail {
    
    var id: Int?
    var created: String?
    var modified: String?
    var basho = [BashoLine]()
    var currentLine: Int?
    var currentSyllablesCount: Int?
    var inviter: Invitee?
    var invitee: Invitee?
    var currentPlayerTurn: Int?
    var inviteeSkips: Int?
    var inviteeReset: Int?
    var inviterSkips: Int?
    var inviterReset: Int?
    var sparkFlirt: SparkFlirtInfo!
    var gameStatus: SparkFlirtGameStatus = .pending

    init(_ json: JSON) {
        id = json["id"].intValue
        created = json["created"].stringValue
        modified = json["modified"].stringValue
        basho = (json["basho"].array?.map({ BashoLine($0) }) ?? [])
        currentLine = json["current_line"].intValue
        currentSyllablesCount = json["current_syllables_count"].intValue
        inviter = Invitee(json["inviter"])
        invitee = Invitee(json["invitee"])
        currentPlayerTurn = json["current_player_turn"].intValue
        inviteeSkips = json["invitee_skips"].intValue
        inviteeReset = json["invitee_reset"].intValue
        inviterSkips = json["inviter_skips"].intValue
        inviterReset = json["inviter_reset"].intValue
        sparkFlirt = SparkFlirtInfo(json["sparkflirt"])
        gameStatus = SparkFlirtGameStatus(rawValue: json["game_status"].stringValue.uppercased()) ?? .pending
    }
    
}

struct Invitee {
    //For Game Detail invitee id
    var userID: Int?
    
    //Universal id
    var id: Int?
    
    var firstName: String?
    var lastName: String?
    var avatar: Avatar?

    init(_ json: JSON) {
        userID = json["user_id"].intValue
        id = json["id"].intValue
        if id == 0 {
            id = json["user_id"].intValue
        }
        firstName = json["first_name"].stringValue
        lastName = json["last_name"].stringValue
        avatar = Avatar(json["avatar"])
    }
    
    func getDisplayName() -> String {
        return "\(firstName ?? "") \((lastName?.first ?? " ").uppercased())."
    }
    
}

struct BashoLine {
    var line: String = ""
    var user: Int = 0
    var time: Int = 0
    
    init(_ json: JSON) {
        line = json["line"].stringValue
        user = json["user"].intValue
        time = json["time"].intValue
    }
}

struct Avatar {
    
    var id: Int?
    var user: Int?
    var image: String?
    var thumbnail: String?
    var order: Int?
    var caption: String?
    var source: String?
    
    init(_ json: JSON) {
        id = json["id"].intValue
        user = json["user"].intValue
        image = json["image"].stringValue
        thumbnail = json["thumbnail"].stringValue
        order = json["order"].int
        caption = json["caption"].stringValue
        source = json["source"].stringValue
    }
    
}
