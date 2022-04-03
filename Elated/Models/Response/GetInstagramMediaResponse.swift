//
//  GetInstagramMediaResponse.swift
//  Elated
//
//  Created by Marlon on 6/3/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import SwiftyJSON

struct GetInstagramMediaResponse: BaseResponse {
    
    var msg: String?
    
    var time: Int?
    
    var code: Int?

    var success: Bool?
    
    var data = [InstagramMedia]()
    
    var page: InstagramMediaPagination?

    init(_ json: JSON) {
        baseInit(json)
        data = json["data"]["data"].arrayValue.map { InstagramMedia($0) }
        page = InstagramMediaPagination(json["data"]["paging"]["cursors"])
    }

}
