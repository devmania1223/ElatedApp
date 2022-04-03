//
//  SignupEmailSupplyViewModel.swift
//  Elated
//
//  Created by Marlon on 6/18/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON
import Moya

class SignupEmailSupplyViewModel: BaseViewModel {

    let token = BehaviorRelay<String?>(value: nil)
    let type = BehaviorRelay<ThirdPartyAuthType?>(value: nil)
    let socialMediaID = BehaviorRelay<String?>(value: nil)

    let email = BehaviorRelay<String>(value: "")
    let confirmEmail = BehaviorRelay<String>(value: "")
    
    let emailBorderWidth = BehaviorRelay<CGFloat>(value: 0.25)
    let confirmEmailBorderWidth = BehaviorRelay<CGFloat>(value: 0.25)
    
    let emailTint = BehaviorRelay<UIColor>(value: .silver)
    let confirmEmailTint = BehaviorRelay<UIColor>(value: .silver)

    let confirmEmailValid = BehaviorRelay<Bool?>(value: nil)

    let allowSignUp = BehaviorRelay<Bool>(value: false)
    let registered = PublishRelay<Void>()

    override init() {
        super.init()
        
        Observable.combineLatest(email, confirmEmail)
            .subscribe(onNext: { [weak self] email, confirmEmail in
                guard let self = self else { return }
                
                //email
                let emailValid = email.isEmail
                self.emailBorderWidth.accept(email.isEmpty ? 0.25 : 1.5)
                self.emailTint.accept(email.isEmpty ? .silver : email.isEmail ?.elatedPrimaryPurple : .danger)
                
                //confirm email
                let confirmValid = emailValid && (self.email.value == confirmEmail)
                self.confirmEmailBorderWidth.accept(confirmEmail.isEmpty ? 0.25 : 1.5)
                self.confirmEmailValid.accept(confirmEmail.isEmpty ? nil : confirmValid)
                self.confirmEmailTint.accept(confirmEmail.isEmpty
                                                ? .silver
                                                : confirmValid
                                                ? .elatedPrimaryPurple
                                                : .danger)
                
                //allow signup
                self.allowSignUp.accept(emailValid && confirmValid)
                
            }).disposed(by: self.disposeBag)
        
    }
    
    func register() {
        guard let token = token.value,
              let type = type.value,
              let id = socialMediaID.value else {
            return
        }
        self.manageActivityIndicator.accept(true)
        ApiProvider.shared.request(ThirdPartyAuthRegister.register(token: token,
                                                                   email: email.value,
                                                                   type: type,
                                                                   socialMediaID: id))
            .subscribe(onSuccess: { [weak self] res in
            self?.manageActivityIndicator.accept(false)
            self?.registered.accept(())
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
