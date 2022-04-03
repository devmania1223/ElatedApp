//
//  SparkFlirtInviteNoticeViewModel.swift
//  Elated
//
//  Created by Marlon on 5/15/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import RxSwift
import RxCocoa

class SparkFlirtInviteNoticeViewModel: BaseViewModel {
    
    //MARK: - Properties
    var titleText = BehaviorRelay<String?>(value: nil)
    var nameText = BehaviorRelay<String?>(value: nil)
    var buttonText = BehaviorRelay<String>(value: "common.continue".localized)

    let success = PublishRelay<Void>()

}
