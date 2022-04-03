//
//  Place.swift
//  Elated
//
//  Created by Marlon on 5/28/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Place {
    
    var address: String?
    var location: PlaceLocation?
    var placeID: String?

    init(_ json: JSON) {
        address = json["address"].stringValue
        location = PlaceLocation(json["location"])
        placeID = json["places_id"].stringValue
    }
    
}

struct PlaceLocation {
    
    var lat: Float?
    var lng: Float?
    var zipCode: Int?

    init(_ json: JSON) {
        lat = json["lat"].floatValue
        lng = json["lng"].floatValue
        zipCode = json["zip_code"].intValue
    }
    
}
