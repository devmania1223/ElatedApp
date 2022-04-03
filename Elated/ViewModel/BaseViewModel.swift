//
//  BaseViewModel.swift
//  Elated
//
//  Created by Marlon on 2021/2/20.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import RxSwift
import RxCocoa

class BaseViewModel {

    let disposeBag = DisposeBag()

    //title message
    let presentAlert = PublishRelay<(String,String)>()
    
    //title message, flag
    let presentAlertWithAction = PublishRelay<(String, String, Int)>()
    
    //something went wrong
    let presentRetry = PublishRelay<Void>()
    
    //title, message, button titles, highlited button, flag
    let presentRetryWithOption = PublishRelay<(String, String, [String], Int?, Int?)>()

    //use to present activity indicator
    let manageActivityIndicator = PublishRelay<Bool>()
    
    init() {}
    
}
