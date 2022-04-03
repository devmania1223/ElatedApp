//
//  CommonDataModel.swift
//  Elated
//
//  Created by Marlon on 3/29/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

struct CommonDataModel {
    var image: UIImage?
    var title: String = ""
    var background: UIColor?
    
    init(_ image: UIImage?, title: String, background: UIColor? = nil) {
        self.image = image
        self.title = title
        self.background = background
    }
}
