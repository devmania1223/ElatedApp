//
//  SparkFlirtNoticeViewModel.swift
//  Elated
//
//  Created by Marlon on 5/15/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import RxSwift
import RxCocoa

class SparkFlirtNoticeViewModel: BaseViewModel {
    
    //MARK: - Properties
    
    let messageText = BehaviorRelay<String>(value: "common.success".localized)
    var buttonText = BehaviorRelay<String>(value: "common.continue".localized)
    var titleText = BehaviorRelay<String?>(value: nil)
    var balanceText = BehaviorRelay<String?>(value: nil)

    let success = PublishRelay<Void>()
}
