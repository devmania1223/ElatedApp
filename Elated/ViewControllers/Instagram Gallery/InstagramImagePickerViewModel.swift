//
//  InstagramImagePickerViewModel.swift
//  Elated
//
//  Created by Marlon on 6/3/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON

class InstagramImagePickerViewModel: BaseViewModel {
    
    let data = BehaviorRelay<[InstagramMedia]>(value: [])
    
    override init() {
        super.init()
    }
    
    func getMedia() {
        self.manageActivityIndicator.accept(true)
        ApiProvider.shared.request(InstagramAuthService.getMedia)
            .subscribe(onSuccess: { [weak self] res in
                let response = GetInstagramMediaResponse(JSON(res))
                self?.data.accept(response.data)
                self?.manageActivityIndicator.accept(false)
        }, onError: { [weak self] err in
            self?.manageActivityIndicator.accept(false)
            self?.presentAlert.accept(("common.error".localized,
                                       "common.error.somethingWentWrong".localized))
        }).disposed(by: self.disposeBag)
    }
    
}

