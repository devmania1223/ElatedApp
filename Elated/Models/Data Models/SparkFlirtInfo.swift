//
//  SparkFlirtInfo.swift
//  Elated
//
//  Created by Rey Felipe on 7/6/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias SparkFlirtUser = MatchWith //This is the same struct sa MatchWith
typealias SparkFlirtDetail = GameDetail //This is the same struct sa GameDetail

struct SparkFlirtInfo {
    
//    BE Reponse Invite
/*
     {
       "status" : "SENT",
       "id" : 875,
       "game_status" : null,
       "source" : "facebook",
       "game_title" : null,
       "host_user" : 238,
       "sparkflirt_account" : 159,
       "user_info" : {
         "first_name" : "Alex",
         "images" : [
           {
             "source" : null,
             "updated_at" : "2021-06-23T03:03:21+0000",
             "user" : 238,
             "thumbnail" : "https:\/\/s3.amazonaws.com\/elated-api-dev-final\/uploads\/thumbnails\/37202ddc-eef9-4793-9d75-ec14551289dc.jpeg",
             "caption" : "",
             "pk" : 189,
             "order" : 1,
             "image" : "https:\/\/s3.amazonaws.com\/elated-api-dev-final\/uploads\/images\/4f4efaa3-5835-42f9-9194-dbc9732adb51.jpeg"
           },
           {
             "source" : null,
             "updated_at" : "2021-06-23T03:03:21+0000",
             "user" : 238,
             "thumbnail" : "https:\/\/s3.amazonaws.com\/elated-api-dev-final\/uploads\/thumbnails\/42afb2f9-4047-4588-846d-d3934ec19f3e.jpeg",
             "caption" : "",
             "pk" : 188,
             "order" : 2,
             "image" : "https:\/\/s3.amazonaws.com\/elated-api-dev-final\/uploads\/images\/833d20a3-ec69-4595-ade1-2482bca48941.jpeg"
           },
           {
             "source" : null,
             "updated_at" : "2021-06-23T03:03:21+0000",
             "user" : 238,
             "thumbnail" : "https:\/\/s3.amazonaws.com\/elated-api-dev-final\/uploads\/thumbnails\/f7914cf0-a0b2-444b-b668-02b9e245d197.jpeg",
             "caption" : "",
             "pk" : 187,
             "order" : 3,
             "image" : "https:\/\/s3.amazonaws.com\/elated-api-dev-final\/uploads\/images\/60dd42a9-5b82-49e5-a148-7ad977900e8e.jpeg"
           }
         ],
         "last_name" : "Martin",
         "birthdate" : "2009-06-09",
         "username" : "bofako9434@edmondpt.com",
         "occupation" : "Information Technologist",
         "user_id" : 238,
         "full_name" : "Alex Martin"
       },
       "invited_user" : 264
     },
     
     SENT
     {
       "msg" : "Success",
       "code" : 1,
       "success" : true,
       "data" : [
         {
           "invited_user" : 99,
           "user_info" : {
             "occupation" : "Software Engineer",
             "username" : "joshuakimrivera@gmail.com",
             "birthdate" : "2004-06-10",
             "first_name" : "Joshua Updated",
             "full_name" : "Joshua Updated Rivera",
             "user_id" : 99,
             "last_name" : "Rivera",
             "images" : [
               {
                 "pk" : 89,
                 "user" : 99,
                 "source" : null,
                 "image" : "https:\/\/s3.amazonaws.com\/elated-api-dev-final\/uploads\/images\/41bbe1d1-929c-4c82-aed0-9d394eb8d841.jpeg",
                 "caption" : "",
                 "order" : 2,
                 "updated_at" : "2021-07-07T01:58:36+0000",
                 "thumbnail" : "https:\/\/s3.amazonaws.com\/elated-api-dev-final\/uploads\/thumbnails\/0e75b658-2c06-4647-91bf-7c21d3e97c44.jpg"
               },
               {
                 "pk" : 90,
                 "user" : 99,
                 "source" : null,
                 "image" : "https:\/\/s3.amazonaws.com\/elated-api-dev-final\/uploads\/images\/e25d4f2f-26d2-473f-ab96-bd1962621f7e.jpg",
                 "caption" : "This one a test!",
                 "order" : 3,
                 "updated_at" : "2021-06-01T17:09:57+0000",
                 "thumbnail" : "https:\/\/s3.amazonaws.com\/elated-api-dev-final\/uploads\/thumbnails\/b6b0380f-c539-4c6f-9135-6e41d53b82e9.jpg"
               },
               {
                 "pk" : 84,
                 "user" : 99,
                 "source" : null,
                 "image" : "https:\/\/s3.amazonaws.com\/elated-api-dev-final\/uploads\/images\/5571ad26-7af8-4bb8-a8ad-5cb2a2b6f64a.jpg",
                 "caption" : "",
                 "order" : 49,
                 "updated_at" : "2021-05-31T11:02:53+0000",
                 "thumbnail" : "https:\/\/s3.amazonaws.com\/elated-api-dev-final\/uploads\/thumbnails\/07492a39-fe23-4389-98d9-18a3bb2e3523.jpg"
               }
             ]
           },
           "id" : 791,
           "game_title" : "EMOJIGO",
           "sparkflirt_account" : 185,
           "host_user" : 264,
           "game_status" : "SENT",
           "source" : "purchase"
         }
       ],
       "time" : "2021-07-07T05:43:38.814535"
     }
*/
    
