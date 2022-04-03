//
//  InstagramAuthViewModel.swift
//  Elated
//
//  Created by Marlon on 6/2/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import RxSwift
import RxCocoa
import SwiftyJSON

class InstagramAuthViewModel: BaseViewModel {

    let code = BehaviorRelay<String?>(value: nil)
    let success = PublishRelay<Bool>()

    override init() {
        super.init()
        
        code.subscribe(onNext: { [weak self] code in
            if code != nil {
                self?.getToken()
            }
        }).disposed(by: disposeBag)
        
    }

    private func getToken() {
        guard let code = code.value else { return }
        self.manageActivityIndicator.accept(true)
        ApiProvider.shared.request(InstagramAuthService.accessToken(code: code))
            .subscribe(onSuccess: { [weak self] res in
                self?.manageActivityIndicator.accept(false)
                self?.success.accept(true)
        }, onError: { [weak self] err in
            self?.manageActivityIndicator.accept(false)
            self?.success.accept(false)
        }).disposed(by: self.disposeBag)
    }

}
