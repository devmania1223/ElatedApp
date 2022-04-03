//
//  InstagramResponse.swift
//  Elated
//
//  Created by Marlon on 6/2/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import SwiftyJSON

struct InstagramAuthResponse: BaseResponse {
    
    var msg: String?
    
    var time: Int?
    
    var code: Int?

    var success: Bool?
    
    var data: InstagramAuth?
    
    init(_ json: JSON) {
        baseInit(json)
        data = InstagramAuth(json["data"])
    }

}

