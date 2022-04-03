//
//  GetUserInfoResponse.swift
//  Elated
//
//  Created by Marlon on 2021/3/18.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import SwiftyJSON

struct GetUserInfoResponse: BaseResponse {

    var msg: String?

    var time: Int?
    
    var code: Int?
    
    var success: Bool?
    
    var user: UserInfo?
    
    init(_ json: JSON) {
        baseInit(json)
        user = UserInfo(json["data"])
    }
    
}
