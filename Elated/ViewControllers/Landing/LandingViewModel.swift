//
//  LandingViewModel.swift
//  Elated
//
//  Created by Marlon on 2021/2/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import SwiftyJSON
import RxSwift
import RxCocoa
import Moya
import FBSDKCoreKit
import FBSDKLoginKit

class LandingViewModel: BaseViewModel {

    typealias Token = String
    typealias SocialMediaID = String
    
    let user = BehaviorRelay<UserInfo?>(value: nil)
    let supplyEmail = PublishRelay<(ThirdPartyAuthType, SocialMediaID, Token)>()

    override init() {
        super.init()
    }
    
    func signupFacebook(token: String, id: String) {
        self.manageActivityIndicator.accept(true)
        ApiProvider.shared.request(FacebookAuthService.register(token: token))
            .subscribe(onSuccess: { [weak self] res in
                let response = SigninResponse(JSON(res))
                self?.manageActivityIndicator.accept(false)
                self?.user.accept(response.user)
                UserDefaults.standard.token = response.token ?? ""
                MemCached.shared.userInfo = response.user
        }, onError: { [weak self] err in
            self?.manageActivityIndicator.accept(false)
            let json = JSON((err as? MoyaError)?.response?.data as Any)
            #if DEBUG
            print(err)
            #endif
            let response = BasicResponse(json)
            if let code = response.code {
                if code == ApiCodeResponse.emailDoesNotExists.rawValue {
                    self?.supplyEmail.accept((.facebook, token, id))
                } else {
                    let message = LanguageManager.shared.errorMessage(for: code)
                    self?.presentAlert.accept(("", message))
                }
            }
        }).disposed(by: self.disposeBag)
    }
    
    func signupApple(token: String,
                     code: String,
                     user: String,
                     fname: String?,
                     lname: String?) {
        self.manageActivityIndicator.accept(true)
        ApiProvider.shared.request(AppleAuthService.register(token: token, code: code, fname: fname, lname: lname))
                .subscribe(onSuccess: { [weak self] res in
                    let response = SigninResponse(JSON(res))
                    self?.manageActivityIndicator.accept(false)
                    self?.user.accept(response.user)
                    UserDefaults.standard.token = response.token ?? ""
                    MemCached.shared.userInfo = response.user
            }, onError: { [weak self] err in
                self?.manageActivityIndicator.accept(false)
                let json = JSON((err as? MoyaError)?.response?.data as Any)
                #if DEBUG
                print(err)
                #endif
                let response = BasicResponse(json)
                if let code = response.code {
                    if code == ApiCodeResponse.emailDoesNotExists.rawValue {
                        self?.supplyEmail.accept((.apple, token, user))
                    } else {
                        let message = LanguageManager.shared.errorMessage(for: code)
                        self?.presentAlert.accept(("", message))
                    }
                }
            }).disposed(by: self.disposeBag)
    }

    func signupGoogle(token: String, id: String) {
        self.manageActivityIndicator.accept(true)
        ApiProvider.shared.request(GoogleAuthService.register(token: token))
                .subscribe(onSuccess: { [weak self] res in
                    let response = SigninResponse(JSON(res))
                    self?.manageActivityIndicator.accept(false)
                    self?.user.accept(response.user)
                    UserDefaults.standard.token = response.token ?? ""
                    MemCached.shared.userInfo = response.user
            }, onError: { [weak self] err in
                self?.manageActivityIndicator.accept(false)
                let json = JSON((err as? MoyaError)?.response?.data as Any)
                #if DEBUG
                print(err)
                #endif
                let response = BasicResponse(json)
                if let code = response.code {
                    if code == ApiCodeResponse.emailDoesNotExists.rawValue {
                        self?.supplyEmail.accept((.google, token, id))
                    } else {
                        let message = LanguageManager.shared.errorMessage(for: code)
                        self?.presentAlert.accept(("", message))
                    }
                }
            }).disposed(by: self.disposeBag)
    }
    
}
