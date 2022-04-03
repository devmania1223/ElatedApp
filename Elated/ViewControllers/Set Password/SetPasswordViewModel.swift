//
//  SetPasswordViewModel.swift
//  Elated
//
//  Created by Marlon on 7/12/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON
import Moya

class SetPasswordViewModel: BaseViewModel {

    let uid = BehaviorRelay<String>(value: "")
    let token = BehaviorRelay<String>(value: "")

    let password = BehaviorRelay<String>(value: "")
    let confirmPassword = BehaviorRelay<String>(value: "")
    
    let passwordBorderWidth = BehaviorRelay<CGFloat>(value: 0.25)
    let confirmPasswordBorderWidth = BehaviorRelay<CGFloat>(value: 0.25)

    let passwordTint = BehaviorRelay<UIColor>(value: .silver)
    let confirmPasswordTint = BehaviorRelay<UIColor>(value: .silver)
    
    let hidePasswordBubble = BehaviorRelay<Bool>(value: true)
    let hideConfirmPasswordBubble = BehaviorRelay<Bool>(value: true)

    let allowSetPassword = BehaviorRelay<Bool>(value: false)
    let success = PublishRelay<Void>()

    override init() {
        super.init()
        
        Observable.combineLatest(password, confirmPassword)
            .subscribe(onNext: { [weak self] password, confirmPassword in
                guard let self = self else { return }
                
                /* Password Rules:
                    - 8 chars alphanumeric
                    - contains upper and lowercased
                    - 1 number, 1 special chars
                 */
                self.passwordBorderWidth.accept(password.isEmpty ? 0.25 : 1.5)
                let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,}"
                let passwordValid = NSPredicate(format:"SELF MATCHES %@", regex).evaluate(with: password)
                self.hidePasswordBubble.accept(password.isEmpty || passwordValid)
                self.passwordTint.accept(password.isEmpty ? .silver : .elatedPrimaryPurple)
                
                //confirm password
                let confirmPasswordValid = !self.password.value.isEmpty && self.password.value == confirmPassword
                self.confirmPasswordBorderWidth.accept(confirmPassword.isEmpty ? 0.25 : 1.5)
                self.hideConfirmPasswordBubble.accept((passwordValid && confirmPasswordValid)
                                                        || confirmPassword.isEmpty
                                                        || (!password.isEmpty && !passwordValid))
                self.confirmPasswordTint.accept(confirmPassword.isEmpty ? .silver : confirmPasswordValid ? .elatedPrimaryPurple : .danger)
                
                //allow signup
                self.allowSetPassword.accept(passwordValid && confirmPasswordValid)
                
            }).disposed(by: self.disposeBag)
        
    }
    
    func setPassword() {
        self.manageActivityIndicator.accept(true)
        ApiProvider.shared.request(UserServices.setPassword(uid:  uid.value,
                                                            token: token.value,
                                                            newPassword: password.value))
            .subscribe(onSuccess: { [weak self] res in
            self?.manageActivityIndicator.accept(false)
            self?.success.accept(())
        }, onError: { [weak self] err in
            //handle all errors here
            self?.manageActivityIndicator.accept(false)
            #if DEBUG
            print(err)
            #endif
            self?.presentAlert.accept(("common.error".localized,
                                       "common.error.somethingWentWrong".localized))
        }).disposed(by: self.disposeBag)
        
    }

    
}
