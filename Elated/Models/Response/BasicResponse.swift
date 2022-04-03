//
//  BasicResponse.swift
//  Elated
//
//  Created by Marlon on 2021/2/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import SwiftyJSON

struct BasicResponse: BaseResponse {
    var msg: String?
    
    var time: Int?
    
    var code: Int?

    var success: Bool?
    
    var data: JSON = .null
    
    init(_ json: JSON) {
        baseInit(json)
        //TODO: Remove condition on v2 api
        if json["data"] == [] {
            data = json
        } else {
            data = json["data"]
        }
    }

}
