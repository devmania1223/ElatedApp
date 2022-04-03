//
//  Location.swift
//  Elated
//
//  Created by Marlon on 5/21/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Location {
    
    var id: Int?
    var lat: String?
    var lng: String?
    var placeId: String?
    var address: String?
    var zipCode: String?
    var user: Int?

    init(_ json: JSON) {
        id = json["id"].int
        lat = json["lat"].stringValue
        lng = json["lng"].stringValue
        placeId = json["place_id"].stringValue
        address = json["formatted_address"].stringValue
        zipCode = json["zip_code"].stringValue
        user = json["user"].intValue
    }
    
}
