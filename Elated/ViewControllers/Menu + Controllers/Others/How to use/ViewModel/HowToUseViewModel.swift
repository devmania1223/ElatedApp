//
//  HowToUseViewModel.swift
//  Elated
//
//  Created by Marlon on 2021/3/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import RxSwift
import RxCocoa

class HowToUseViewModel: BaseViewModel {

    enum Tutorial: Int {
        
        case thisOrThat
        case sparkFlirt
        case basho
        case storyShare
        case emojiGo
        
        func getTitle() -> String {
            switch self {
            case .thisOrThat:
                return "howToUse.thisOrThat".localized
            case .sparkFlirt:
                return "howToUse.sparkFlirt".localized
            case .basho:
                return "howToUse.basho".localized
            case .storyShare:
                return "howToUse.storyShare".localized
            case .emojiGo:
                return "howToUse.emoji".localized
            }
        }
        
        func getIcon() -> UIImage {
            switch self {
            case .thisOrThat:
                return #imageLiteral(resourceName: "icons-thisorthat-active")
            case .sparkFlirt:
                return #imageLiteral(resourceName: "icons-sparkflirt-active")
            case .basho:
                return #imageLiteral(resourceName: "icon-basho-purple")
            case .storyShare:
                return #imageLiteral(resourceName: "icon-storyshare-purple")
            case .emojiGo:
                return #imageLiteral(resourceName: "icon-list-emojigo")
            }
        }
        
    }
    
}
