//
//  ProfileGalleryViewModel.swift
//  Elated
//
//  Created by Marlon on 5/21/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Moya
import SwiftyJSON

class ProfileGalleryViewModel: BaseViewModel {
    
    let userViewID = BehaviorRelay<Int?>(value: nil)
    let info = BehaviorRelay<String?>(value: nil)
    let nameAge = BehaviorRelay<String?>(value: nil)
    let images = BehaviorRelay<[ProfileImage]>(value: [])
    let user = BehaviorRelay<UserInfo?>(value: nil)
    let showInstagramAuth = PublishRelay<Bool>()

    override init() {
        super.init()
        
        user.subscribe(onNext: { [weak self] user in
            guard let self = self, let user = user else { return }
            let profile = user.profile
            let location = user.location

            let height = profile?.heightFeet ?? ""
            let occupation = profile?.occupation ?? ""
            let address = location?.address ?? ""
            let info = "\(height) | \(occupation) | \(address)"
            self.info.accept(info)
   
            self.images.accept(user.profileImages)
            let nameAge = user.getDisplayNameAge()
            self.nameAge.accept(nameAge)
        }).disposed(by: disposeBag)
        
    }
    
    func getProfile() {
        if let userId = userViewID.value {
            getUserProfile(user: userId)
        } else {
            getUpdatedProfile()
        }
    }
    
    private func getUserProfile(user: Int) {
        ApiProvider.shared.request(UserServices.getUsersByPath(id: user))
            .subscribe(onSuccess: { [weak self] res in
                let response = GetUserInfoResponse(JSON(res))
                if let user = response.user {
                    self?.user.accept(user)
                }
        }, onError: { [weak self] err in
            #if DEBUG
                print(err)
            #endif
            //keep trying
            self?.getUserProfile(user: user)
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
    
    func uploadImage(_ image: UIImage) {
        guard let userID = MemCached.shared.userInfo?.id else { return }
        manageActivityIndicator.accept(true)
        ApiProvider.shared.request(UserServices.uploadProfilePicture(id: userID,
                                                                     image: image,
                                                                     caption: ""))
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
    
    func uploadInstagram(_ image: String, sourceID: String) {
        manageActivityIndicator.accept(true)
        ApiProvider.shared.request(InstagramAuthService.uploadMedia(mediaURL: image, sourceID: sourceID, caption: ""))
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
                self?.presentAlert.accept(("", message))
            }
            self?.getUpdatedProfile()
        }).disposed(by: self.disposeBag)
    }
    
    private func getUpdatedProfile() {
        self.manageActivityIndicator.accept(true)
        ApiProvider.shared.request(UserServices.getUsersMe)
            .subscribe(onSuccess: { [weak self] res in
            self?.manageActivityIndicator.accept(false)
                let response = GetUserInfoResponse(JSON(res))
                self?.user.accept(response.user)
                MemCached.shared.userInfo = response.user
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
    
}
