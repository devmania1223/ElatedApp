//
//  SignUpViewModel.swift
//  Elated
//
//  Created by Louise Nicolas Namoc on 3/8/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Moya
import SwiftyJSON

class SignInViewModel: BaseViewModel {

  var loginRetries = BehaviorRelay<Int>(value: 0)
  var emailText = BehaviorRelay<String>(value: .empty)
  var passwordText = BehaviorRelay<String>(value: .empty)
  let success = PublishRelay<Void>()

  //incase onboarding required works
  let addBooks = BehaviorRelay<Bool>(value: false)
  let addMusic = BehaviorRelay<Bool>(value: false)

  var onEmailValueChanged: Observable<Bool> {
    return emailText.asObservable().map({ $0.count == 0 })
  }

  var onPasswordValueChanged: Observable<Bool> {
    return passwordText.asObservable().map({ $0.count == 0 })
  }

  var isFieldsComplete: Observable<Bool> {
    return Observable.combineLatest(emailText, passwordText) { $0.count != 0 && $1.count != 0 }
  }
    

    func signIn() {
        self.manageActivityIndicator.accept(true)
        ApiProvider.shared.request(AuthService.login(username: emailText.value,
                                                      password: passwordText.value))
            .subscribe(onSuccess: { [weak self] res in
            self?.manageActivityIndicator.accept(false)
                let response = SigninResponse(JSON(res))
                UserDefaults.standard.token = response.token ?? ""
                MemCached.shared.userInfo = response.user
                if response.user?.profile?.profileComplete == false {
                    self?.getBooks()
                } else {
                    self?.success.accept(())
                }
                NotificationCenter.default.post(Notification(name: .userLoggedIn))
        }, onError: { [weak self] err in
            //handle all errors here
            guard let self = self else { return }
            self.manageActivityIndicator.accept(false)
            let json = JSON((err as? MoyaError)?.response?.data as Any)
            #if DEBUG
            print(err)
            #endif
            let tries = self.loginRetries.value
            self.loginRetries.accept(tries + 1)
            if tries < 3 {
                if BasicResponse(json).code != nil {
                    let message = LanguageManager.shared.errorMessage(for: 1000000000)
                    self.presentAlert.accept(("", message))
                } else {
                    let message = LanguageManager.shared.errorMessage(for: -1)
                    self.presentAlert.accept(("", message))
                }
            }
        }).disposed(by: self.disposeBag)
    }
    
    func getBooks() {
        manageActivityIndicator.accept(true)
        ApiProvider.shared.request(UserSettingsService.getBookList(page: 1))
            .subscribe(onSuccess: { [weak self] res in
            self?.manageActivityIndicator.accept(false)
            let response = BookResponse(JSON(res))
            self?.addBooks.accept(response.books.count == 0)
            self?.getMusic()
        }, onError: { [weak self] err in
            self?.manageActivityIndicator.accept(false)
            self?.addBooks.accept(true)
            self?.getMusic()
        }).disposed(by: self.disposeBag)
    }
    
    func getMusic() {
//        manageActivityIndicator.accept(true)
        ApiProvider.shared.request(UserSettingsService.getBookList(page: 1))
            .subscribe(onSuccess: { [weak self] res in
//            self?.manageActivityIndicator.accept(false)
//            let response = BookResponse(JSON(res))
//            self?.addMusic.accept(response.books.count == 0)
            self?.success.accept(())
        }, onError: { [weak self] err in
//            self?.manageActivityIndicator.accept(false)
//            self?.addMusic.accept(true)
            self?.success.accept(())
        }).disposed(by: self.disposeBag)
    }
    
}

