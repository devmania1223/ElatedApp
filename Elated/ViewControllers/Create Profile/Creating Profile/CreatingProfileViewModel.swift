//
//  CreatingProfileViewModel.swift
//  Elated
//
//  Created by Marlon on 6/10/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxCocoa
import SwiftyJSON

class CreatingProfileViewModel: BaseViewModel {

    let success = PublishRelay<Void>()
    
    override init() {
        super.init()
    }
    
    @objc func completeProfile() {
        guard let userID = MemCached.shared.userInfo?.id else { return }
        ApiProvider.shared.request(UserServices.completeProfile(id: userID))
            .subscribe(onSuccess: { [weak self] res in
            self?.getProfile()
        }, onError: { [weak self] err in
            self?.presentRetry.accept(())
        }).disposed(by: self.disposeBag)
    }
    
    private func getProfile() {
        ApiProvider.shared.request(UserServices.getUsersMe)
            .subscribe(onSuccess: { [weak self] res in
                let response = GetUserInfoResponse(JSON(res))
                MemCached.shared.userInfo = response.user
                self?.success.accept(())
        }, onError: { [weak self] err in
            self?.success.accept(())
        }).disposed(by: self.disposeBag)
    }

    
}
