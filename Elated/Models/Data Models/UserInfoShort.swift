//
//  UserInfoShort.swift
//  Elated
//
//  Created by Marlon on 10/30/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import SwiftyJSON

struct UserInfoShort {

    var id: Int?
    var firstName: String?
    var lastName: String?
    var avatar: Avatar?
    var username: String?
    var email: String?
    var location: Int?

    init(_ json: JSON) {
        id = json["id"].intValue
        firstName = json["first_name"].stringValue
        lastName = json["last_name"].stringValue
        avatar = Avatar(json["avatar"])
        username = json["username"].stringValue
        email = json["email"].stringValue
        location = json["location"].int
    }
    
    func getDisplayName() -> String {
        return "\(firstName ?? "") \((lastName?.first ?? " ").uppercased())."
    }
    
}
