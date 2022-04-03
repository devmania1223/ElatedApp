//
//  SuccessViewModel.swift
//  Elated
//
//  Created by Yiel Miranda on 3/26/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import RxSwift
import RxCocoa

class SuccessViewModel: BaseViewModel {
    
    //MARK: - Properties
    
    let messageText = BehaviorRelay<String>(value: "common.success".localized)
    var buttonText = BehaviorRelay<String>(value: "common.continue".localized)
    
    let success = PublishRelay<Void>()
    
    //MARK: - Custom
    
    func setTexts(message: String, button: String) {
        messageText.accept(message)
        buttonText.accept(button)
    }
}

