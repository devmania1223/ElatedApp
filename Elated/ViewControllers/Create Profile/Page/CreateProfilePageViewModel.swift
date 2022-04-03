//
//  CreateProfilePageViewModel.swift
//  Elated
//
//  Created by Marlon on 6/7/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON

class CreateProfilePageViewModel: BaseViewModel {

    let addBooks = BehaviorRelay<Bool>(value: true)
    let addMusic = BehaviorRelay<Bool>(value: true)
    let nextPage = PublishRelay<Void>()

    
    
}
