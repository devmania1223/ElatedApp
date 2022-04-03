//
//  Books.swift
//  Elated
//
//  Created by John Lester Celis on 2/28/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

struct Book {
    
    var id: Int?
    var volumeID: String?
    var title: String?
    var cover: String?
    var description: String?
    var authors = [String]()
    var publishDate: String?
    
    init(_ json: JSON) {
        id = json["id"].int
        volumeID = json["volume_id"].stringValue
        title = json["title"].stringValue
        cover = json["image_link"].stringValue
        description = json["description"].stringValue
        publishDate = json["published_date"].stringValue
        authors = json["authors"].arrayValue.map { "\($0)" }
    }
    
}
