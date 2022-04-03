//
//  InstagramAuth.swift
//  Elated
//
//  Created by Marlon on 6/2/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import SwiftyJSON

struct InstagramAuth {
    
    var token = ""
    var userId = 0
    
    init(_ json: JSON) {
        token = json["access_token"].stringValue
        userId = json["user_id"].intValue
    }
    
}
