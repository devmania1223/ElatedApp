//
//  GetGamesResponse.swift
//  Elated
//
//  Created by Marlon on 10/22/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import SwiftyJSON

struct GetGamesResponse: BaseResponse, Pagination {
    
    var count: Int = 0
    
    var next: Int?
    
    var previous: Int?
    
    var total_pages: Int = 0
    
    var msg: String?

    var time: Int?
    
    var code: Int?
    
    var success: Bool?
        
    var games = [GameDetail]()
        
    init(_ json: JSON) {
        baseInit(json)
        pageInit(json)
        games = (json["data"].array ?? []).map { GameDetail($0) }
    }
    
}
