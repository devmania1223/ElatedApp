//
//  BashoGameCompletedViewModel.swift
//  Elated
//
//  Created by Marlon on 12/23/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BashoGameCompletedViewModel: BaseViewModel {

    let detail = BehaviorRelay<BashoGameDetail?>(value: nil)
    
    override init() {
        super.init()
    }
    
}
