//
//  BashoWordSyllables.swift
//  Elated
//
//  Created by Marlon on 8/18/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import SwiftyJSON

struct BashoWordSyllables {
    
    var word: String?
    var syllables: Syllables?
    
    init(_ json: JSON) {
        word = json["word"].stringValue
        syllables = Syllables(json["syllables"])
    }
    
}

struct Syllables {
    
    var count: Int = 0
    var list = [String]()
    
    init(_ json: JSON) {
        count = json["count"].intValue
        list = json["list"].arrayValue.map { "\($0)" }
    }
    
}
