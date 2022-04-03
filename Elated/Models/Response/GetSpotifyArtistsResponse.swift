//
//  SpotifyArtistsResponse.swift
//  Elated
//
//  Created by Marlon on 7/8/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import SwiftyJSON

struct GetSpotifyArtistsResponse: BaseResponse {
    
    var msg: String?
    
    var time: Int?
    
    var code: Int?

    var success: Bool?
    
    var data = [SpotifyArtist]()
    
    init(_ json: JSON) {
        baseInit(json)
        data = json["data"]["artists"]["items"].arrayValue.map { SpotifyArtist($0) }
    }
    
}


