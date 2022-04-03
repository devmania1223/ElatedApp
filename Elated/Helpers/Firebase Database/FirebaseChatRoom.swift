//
//  FirebaseChatMessage.swift
//  Elated
//
//  Created by Marlon on 10/28/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON

struct FirebaseChatRoom {
    var invitee: Int = 0
    var inviter: Int = 0
    var created: String = ""
    var lastChat: String = ""
    var updated: String = ""
    
    init(_ json: JSON) {
        invitee = json["invitee"].intValue
        inviter = json["inviter"].intValue
        created = json["created"].stringValue
        lastChat = json["last_chat"].stringValue
        updated = json["updated"].stringValue
    }
}

struct FirebaseChatMessage {
    var id: String = ""
    var message: String = ""
    var image: URL?
    var created: String = ""
    var updated: String = ""
    var sender: Int = 0
    var isImage: Bool = false
    var isDeleted: Bool = false

    init(_ json: JSON) {
        id = json["id"].stringValue
        message = json["message"].stringValue
        image = json["image"].url
        created = json["created"].stringValue
        updated = json["updated"].stringValue
        sender = json["sender"].intValue
        isImage = json["isImage"].boolValue
        isDeleted = json["isDeleted"].boolValue
    }
}

struct FirebaseChatUserStatus {
    var id: Int = 0
    var updated: String?
    var online: Bool = false
    
    init(_ json: JSON) {
        id = json["id"].intValue
        updated = json["updated"].stringValue
        online = json["online"].boolValue
    }
}
