//
//  InstagramMedia.swift
//  Elated
//
//  Created by Marlon on 6/3/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import SwiftyJSON

struct InstagramMedia {
    
    var id: String?
    var mediaURL: URL?

    init(_ json: JSON) {
        id = json["id"].stringValue
        mediaURL = json["media_url"].url
    }
    
}
