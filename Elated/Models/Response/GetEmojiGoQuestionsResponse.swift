//
//  GetEmojiGoQuestionsResponse.swift
//  Elated
//
//  Created by Marlon on 9/3/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import SwiftyJSON

struct GetEmojiGoQuestionsResponse: BaseResponse {
    
    var count: Int = 0
    
    var msg: String?

    var time: Int?
    
    var code: Int?
    
    var success: Bool?
        
    var questions = [EmojiGoQuestion]()
        
    init(_ json: JSON) {
        baseInit(json)
        questions = json["data"].arrayValue.map { EmojiGoQuestion($0) }
    }
    
}
