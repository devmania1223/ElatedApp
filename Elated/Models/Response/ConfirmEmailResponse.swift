//
//  ConfirmEmailResponse.swift
//  Elated
//
//  Created by Marlon on 5/12/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import SwiftyJSON

struct ConfirmEmailResponse: BaseResponse {
    var msg: String?
    
    var time: Int?
    
    var code: Int?

    var success: Bool?
    
    var user: UserInfo?
    
    var token: String?
    
    init(_ json: JSON) {
        baseInit(json)
        user = UserInfo(json["data"]["user"])
        token = json["data"]["token"].string
    }
}
