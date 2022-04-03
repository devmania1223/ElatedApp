//
//  GetBashoSyllablesResponse.swift
//  Elated
//
//  Created by Marlon on 8/19/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import SwiftyJSON

struct GetBashoSyllablesResponse: BaseResponse {
    
    var msg: String?

    var time: Int?
    
    var code: Int?
    
    var success: Bool?
        
    var syllable: BashoWordSyllables?
    
    init(_ json: JSON) {
        baseInit(json)
        syllable = BashoWordSyllables(json["data"])
    }
    
}
