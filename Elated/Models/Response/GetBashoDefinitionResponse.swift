//
//  GetBashoDefinitionResponse.swift
//  Elated
//
//  Created by Marlon on 8/19/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import SwiftyJSON

struct GetBashoDefinitionResponse: BaseResponse {
    
    var msg: String?

    var time: Int?
    
    var code: Int?
    
    var success: Bool?
        
    var definition: BashoWordDefinition?
    
    init(_ json: JSON) {
        baseInit(json)
        definition = BashoWordDefinition(json["data"])
    }
    
}
