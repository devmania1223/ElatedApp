//
//  SparkFlirtAccount.swift
//  Elated
//
//  Created by Marlon on 2021/3/18.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import SwiftyJSON

struct SparkFlirtAccount {
    let id: Int?
    let created: String?
    let modified: String?
    let user: Int?
    
    init(_ json: JSON) {
        id = json["id"].intValue
        created = json["created"].string
        modified = json["modified"].string
        user = json["user"].intValue
    }
    
}
