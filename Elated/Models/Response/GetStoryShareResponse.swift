//
//  GetStoryShareResponse.swift
//  Elated
//
//  Created by Marlon on 10/9/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import SwiftyJSON

struct GetStoryShareInvitesResponse: BaseResponse, Pagination {
    
    var count: Int = 0
    
    var next: Int?
    
    var previous: Int?
    
    var total_pages: Int = 0
    
    var msg: String?

    var time: Int?
    
    var code: Int?
    
    var success: Bool?
        
    var datails = [StoryShareGameDetail]()
        
    init(_ json: JSON) {
        baseInit(json)
        pageInit(json)
        datails = (json["data"].array ?? []).map { StoryShareGameDetail($0) }
    }
    
}


struct GetStoryShareResponse: BaseResponse {
    
    var msg: String?

    var time: Int?
    
    var code: Int?
    
    var success: Bool?
            
    var storyShare: StoryShareGameDetail?
    
    init(_ json: JSON) {
        baseInit(json)
        storyShare = StoryShareGameDetail(json["data"])
    }
    
}
