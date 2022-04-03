//
//  ForgotPasswordViewModel.swift
//  Elated
//
//  Created by Yiel Miranda on 3/18/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Moya
import SwiftyJSON

class ForgotPasswordViewModel: BaseViewModel {
    
    //MARK: - Properties
    
    var emailText = BehaviorRelay<String>(value: .empty)
    let hideErrorBubble = BehaviorRelay<Bool>(value: true)
    
    var onEmailValueChanged: Observable<Bool> {
        return emailText.map({ $0.isEmail })
    }
    
    let success = PublishRelay<Void>()
    
    //MARK: - Custom
    
    func forgotPassword() {
        manageActivityIndicator.accept(true)
        let email = emailText.value
        ApiProvider.shared.request(UserServices.sendResetPasswordLink(email: email))
            .subscribe(onSuccess: { [weak self] res in
            self?.manageActivityIndicator.accept(false)
            self?.success.accept(())
        }, onError: { [weak self] err in
            self?.manageActivityIndicator.accept(false)
            self?.hideErrorBubble.accept(false)
            #if DEBUG
            print(err)
            #endif
        }).disposed(by: self.disposeBag)
    }
}
