//
//  PlacesResponse.swift
//  Elated
//
//  Created by Marlon on 5/28/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import SwiftyJSON

struct PlacesResponse: BaseResponse {
    var msg: String?
    
    var time: Int?
    
    var code: Int?

    var success: Bool?
    
    var places = [Place]()
    
    init(_ json: JSON) {
        baseInit(json)
        places = json["data"].arrayValue.map { Place($0) }
    }
}
