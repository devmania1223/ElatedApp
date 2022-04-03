//
//  ThisOrThatViewModel.swift
//  Elated
//
//  Created by John Lester Celis on 4/7/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import RxSwift
import RxCocoa
import SwiftyJSON
import Moya


class ThisOrThatViewModel: BaseViewModel {
    let totData = PublishRelay<[ThisOrThat]>()

    override init() {
        super.init()
    }
    
    func getThisOrThatQuestions() {
        self.manageActivityIndicator.accept(true)
        ApiProvider.shared.request(ThisOrThatService.getQuestions(page: 1)).subscribe(onSuccess: { [weak self] res in
            self?.manageActivityIndicator.accept(false)
            let list = ThisOrThatResponse(JSON(res))
            //self?.totData.accept(list.thisorthat)
            
        }, onError: { [weak self] err in
            self?.manageActivityIndicator.accept(false)
            let json = JSON((err as? MoyaError)?.response?.data as Any)
            #if DEBUG
            print(err)
            #endif
            if let code = BasicResponse(json).code {
                let message = LanguageManager.shared.errorMessage(for: code)
                //present alert triggers binding on the view controller, make sure its handled
                self?.presentAlert.accept(("", message))
            }
        }).disposed(by: self.disposeBag)
    }
}
