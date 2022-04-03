//
//  MobileOTPViewModel.swift
//  Elated
//
//  Created by Marlon on 5/13/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON
import Moya

class MobileOTPViewModel: BaseViewModel {
    
    let phoneNumber = BehaviorRelay<String?>(value: nil)
    let success = PublishRelay<Void>()

    override init() {
        super.init()
    }
    
    func sendOTP() {
        if let number = phoneNumber.value {
            self.manageActivityIndicator.accept(true)
            ApiProvider.shared.request(SMSService.otp(number: number))
                .subscribe(onSuccess: { [weak self] res in
                    self?.manageActivityIndicator.accept(false)
                    self?.success.accept(())
            }, onError: { [weak self] err in
                self?.manageActivityIndicator.accept(false)
                #if DEBUG
                print(err)
                #endif
                let json = JSON((err as? MoyaError)?.response?.data as Any)
                if let code = BasicResponse(json).code {
                    let message = LanguageManager.shared.errorMessage(for: code)
                    self?.presentAlert.accept(("", message))
                }
            }).disposed(by: self.disposeBag)
        }
    }
    
}
