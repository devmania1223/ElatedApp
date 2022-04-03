//
//  EmojiGoQuestion.swift
//  Elated
//
//  Created by Marlon on 9/3/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import SwiftyJSON

struct EmojiGoQuestion {
    
    var id: Int?
    var question: String?
    var categories = [String]()

    //for emojiGo object only
    var user: Int?

    init(_ json: JSON) {
        id = json["id"].intValue
        question = json["text"].stringValue
        categories = json["questions"].arrayValue.map { "\($0)" }
        
        //for emojiGo object only
        user = json["user"].intValue
    }
    
}
