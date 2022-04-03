//
//  SparkFlirtChatViewModel.swift
//  Elated
//
//  Created by Marlon on 10/28/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SparkFlirtChatViewModel: BaseViewModel {

    var roomID: String? = nil
    let otherUserDetail = BehaviorRelay<UserInfoShort?>(value: nil)

}
