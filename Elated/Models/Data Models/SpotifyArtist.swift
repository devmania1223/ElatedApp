//
//  SpotifyArtist.swift
//  Elated
//
//  Created by Marlon on 7/8/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import SwiftyJSON

struct SpotifyArtist {
    
    var id: String?
    var name: String?
    var popularity: String?
    var uri: URL?
    var images = [SpotifyArtistImage]()

    init(_ json: JSON) {
        id = json["id"].stringValue
        name = json["name"].stringValue
        popularity = json["popularity"].stringValue
        uri = json["uri"].url
        images = json["images"].arrayValue.map { SpotifyArtistImage($0) }
    }
    
}

struct SpotifyArtistImage {
    
    var height: Int = 0
    var url: URL?
    var width: Int = 0

    init(_ json: JSON) {
        height = json["height"].intValue
        url = json["url"].url
        width = json["width"].intValue
    }
    
}
