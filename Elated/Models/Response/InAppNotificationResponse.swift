//
//  InAppNotificationResponse.swift
//  Elated
//
//  Created by Rey Felipe on 11/15/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import SwiftyJSON

struct InAppNotificationUnreadCountResponse: BaseResponse {
    
    var msg: String?

    var time: Int?
    
    var code: Int?
    
    var success: Bool?
    
    var unreadNotifs: Int = 0
    
    init(_ json: JSON) {
        baseInit(json)
        unreadNotifs = json["unread_notifications"].intValue
    }
    
}

struct InAppNotificationResponse: BaseResponse, Pagination {
    
    var count: Int = 0
    
    var next: Int?
    
    var previous: Int?
    
    var total_pages: Int = 0
    
    var msg: String?

    var time: Int?
    
    var code: Int?
    
    var success: Bool?
    
    var data = [InAppNotificationData]()
    
    init(_ json: JSON) {
        baseInit(json)
        pageInit(json["pagination"])
        data = json["data"].arrayValue.map { InAppNotificationData($0) }
    }
    
}
