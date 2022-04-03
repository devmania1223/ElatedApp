//
//  GetBashoResponse.swift
//  Elated
//
//  Created by Marlon on 4/13/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import SwiftyJSON

struct GetBashoInvitesResponse: BaseResponse, Pagination {
    
    var count: Int = 0
    
    var next: Int?
    
    var previous: Int?
    
    var total_pages: Int = 0
    
    var msg: String?

    var time: Int?
    
    var code: Int?
    
    var success: Bool?
        
    var basho = [BashoGameDetail]()
        
    init(_ json: JSON) {
        baseInit(json)
        pageInit(json)
        basho = (json["data"].array ?? []).map { BashoGameDetail($0) }
    }
    
}

struct GetBashoResponse: BaseResponse {
    
    var msg: String?

    var time: Int?
    
    var code: Int?
    
    var success: Bool?
            
    var basho: BashoGameDetail?
    
    init(_ json: JSON) {
        baseInit(json)
        basho = BashoGameDetail(json["data"])
    }
    
}
