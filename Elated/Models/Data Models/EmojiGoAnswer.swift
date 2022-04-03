//
//  EmojiGoAnswer.swift
//  Elated
//
//  Created by Marlon on 9/3/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import SwiftyJSON

struct EmojiGoAnswer {
    
    var user: Int?
    var answer: String?
    
    init(_ json: JSON) {
        user = json["user"].intValue
        answer = json["text"].stringValue
    }
    
}
