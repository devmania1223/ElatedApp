//
//  SignupConfirmationViewModel.swift
//  Elated
//
//  Created by Marlon on 5/11/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON
import Moya

class SignupConfirmationViewModel: BaseViewModel {

    let code = BehaviorRelay<String?>(value: nil)
    let email = BehaviorRelay<String?>(value: nil)
    let confirmed = PublishRelay<Void>()
    let resent = PublishRelay<Void>()
    let hideConfirmationCodeBubble = BehaviorRelay<Bool>(value: true)
    
    var countDown = 300

    override init() {
        super.init()
    }
    
    func verifyEmail() {
        if let code = code.value, let email = email.value {
            self.manageActivityIndicator.accept(true)
            ApiProvider.shared.request(AuthService.otpEmailVerify(code: code, email: email))
                .subscribe(onSuccess: { [weak self] res in
                    self?.manageActivityIndicator.accept(false)
                    let response = ConfirmEmailResponse(JSON(res))
                    if response.success == true,
                       let user = response.user {
                        self?.confirmed.accept(())
                        MemCached.shared.userInfo = user
                        if let token = response.token {
                            UserDefaults.standard.token = token
                        }
                    }
            }, onError: { [weak self] err in
                self?.manageActivityIndicator.accept(false)
                #if DEBUG
                print(err)
                #endif
                let json = JSON((err as? MoyaError)?.response?.data as Any)
                if let code = BasicResponse(json).code {
                    if code == 100007 {
                        self?.hideConfirmationCodeBubble.accept(false)
                        return
                    }
                    let message = LanguageManager.shared.errorMessage(for: code)
                    self?.presentAlert.accept(("", message))
                }
            }).disposed(by: self.disposeBag)
        }
    }
    
    func resendOTPEmail() {
        
        if let email = email.value {
            self.manageActivityIndicator.accept(true)
            ApiProvider.shared.request(AuthService.otpResendEmail(email: email))
                .subscribe(onSuccess: { [weak self] res in
                    self?.manageActivityIndicator.accept(false)
                    let baseResponse = BasicResponse(JSON(res))
                    if baseResponse.success == true {
                        self?.presentAlert.accept(("", "signup.confirmation.code.resent".localized))
                        self?.resent.accept(())
                    }
            }, onError: { [weak self]  err in
                self?.manageActivityIndicator.accept(false)
                #if DEBUG
                print(err)
                #endif
                let json = JSON((err as? MoyaError)?.response?.data as Any)
                if let code = BasicResponse(json).code {
                    let message = LanguageManager.shared.errorMessage(for: code)
                    //present alert triggers binding on the view controller, make sure its handled
                    self?.presentAlert.accept(("", message))
                }
            }).disposed(by: self.disposeBag)
            
        }
    }
    
}