    var id: Int?
    var status: SparkFlirtStatus?
    var gameStatus: SparkFlirtGameStatus?
    var gameTitle: String?
    var hostUser: Int?
    var invitedUser: Int?
    var source: String?
    var sparkflirtAccount: Int?
    var user: SparkFlirtUser?
    
    //ToDo need to know the actual structure
    init(_ json: JSON) {
        id = json["id"].intValue
        status = SparkFlirtStatus(rawValue: json["status"].stringValue)
        gameStatus = SparkFlirtGameStatus(rawValue: json["game_status"].stringValue)
        gameTitle = json["game_title"].stringValue
        hostUser = json["host_user"].intValue
        invitedUser = json["invited_user"].intValue
        source = json["source"].stringValue
        sparkflirtAccount = json["sparkflirt_account"].int
        user = SparkFlirtUser(JSON(json["user_info"]))
    }
    
}

struct SparkFlirtGameData {
    
//    BE Reponse Active Games
/*
     {
       "status" : "ACTIVE",
       "host_user" : {
         "first_name" : "",
         "birthdate" : null,
         "last_name" : "",
         "occupation" : null,
         "user_id" : 206,
         "images" : [

         ],
         "username" : "bohotev752@to200.com",
         "full_name" : ""
       },
       "invited_user" : {
         "first_name" : "Rey",
         "birthdate" : "1989-01-18",
         "last_name" : "Tester",
         "occupation" : "IT Freelancer",
         "user_id" : 264,
         "images" : [
           {
             "user" : 264,
             "thumbnail" : "https:\/\/s3.amazonaws.com\/elated-api-dev-final\/uploads\/thumbnails\/a905075b6b0c711a14c8ea1e5056eb2ca307ca340d758e0e483bb383330e16dc1rsg.jpeg",
             "source" : "Instagram",
             "pk" : 218,
             "order" : 1,
             "updated_at" : "2021-07-28T17:56:54+0000",
             "caption" : "The quick brown fox jumps over the lazy dog. Second line here",
             "image" : "https:\/\/s3.amazonaws.com\/elated-api-dev-final\/uploads\/images\/a905075b6b0c711a14c8ea1e5056eb2ca307ca340d758e0e483bb383330e16dc1rsg.jpeg"
           },
           {
             "user" : 264,
             "thumbnail" : "https:\/\/s3.amazonaws.com\/elated-api-dev-final\/uploads\/thumbnails\/e2c0c879-c4f9-4ea1-b6de-58fa9f6122bc.jpeg",
             "source" : null,
             "pk" : 296,
             "order" : 2,
             "updated_at" : "2021-07-28T17:42:36+0000",
             "caption" : "I like exploring what nature has to offer :)",
             "image" : "https:\/\/s3.amazonaws.com\/elated-api-dev-final\/uploads\/images\/e09192cb-0935-41be-8e2e-8782319856f1.jpeg"
           },
           {
             "user" : 264,
             "thumbnail" : "https:\/\/s3.amazonaws.com\/elated-api-dev-final\/uploads\/thumbnails\/0f6c1a129080bc2b2ecccabe1e364da284cce1fb3c8fc4a11130741a67a34fe8btc088f5v.jpeg",
             "source" : "Instagram",
             "pk" : 205,
             "order" : 3,
             "updated_at" : "2021-07-28T17:06:25+0000",
             "caption" : "",
             "image" : "https:\/\/s3.amazonaws.com\/elated-api-dev-final\/uploads\/images\/0f6c1a129080bc2b2ecccabe1e364da284cce1fb3c8fc4a11130741a67a34fe8btc088f5v.jpeg"
           },
           {
             "user" : 264,
             "thumbnail" : "https:\/\/s3.amazonaws.com\/elated-api-dev-final\/uploads\/thumbnails\/fe7f9d7502480bc1480a938e851b04150fd423146347ac292b81f4310273a25flieign0e1.jpeg",
             "source" : "Instagram",
             "pk" : 208,
             "order" : 4,
             "updated_at" : "2021-07-28T17:06:25+0000",
             "caption" : "",
             "image" : "https:\/\/s3.amazonaws.com\/elated-api-dev-final\/uploads\/images\/fe7f9d7502480bc1480a938e851b04150fd423146347ac292b81f4310273a25flieign0e1.jpeg"
           },
           {
             "user" : 264,
             "thumbnail" : "https:\/\/s3.amazonaws.com\/elated-api-dev-final\/uploads\/thumbnails\/fdb80bac-bc84-4968-a9cf-7a7a18aba40b.jpeg",
             "source" : null,
             "pk" : 202,
             "order" : 5,
             "updated_at" : "2021-07-28T17:06:25+0000",
             "caption" : "",
             "image" : "https:\/\/s3.amazonaws.com\/elated-api-dev-final\/uploads\/images\/3a8907f0-277b-477e-846e-a5269ca72466.jpeg"
           }
         ],
         "username" : "jrmfapps@gmail.com",
         "full_name" : "Rey Tester"
       },
       "game_title" : "EMOJIGO",
       "game_status" : "STARTED",
       "game": {
            "id": 2,
            "modified": "2021-08-20T16:04:14.799357Z",
            "current_player_turn": 32
        }
       "id" : 874,
       "sparkflirt_account" : 127,
       "source" : "purchase"
     },
*/
    
