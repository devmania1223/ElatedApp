//
//  LineTabView+Extensions.swift
//  Elated
//
//  Created by Marlon on 2021/3/9.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

extension LineTabView {

    static func createCommonTabView(_ title: String, selected: Bool = false) -> LineTabView {
        return LineTabView(title.localized,
                           normalColor: .silver,
                           activeColor: .elatedPrimaryPurple,
                           font: .futuraMedium(12),
                           selected: selected)
    }
    
}
