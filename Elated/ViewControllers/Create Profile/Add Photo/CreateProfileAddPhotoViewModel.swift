//
//  CreateProfileAddPhotoViewModel.swift
//  Elated
//
//  Created by Marlon on 6/10/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import SwiftyJSON
import RxCocoa
import RxSwift
import Moya

class CreateProfileAddPhotoViewModel: BaseViewModel {
    
    let next = PublishRelay<Void>()
    let images = BehaviorRelay<[ProfileImage]>(value: [])
    let showInstagramAuth = PublishRelay<Bool>()
    
    override init() {
        super.init()
    
        images.accept(MemCached.shared.userInfo?.profileImages ?? [])
    }
    
    func deleteImage(_ id: Int) {
        manageActivityIndicator.accept(true)
        ApiProvider.shared.request(UserServices.deleteProfileImage(id: id))
            .subscribe(onSuccess: { [weak self] res in
            self?.manageActivityIndicator.accept(false)
            self?.getProfile()
        }, onError: { [weak self] err in
            self?.manageActivityIndicator.accept(false)
            let json = JSON((err as? MoyaError)?.response?.data as Any)
            #if DEBUG
            print(err)
            #endif
            if let code = BasicResponse(json).code {
                let message = LanguageManager.shared.errorMessage(for: code)
                //present alert triggers binding on the view controller, make sure its handled
                print(message)
                self?.presentAlert.accept(("", message))
            }
        }).disposed(by: self.disposeBag)
    }
    
    func getProfile() {
        ApiProvider.shared.request(UserServices.getUsersMe)
            .subscribe(onSuccess: { [weak self] res in
            self?.manageActivityIndicator.accept(false)
                let response = GetUserInfoResponse(JSON(res))
                MemCached.shared.userInfo = response.user
                self?.images.accept(response.user?.profileImages ?? [])
        }, onError: { [weak self] err in
            self?.manageActivityIndicator.accept(false)
            let json = JSON((err as? MoyaError)?.response?.data as Any)
            #if DEBUG
            print(err)
            #endif
            if let code = BasicResponse(json).code {
                let message = LanguageManager.shared.errorMessage(for: code)
                self?.presentAlert.accept(("", message))
            }
        }).disposed(by: self.disposeBag)
    }
    
    func getInstagramUsername() {
        manageActivityIndicator.accept(true)
        ApiProvider.shared.request(InstagramAuthService.getUsername)
            .subscribe(onSuccess: { [weak self] res in
            self?.manageActivityIndicator.accept(false)
            self?.showInstagramAuth.accept(false)
        }, onError: { [weak self] err in
            self?.manageActivityIndicator.accept(false)
            self?.showInstagramAuth.accept(true)
        }).disposed(by: self.disposeBag)
    }
    
}
