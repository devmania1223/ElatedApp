//
//  GetMatchesResponse.swift
//  Elated
//
//  Created by Marlon on 6/16/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import SwiftyJSON

struct GetMatchesResponse: BaseResponse, Pagination {
    
    var count: Int = 0
    
    var next: Int?
    
    var previous: Int?
    
    var total_pages: Int = 0

    var msg: String?
    
    var time: Int?
    
    var code: Int?

    var success: Bool?
    
    var data = [Match]()
    
    init(_ json: JSON) {
        baseInit(json)
        pageInit(json["pagination"])
        data = json["data"].arrayValue.map { Match($0) }
    }
    
}
