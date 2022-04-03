//
//  LaunchViewModel.swift
//  Elated
//
//  Created by Marlon on 2021/3/18.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import RxCocoa
import RxSwift
import SwiftyJSON
import Moya

class LaunchViewModel: BaseViewModel {

    let logined = PublishRelay<UserInfo?>()
    
    let addBooks = BehaviorRelay<Bool>(value: false)
    let addMusic = BehaviorRelay<Bool>(value: false)

    func initializeUserState() {
        
        if UserDefaults.standard.token != nil {
            ApiProvider.shared.request(UserServices.getUsersMe)
                .subscribe(onSuccess: { [weak self] res in
                    let response = GetUserInfoResponse(JSON(res))
                    MemCached.shared.userInfo = response.user
                    self?.getBooks()
                }, onError: { [weak self] err in
                    UserDefaults.standard.clearUserData()
                    self?.logined.accept(nil)
            }).disposed(by: disposeBag)
        } else {
            logined.accept(nil)
        }
        
        logined.subscribe(onNext: { [weak self] user in
            if user != nil {
                UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .badge]) { granted, error in
                    if granted {
                        #if DEBUG
                        print("Success Granted Notification")
                        DispatchQueue.main.async {
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                        #endif
                    } else {
                        #if DEBUG
                        print("Error Register Notification \(error?.localizedDescription ?? "")")
                        #endif
                    }
                }
                
                NotificationCenter.default.post(Notification(name: .userLoggedIn))
            }
        }).disposed(by: disposeBag)
        
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
            self?.logined.accept(MemCached.shared.userInfo)
        }, onError: { [weak self] err in
//            self?.manageActivityIndicator.accept(false)
//            self?.addMusic.accept(true)
            self?.logined.accept(MemCached.shared.userInfo)
        }).disposed(by: self.disposeBag)
    }
    
}
