//
//  MenuPageViewModel.swift
//  Elated
//
//  Created by Marlon on 2021/3/6.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class MenuPageViewModel: BaseViewModel {
    
    let viewUserId = BehaviorRelay<Int?>(value: nil)
    let selectedTabIndex = BehaviorRelay<Int?>(value: nil)
    let previousTabIndex = BehaviorRelay<Int>(value: 0)

}
