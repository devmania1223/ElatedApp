//
//  BashoWordDefinition.swift
//  Elated
//
//  Created by Marlon on 8/18/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import SwiftyJSON

struct BashoWordDefinition {
    
    var word: String?
    var definitions = [Definition]()
    
    init(_ json: JSON) {
        word = json["word"].stringValue
        definitions = json["definitions"].arrayValue.map { Definition($0) }
    }
    
}

struct Definition {
    
    var definition: String?
    var partOfSpeech: String?
    
    init(_ json: JSON) {
        definition = json["definition"].stringValue
        partOfSpeech = json["partOfSpeech"].stringValue
    }
    
}
