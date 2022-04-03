//
//  ThisOrThat.swift
//  Elated
//
//  Created by John Lester Celis on 4/8/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

struct ThisOrThat {
    var question: String?
    var totChoices: [String] = []
    var totOtherChoice = [TOTOtherChoices]()
    
    init(_ json: JSON) {
        question = json["text"].stringValue
        if let arrChoices = json["choices"].array {
            totChoices = arrChoices.map { $0["text"].stringValue }
            totOtherChoice = arrChoices.map { TOTOtherChoices($0["subset"]) }
        }
    }
}
