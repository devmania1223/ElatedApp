//
//  InstagramMediaPage.swift
//  Elated
//
//  Created by Marlon on 6/3/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import SwiftyJSON

struct InstagramMediaPagination {
    
    var before: String?
    var after: String?

    init(_ json: JSON) {
        before = json["before"].stringValue
        after = json["after"].stringValue
    }
    
}
