//
//  GameDetail.swift
//  Elated
//
//  Created by Marlon on 10/22/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import SwiftyJSON

struct GameDetail {
    
    var id: Int?
    var game: Game?
    var detail: GamePlayerDetails?
    var created: String?
    var modified: String?
    var status: SparkFlirtStatus?
    var source: String?
    var gameStatus: SparkFlirtGameStatus?
    var gamePendingDatetime: String?
    var gameStartedDatetime: String?
    var gameCompleteDatetime: String?
    var gameCancelledDatetime: String?
    var others: String?
    var sparkFlirtAccount: Int?
    var hostUser: Invitee?
    var invitedUser: Invitee?
    var order: Int?
    var cancelledBy: Int?
    
    init(_ json: JSON) {
        id = json["id"].intValue
        game = Game(rawValue: json["game_title"].stringValue)
        detail = GamePlayerDetails(json["game"])
        created = json["created"].stringValue
        modified = json["modified"].stringValue
        status = SparkFlirtStatus(rawValue: json["status"].stringValue)
        source = json["source"].string
        gameStatus = SparkFlirtGameStatus(rawValue: json["game_status"].stringValue)
        gamePendingDatetime = json["game_pending_datetime"].string
        gameStartedDatetime = json["game_started_datetime"].string
        gameCompleteDatetime = json["game_completed_datetime"].string
        gameCancelledDatetime = json["game_cancelled_datetime"].string
        others = json["others"].string
        sparkFlirtAccount = json["sparkflirt_account"].int
        hostUser = Invitee(json["host_user"])
        invitedUser = Invitee(json["invited_user"])
        order = json["order"].int
        cancelledBy = json["cancelled_by"].int
    }
    
}

struct GamePlayerDetails {
    
    var id: Int?
    var game: Game?
    var created: String?
    var modified: String?
    var inviter: Invitee?
    var invitee: Invitee?
    var currentPlayerTurn: Int?
    
    init(_ json: JSON) {
        id = json["id"].intValue
        game = Game(rawValue: json["game_title"].stringValue)
        created = json["created"].stringValue
        modified = json["modified"].stringValue
        inviter = Invitee(json["inviter"])
        invitee = Invitee(json["invitee"])
        currentPlayerTurn = json["current_player_turn"].intValue
    }
    
}
