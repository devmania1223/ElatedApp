//
//  SparkFlirtInvitesViewModel.swift
//  Elated
//
//  Created by Rey Felipe on 7/5/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Moya
import RxCocoa
import RxSwift
import SwiftyJSON


class SparkFlirtInvitesViewModel: BaseViewModel {
    
    enum InviteResponse: Int {
        case accept
        case decline
    }
    
    let invites = BehaviorRelay<[SparkFlirtInfo]>(value: [])
    let selectedIndex = BehaviorRelay<Int>(value: 0)
    let success = PublishRelay<InviteResponse>()
    
    func getSparkFlirtInvites(_ page: Int) {
        
        self.manageActivityIndicator.accept(true)
        
        ApiProvider.shared.request(SparkFlirtService.getIncomingSparkFlirt(page: page))
            .subscribe(onSuccess: { [weak self] res in
                print(JSON(res))
                self?.manageActivityIndicator.accept(false)
                let response = SparkFlirtResponse(JSON(res))
                self?.invites.accept(response.data)
                
        }, onError: { [weak self] err in
            self?.manageActivityIndicator.accept(false)
            let json = JSON((err as? MoyaError)?.response?.data as Any)
            #if DEBUG
            print(err)
            #endif
            if let code = BasicResponse(json).code {
                let message = LanguageManager.shared.errorMessage(for: code)
                print(message)
                self?.presentAlert.accept(("", message))
            }
        }).disposed(by: self.disposeBag)
    }
    
    func acceptDeclineInvitation(_ inviteId: Int, accept: Bool) {
        print("SparkFlirt - Accept/Decline - inviteId - \(inviteId) | \(accept)")
        self.manageActivityIndicator.accept(true)

        ApiProvider.shared.request(SparkFlirtService.acceptSparkFlirtInvite(id: inviteId, accept: accept))
            .subscribe(onSuccess: { [weak self] res in

                self?.manageActivityIndicator.accept(false)
                self?.success.accept((accept ? .accept : .decline))

        }, onError: { [weak self] err in
            self?.manageActivityIndicator.accept(false)
            let json = JSON((err as? MoyaError)?.response?.data as Any)
            #if DEBUG
            print(err)
            #endif
            if let code = BasicResponse(json).code {
                let message = LanguageManager.shared.errorMessage(for: code)
                //present alert triggers binding on the view controller, make sure its handled
                self?.presentAlert.accept(("", message))
            }
        }).disposed(by: self.disposeBag)
    }
}
