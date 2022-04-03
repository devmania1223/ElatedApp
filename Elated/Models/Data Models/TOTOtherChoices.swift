//
//  ThisOrThatOtherChoices.swift
//  Elated
//
//  Created by John Lester Celis on 4/12/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

struct TOTOtherChoices {
    var totChoices: [String] = []
    var totOtherChoice = [TOTOtherChoices]()

    init(_ json: JSON) {
        if let arrChoices = json.array {
            totChoices = arrChoices.map { $0["text"].stringValue }
            totOtherChoice = arrChoices.map { TOTOtherChoices($0["subset"]) }
        }
    }
}
