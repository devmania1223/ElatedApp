//
//  ProfilePhotoViewModel.swift
//  Elated
//
//  Created by Marlon on 4/30/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON
import Moya

class ProfilePhotoViewModel: BaseViewModel {
    
    enum ScreenType {
        case personal
        case view
    }
    
    let type = BehaviorRelay<ScreenType>(value: .personal)
    let profileImage = BehaviorRelay<ProfileImage?>(value: nil)
    let mainImage = BehaviorRelay<ProfileImage?>(value: nil)
    let caption = BehaviorRelay<String?>(value: nil)
    let name = BehaviorRelay<String?>(value: nil)
    let isEditing = BehaviorRelay<Bool>(value: false)
    let showCaption = BehaviorRelay<Bool>(value: true)

    func updateCaption() {
        self.manageActivityIndicator.accept(true)
        let caption = (self.caption.value ?? "").replacingOccurrences(of: "profile.gallery.caption.placeholder".localized, with: "")
        guard let image = self.mainImage.value,
              let pk = image.pk,
              !caption.isEmpty else { return }
        ApiProvider.shared.request(UserServices.updateProfileCaption(id: pk, caption: caption))
            .subscribe(onSuccess: { [weak self] res in
                self?.manageActivityIndicator.accept(false)
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
