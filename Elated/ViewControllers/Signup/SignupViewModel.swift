//
//  SignupViewModel.swift
//  Elated
//
//  Created by Marlon on 2021/2/27.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import RxSwift
import RxCocoa
import SwiftyJSON
import Moya

class SignupViewModel: BaseViewModel {
    
    let email = BehaviorRelay<String>(value: "")
    let confirmEmail = BehaviorRelay<String>(value: "")
    let password = BehaviorRelay<String>(value: "")
    let confirmPassword = BehaviorRelay<String>(value: "")
    
    let emailBorderWidth = BehaviorRelay<CGFloat>(value: 0.25)
    let confirmEmailBorderWidth = BehaviorRelay<CGFloat>(value: 0.25)
    let passwordBorderWidth = BehaviorRelay<CGFloat>(value: 0.25)
    let confirmPasswordBorderWidth = BehaviorRelay<CGFloat>(value: 0.25)

    let emailTint = BehaviorRelay<UIColor>(value: .silver)
    let confirmEmailTint = BehaviorRelay<UIColor>(value: .silver)
    let passwordTint = BehaviorRelay<UIColor>(value: .silver)
    let confirmPasswordTint = BehaviorRelay<UIColor>(value: .silver)
    
    let confirmEmailValid = BehaviorRelay<Bool?>(value: nil)
    let hideEmailBubble = BehaviorRelay<Bool>(value: true)
    let hidePasswordBubble = BehaviorRelay<Bool>(value: true)
    let hideConfirmPasswordBubble = BehaviorRelay<Bool>(value: true)
    let hideConfirmEmaildBubble = BehaviorRelay<Bool>(value: false)

    let allowSignUp = BehaviorRelay<Bool>(value: false)
    let registered = PublishRelay<Void>()
    

    override init() {
        super.init()
        
        Observable.combineLatest(email, confirmEmail, password, confirmPassword)
            .subscribe(onNext: { [weak self] email, confirmEmail, password, confirmPassword in
                guard let self = self else { return }
                
                //email
                let emailValid = email.isEmail
                self.emailBorderWidth.accept(email.isEmpty ? 0.25 : 1.5)
                self.emailTint.accept(email.isEmpty ? .silver : email.isEmail ?.elatedPrimaryPurple : .danger)
                self.hideEmailBubble.accept(true)
                
                //confirm email
                let confirmValid = emailValid && (self.email.value == confirmEmail)
                self.confirmEmailBorderWidth.accept(confirmEmail.isEmpty ? 0.25 : 1.5)
                self.confirmEmailValid.accept(confirmEmail.isEmpty ? nil : confirmValid)
                self.confirmEmailTint.accept(confirmEmail.isEmpty
                                                ? .silver
                                                : confirmValid
                                                ? .elatedPrimaryPurple
                                                : .danger)
                self.hideConfirmEmaildBubble.accept(confirmEmail.isEmpty ? true : confirmValid)

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
                let confirmPasswordValid = (!self.password.value.isEmpty) && (self.password.value == confirmPassword)
                self.confirmPasswordBorderWidth.accept(confirmPassword.isEmpty ? 0.25 : 1.5)
                self.hideConfirmPasswordBubble.accept((passwordValid && confirmPasswordValid)
                                                        || confirmPassword.isEmpty
                                                        || (!password.isEmpty && !passwordValid))
                self.confirmPasswordTint.accept(confirmPassword.isEmpty ? .silver : confirmPasswordValid ? .elatedPrimaryPurple : .danger)
                
                //allow signup
                self.allowSignUp.accept(emailValid && confirmValid && passwordValid && confirmPasswordValid)
                
            }).disposed(by: self.disposeBag)
        
    }
    
    func signup() {
        
        self.manageActivityIndicator.accept(true)
        ApiProvider.shared.request(AuthService.signup(email: email.value,
                                                       password: password.value))
            .subscribe(onSuccess: { [weak self] res in
            self?.manageActivityIndicator.accept(false)
            self?.registered.accept(())
        }, onError: { [weak self] err in
            //handle all errors here
            self?.manageActivityIndicator.accept(false)
            let json = JSON((err as? MoyaError)?.response?.data as Any)
            #if DEBUG
            print(err)
            #endif
            if let code = BasicResponse(json).code {
                if code == 100003 {
                    self?.emailTint.accept(.danger)
                    self?.hideEmailBubble.accept(false)
                    return
                }
                let message = LanguageManager.shared.errorMessage(for: code)
                //present alert triggers binding on the view controller, make sure its handled
                self?.presentAlert.accept(("", message))
            }
        }).disposed(by: self.disposeBag)
        
    }
    
}
