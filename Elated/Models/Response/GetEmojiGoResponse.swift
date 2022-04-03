//
//  GetEmojiGoResponse.swift
//  Elated
//
//  Created by Marlon on 9/3/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import SwiftyJSON

struct GetEmojiGoInvitesResponse: BaseResponse, Pagination {
    
    var count: Int = 0
    
    var next: Int?
    
    var previous: Int?
    
    var total_pages: Int = 0
    
    var msg: String?

    var time: Int?
    
    var code: Int?
    
    var success: Bool?
        
    var datails = [EmojiGoGameDetail]()
        
    init(_ json: JSON) {
        baseInit(json)
        pageInit(json)
        datails = (json["data"].array ?? []).map { EmojiGoGameDetail($0) }
    }
    
}


struct GetEmojiGoResponse: BaseResponse {
    
    var msg: String?

    var time: Int?
    
    var code: Int?
    
    var success: Bool?
            
    var emojiGo: EmojiGoGameDetail?
    
    init(_ json: JSON) {
        baseInit(json)
        emojiGo = EmojiGoGameDetail(json["data"])
    }
    
}
