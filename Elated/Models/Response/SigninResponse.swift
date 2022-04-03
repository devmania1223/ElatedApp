//
//  SigninResponse.swift
//  Elated
//
//  Created by Marlon on 2021/3/18.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import SwiftyJSON

struct SigninResponse: BaseResponse {

    var msg: String?

    var time: Int?
    
    var code: Int?
    
    var success: Bool?
        
    var user: UserInfo?
    
    var token: String?

    init(_ json: JSON) {
        baseInit(json)
        token = json["data"]["token"].string
        user = UserInfo(json["data"]["user"])
    }
    
}