    var id: Int?
    var status: SparkFlirtStatus?
    var gameInfo: SparkFlirtGameInfo?
    var gameStatus: SparkFlirtGameStatus?
    var gameTitle: Game?
    var hostUser: SparkFlirtUser?
    var invitedUser: SparkFlirtUser?
    var source: String?
    var sparkflirtAccount: Int?
    
    enum Player {
        case inviter
        case invitee
    }
    
    init(_ json: JSON) {
        id = json["id"].intValue
        status = SparkFlirtStatus(rawValue: json["status"].stringValue)
        gameInfo = SparkFlirtGameInfo(JSON(json["game"]))
        gameStatus = SparkFlirtGameStatus(rawValue: json["game_status"].stringValue)
        gameTitle = Game(rawValue: json["game_title"].stringValue)
        hostUser = SparkFlirtUser(JSON(json["host_user"]))
        invitedUser = SparkFlirtUser(JSON(json["invited_user"]))
        source = json["source"].stringValue
        sparkflirtAccount = json["sparkflirt_account"].int
    }
    
    func isInvitersTurn() -> Bool {
        return gameInfo?.currentPlayerTurn == hostUser?.userId
    }
    
    func getProfileImage(player: Player) -> String {
        switch player {
        case .inviter:
            return hostUser?.images.first?.image ?? ""
        case .invitee:
            return invitedUser?.images.first?.image ?? ""
        }
    }
    
}



enum SparkFlirtGameStatus: String {
    case pending = "PENDING"
    case started = "STARTED"
    case completed = "COMPLETED"
    case cancelled = "CANCELLED"
}

enum SparkFlirtStatus: String {
    case none = "NONE"
    case sent = "SENT"
    case active = "ACTIVE"
    case completed = "COMPLETED"
    case rejected = "REJECTED"
    case expired = "EXPIRED"
    case cancelled = "CANCELLED"
}

struct SparkFlirtGameInfo {
//    BE Reponse Create/Start a new game
/*
     "game": {
          "id": 2,
          "modified": "2021-08-20T16:04:14.799357Z",
          "current_player_turn": 32
     }
 */
    var id: Int?
    var lastUpdate: String?
    var currentPlayerTurn: Int?
    
    init(_ json: JSON) {
        id = json["id"].intValue
        lastUpdate = json["modified"].stringValue
        currentPlayerTurn = json["current_player_turn"].intValue
    }
}

struct SparkFlirtNewGameInfo {
    
//    BE Reponse Create/Start a new game
/*
     {
        "code": 1,
        "msg": "Success",
        "success": true,
        "time": "2021-08-06T12:26:57.890218",
        "data":{
            "game_id": 2,
            "game_title": "BASHO"
        }
    }
*/
    var id: Int?
    var gameTitle: Game?
    
    init(_ json: JSON) {
        id = json["game_id"].intValue
        gameTitle = Game(rawValue: json["game_title"].stringValue)
    }
    
}

struct SparkFlirtPurchaseData {
    
//    BE Reponse Purchase History
/*
     "data":{
        "created_at":"2021-09-03T15:26:48+0000",
        "payment_gateway":"APPLE",
        "orderitems" : [
        {
            "converted_price" : null,
            "product" : {
                "available" : true,
                "description" : "3 Sparkflirts for $2.99",
                "price" : "2.99",
                "name" : "3 Sparkflirts",
                "image" : null,
                "id" : 6
            },
            "price" : "2.99",
            "order" : 6,
            "quantity" : 3
        }]
     }
*/
    var date: String?
    var orderItems = [SparkFlirtPurchaseItem]()
    
    init(_ json: JSON) {
        date = json["created_at"].stringValue
        orderItems = json["orderitems"].arrayValue.map { SparkFlirtPurchaseItem($0) }
    }
    
}

struct SparkFlirtPurchaseItem {
    
    /*
        {
            "order":51,
            "converted_price" : null,
            "product" : {
                "available" : true,
                "description" : "3 Sparkflirts for $2.99",
                "price" : "2.99",
                "name" : "3 Sparkflirts",
                "image" : null,
                "id" : 6
            },
            "price":"0.99",
            "quantity":1
        }
    */
    
    var name: String?
    var price: String?
    var convertedPrice: String?

    init(_ json: JSON) {
        name = json["product"]["name"].stringValue
        price = json["product"]["price"].stringValue
        convertedPrice = json["converted_price"].stringValue
    }
}
