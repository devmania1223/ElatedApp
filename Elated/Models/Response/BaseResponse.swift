//
//  BaseResponse.swift
//  Elated
//
//  Created by Marlon on 2021/2/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import SwiftyJSON

//TODO: Support pagination

protocol BaseResponse {
    var msg: String? { get set }
    var time: Int? { get set }
    var code: Int? { get set }
    var success: Bool? { get set }
    
    init(_ json: JSON)
}

protocol Pagination {
    var count: Int { get set }
    var next: Int? { get set }
    var previous: Int? { get set }
    var total_pages: Int { get set }
}

extension BaseResponse {
    mutating func baseInit(_ json: JSON) {
        //TODO: Remove ?? on api V2
        msg = json["msg"].string ?? ""
        time = json["time"].int ?? 1
        code = json["code"].int ?? -1
        success = json["success"].bool ?? success
    }
    
}

extension Pagination {
    mutating func pageInit(_ json: JSON) {
        count = json["count"].intValue
        next = json["next"].int
        previous = json["previous"].int
        total_pages = json["total_pages"].intValue
    }
}
