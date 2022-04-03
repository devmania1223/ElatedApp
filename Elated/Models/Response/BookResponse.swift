//
//  BookResponse.swift
//  Elated
//
//  Created by John Lester Celis on 3/2/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import SwiftyJSON

struct BookResponse: BaseResponse, Pagination {
   
    var count: Int = 0
    
    var next: Int?
    
    var previous: Int?
    
    var total_pages: Int = 0
    
    var msg: String?

    var time: Int?
    
    var code: Int?
    
    var success: Bool?
    
    var books = [Book]()
    
    init(_ json: JSON) {
        baseInit(json)
        pageInit(json["pagination"])
        books = json["data"].arrayValue.map { Book($0) }
    }
    
}
