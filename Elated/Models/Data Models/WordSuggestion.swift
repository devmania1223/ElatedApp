//
//  WordSuggestion.swift
//  Elated
//
//  Created by Marlon on 8/6/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

import Foundation
import SwiftyJSON
import UIKit

struct WordSuggestion {
    
    var id: Int?
    var word: String = ""
    var itemIndex: Int?
    var syllables: Int?
    var syllablesOutOfBounce = false
    
//    init(_ json: JSON) {
//        id = json["id"].int
//        word = json["word"].stringValue
//    }
//
    init(id: Int, word: String) {
        self.id = id
        self.word = word
    }
    
}
