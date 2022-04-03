//
//  TooltipInfo.swift
//  Elated
//
//  Created by Rey Felipe on 7/16/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import AMPopTip

struct TooltipInfo {
    let tipId: Tooltip
    let direction: PopTipDirection
    let parentView: UIView
    let maxWidth: CGFloat
    let inView: UIView
    let fromRect: CGRect
    let offset: CGFloat
    let duration: TimeInterval
}

extension TooltipInfo: Equatable {
    static func == (lhs: TooltipInfo, rhs: TooltipInfo) -> Bool {
        return lhs.tipId == rhs.tipId
    }
}
