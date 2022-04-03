//
//  AddImageCaptionViewModel.swift
//  Elated
//
//  Created by Marlon on 7/17/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import SwiftyJSON
import RxCocoa
import RxSwift
import Moya

class AddImageCaptionViewModel: BaseViewModel {

    let goBack = PublishRelay<Void>()
    let editType = BehaviorRelay<EditInfoControllerType?>(value: nil)

    //Instagram
    let urlImage = BehaviorRelay<String?>(value: nil)
    let sourceID = BehaviorRelay<String?>(value: nil)
    
    //Raw Image
    let image = BehaviorRelay<UIImage?>(value: nil)
    
    let caption = BehaviorRelay<String>(value: "")

    func upload() {
        if image.value != nil {
            self.uploadImage()
        } else {
            self.uploadInstagram()
        }
    }
    
    private func uploadImage() {
        guard let userID = MemCached.shared.userInfo?.id,
              let image = image.value else { return }
        let caption = self.caption.value.replacingOccurrences(of: "profile.gallery.caption.placeholder".localized,
                                                         with: "")
        manageActivityIndicator.accept(true)
        ApiProvider.shared.request(UserServices.uploadProfilePicture(id: userID,
                                                                     image: image,
                                                                     caption: caption))
            .subscribe(onSuccess: { [weak self] res in
                self?.manageActivityIndicator.accept(false)
                self?.goBack.accept(())
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
    
    private func uploadInstagram() {
        guard let urlImage = urlImage.value,
              let sourceID = sourceID.value
        else { return }
        let caption = self.caption.value.replacingOccurrences(of: "profile.gallery.caption.placeholder".localized,
                                                         with: "")
        manageActivityIndicator.accept(true)
        ApiProvider.shared.request(InstagramAuthService.uploadMedia(mediaURL: urlImage,
                                                                    sourceID: sourceID,
                                                                    caption: caption))
            .subscribe(onSuccess: { [weak self] res in
            self?.manageActivityIndicator.accept(false)
            self?.goBack.accept(())
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
    
}
