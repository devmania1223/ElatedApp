//
//  SocialAuth.swift
//  Elated
//
//  Created by Marlon on 2021/3/18.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import SwiftyJSON

struct SocialAuth {
    
    var id: Int?
    var provider: String?
    var uid: String?
    var created: String?
    var modified: String?
    var user: Int?
    
    init(_ json: JSON) {
        id = json["id"].int
        provider = json["provider"].stringValue
        uid = json["uid"].stringValue
        created = json["created"].stringValue
        modified = json["modified"].stringValue
        user = json["user"].intValue
    }
    
}
