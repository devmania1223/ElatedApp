//
//  InAppNotification.swift
//  Elated
//
//  Created by Rey Felipe on 11/15/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import SwiftyJSON

enum InAppNotificationType: String {

    case favorite = "FAVORITE"
    case gameCanceledBasho = "GAME.CANCELED.BASHO"
    case gameCanceledEmojiGo = "GAME.CANCELED.EMOJIGO"
    case gameCanceledStoryShare = "GAME.CANCELED.STORYSHARE"
    case gameCompletedBasho = "GAME.COMPLETED.BASHO"
    case gameCompletedEmojiGo = "GAME.COMPLETED.EMOJIGO"
    case gameCompletedStoryShare = "GAME.COMPLETED.STORYSHARE"
    case gameTurnBasho = "GAME.TURN.BASHO"
    case gameTurnEmojiGo = "GAME.TURN.EMOJIGO"
    case gameTurnStoryShare = "GAME.TURN.STORYSHARE"
    case nudgeGame = "NUDGE.GAME"
    case nudgeSparkFlirtInvite = "NUDGE.SF.INVITE"
    case sparkFlirtInvite = "SF.INVITE"
    case sparkFlirtInviteAccepted = "SF.INVITE.ACCEPTED"
    
    func getIconImage() -> String {
        switch self {
        case .favorite:
            return "button-favorites-circle"
        case .gameCanceledBasho, .gameCompletedBasho, .gameTurnBasho:
            return "button-basho-circle"
        case .gameCanceledEmojiGo, .gameCompletedEmojiGo, .gameTurnEmojiGo:
            return "button-emojigo-circle"
        case .gameCanceledStoryShare, .gameCompletedStoryShare, .gameTurnStoryShare:
            return "button-storyshare-circle"
        case .nudgeGame, .nudgeSparkFlirtInvite:
            return "button-nudge"
        case .sparkFlirtInvite, .sparkFlirtInviteAccepted:
            return "button-sparkflirt"
        }
    }
}

struct InAppNotificationData {
    
//    BE Reponse
/*
 {
   "from_user" : 360,
   "sender" : {
     "avatar" : {
       "pk" : 444,
       "image" : "https:\/\/s3.amazonaws.com\/elated-api-dev-final\/uploads\/images\/6b73b37a-ec5a-49cf-9575-97ce707dbe1a.jpeg",
       "order" : 1,
       "user" : 360,
       "source" : null,
       "caption" : "",
       "thumbnail" : "https:\/\/s3.amazonaws.com\/elated-api-dev-final\/uploads\/thumbnails\/ccb476e2-a919-40be-b729-1550a4e01b2b.jpeg",
       "updated_at" : "2021-10-13T07:35:22+0000"
     },
     "username" : "redav95813@specialistblog.com",
     "first_name" : "Tester Rey",
     "last_name" : "Felipe",
     "id" : 360
   },
   "updated_at" : "2021-12-04T03:45:21+0000",
   "pk" : 25,
   "sid" : "NTc7c1a480b4d32be14e42ba6781f4c709",
   "type" : "SF.INVITE",
   "is_read" : false,
   "message" : "redav95813@specialistblog.com invited you to play None!",
   "created_at" : "2021-12-04T03:45:21+0000",
   "action_id" : null,
   "to_user" : 264
 },
*/
    var id: Int?
    var type: InAppNotificationType?
    var isRead: Bool = false
    var message: String?
    var dateTimeStamp: String?
    var sender: UserInfoShort?
    var game: Game?
    var actionId: Int?
    
    init(_ json: JSON) {
        id = json["pk"].intValue
        type = InAppNotificationType(rawValue: json["type"].stringValue)
        isRead = json["is_read"].boolValue
        message = json["message"].stringValue
        sender = UserInfoShort(json["sender"])
        game = Game(rawValue: json["game"].stringValue)
        dateTimeStamp = json["created_at"].stringValue
        actionId = json["action_id"].intValue
    }
    
}
