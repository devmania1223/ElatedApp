//
//  Notification.swift
//  Elated
//
//  Created by Marlon on 5/29/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import SwiftyJSON

struct UserNotification {
    
    var id: Int?
    var email: Bool?
    var eblast: Bool?
    var match: Bool?
    var sparkFlirtInvite: Bool?
    var nudge: Bool?
    var favorite: Bool?

    init(_ json: JSON) {
        id = json["id"].intValue
        email = json["email"].boolValue
        eblast = json["eblast"].boolValue
        match = json["match"].boolValue
        sparkFlirtInvite = json["sparkflirt_invite"].boolValue
        nudge = json["nudge"].boolValue
        favorite = json["favorite"].boolValue
    }
    
}
