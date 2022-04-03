//
//  MDL_Bubbles.swift
//  Elated
//
//  Created by admin on 5/29/20.
//  Copyright © 2020 elatedteam. All rights reserved.
//

import UIKit

struct MDL_Bubbles {
    
    struct TriggerOptions: OptionSet {
        let rawValue: Int

        static let flick  = TriggerOptions(rawValue: 1 << 0)
        static let tap = TriggerOptions(rawValue: 1 << 1)
        static let hold  = TriggerOptions(rawValue: 1 << 2)
    }
    
    var identifier: String
    var text: String
    var bubbles: [MDL_Bubble]
    var triggers: [TriggerOptions]
    
    init(identifier: String, text: String, bubbles: [MDL_Bubble], triggers: [TriggerOptions] = [.flick, .tap, .hold]) {
        self.identifier = identifier
        self.text = text
        self.bubbles = bubbles
        self.triggers = triggers
    }

}
