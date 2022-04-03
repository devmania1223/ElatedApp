//
//  Tooltip.swift
//  Elated
//
//  Created by Rey Felipe on 7/16/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation

enum Tooltip: String, CaseIterable {
    
    case profileEdit
    case profilePreviewEdit
    case sparkFlirtAcceptInvite
    case sparkFlirtAddMoreCredits
    case sparkFlirtAddToFavorites
    case sparkFlirtCancelInvite
    case sparkFlirtPullDownRelease
    case sparkFlirtSendNudge
    case totInstructionReminder
    case totInstructionShuffle
    
    var text: String {
        switch self {
        case .profileEdit, .profilePreviewEdit:
            return "tooltip.profile.edit".localized
        case .sparkFlirtAcceptInvite:
            return "tooltip.sparkflirt.accept.invite".localized
        case .sparkFlirtAddMoreCredits:
            return "tooltip.sparkflirt.add.more".localized
        case .sparkFlirtAddToFavorites:
            return "tooltip.sparkflirt.add.favorites".localized
        case .sparkFlirtCancelInvite:
            return "tooltip.spartflirt.cancel.invite".localized
        case .sparkFlirtPullDownRelease:
            return "tooltip.sparkflirt.pulldown.release".localized
        case .sparkFlirtSendNudge:
            return "tooltip.sparkflirt.send.nudge".localized
        case .totInstructionReminder:
            return "tooltip.tot.instruction.reminder".localized
        case .totInstructionShuffle:
            return "tooltip.tot.instruction.shuffle".localized
        }
    }
    var key: String {
        return self.rawValue
    }
}
