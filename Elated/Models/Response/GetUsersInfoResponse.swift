//
//  GetUsersInfoResponse.swift
//  Elated
//
//  Created by Marlon on 10/30/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import SwiftyJSON

struct GetUsersInfoResponse: BaseResponse {
    
    var msg: String?

    var time: Int?
    
    var code: Int?
    
    var success: Bool?
        
    var users = [UserInfoShort]()
        
    init(_ json: JSON) {
        baseInit(json)
        users = (json["data"].array ?? []).map { UserInfoShort($0) }
    }
    
}
