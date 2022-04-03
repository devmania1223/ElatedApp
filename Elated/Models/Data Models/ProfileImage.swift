//
//  ProfileImage.swift
//  Elated
//
//  Created by Marlon on 5/21/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ProfileImage {
    
    var pk: Int?
    var image: String?
    var thumbnail: String?
    var order: Int?
    var caption: String?

    init(_ json: JSON) {
        pk = json["pk"].intValue
        image = json["image"].stringValue
        thumbnail = json["thumbnail"].stringValue
        order = json["order"].intValue
        caption = json["caption"].stringValue
    }
    
    init(avatar: Avatar) {
        pk = avatar.id
        image = avatar.image
        thumbnail = avatar.thumbnail
        order = avatar.order
        caption = avatar.caption
    }
    
}
