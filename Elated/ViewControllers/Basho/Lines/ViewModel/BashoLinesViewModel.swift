//
//  BashoInviteViewModel.swift
//  Elated
//
//  Created by Marlon on 4/14/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import SwiftyJSON

class BashoLinesViewModel: BaseViewModel {
    
    let detail = BehaviorRelay<BashoGameDetail?>(value: nil)
    let tipShowed = BehaviorRelay<Bool>(value: true)
    let successBlockUser = PublishRelay<Void>()
    let successEndBasho = PublishRelay<Void>()
    let successNudge = PublishRelay<Void>()

    override init() {
        super.init()
    }

    func blockUser() {
        guard let userID = MemCached.shared.userInfo?.id else { return }
        var blocked = 0
        if detail.value?.inviter?.id == userID {
            blocked = detail.value!.inviter?.id ?? 0
        } else {
            blocked = detail.value!.invitee?.id ?? 0
        }
        manageActivityIndicator.accept(true)
        ApiProvider.shared.request(BlockService.blockUser(blocker: userID, blocked: blocked))
            .subscribe(onSuccess: { [weak self] res in
                self?.manageActivityIndicator.accept(false)
                self?.successBlockUser.accept(())
        }, onError: { [weak self] err in
            self?.manageActivityIndicator.accept(false)
            #if DEBUG
            print(err)
            #endif
        }).disposed(by: self.disposeBag)
    }
    
    func endGame() {
        manageActivityIndicator.accept(true)
        guard let detail = self.detail.value else { return }
        ApiProvider.shared.request(BashoService.cancel(id: detail.id!))
            .subscribe(onSuccess: { [weak self] res in
                self?.manageActivityIndicator.accept(false)
                self?.successEndBasho.accept(())
        }, onError: { [weak self] err in
            self?.manageActivityIndicator.accept(false)
            #if DEBUG
            print(err)
            #endif
        }).disposed(by: self.disposeBag)
    }
    
    func sendNudge() {
        manageActivityIndicator.accept(true)
        let otherUser: Invitee? =
            MemCached.shared.userInfo?.id == detail.value?.invitee?.id
            ? detail.value?.invitee
            : detail.value?.inviter
        guard let detail = self.detail.value,
              let other = otherUser,
              let toUser = other.id
        else { return }
        ApiProvider.shared.request(NotificationService.sendNudge(toUser: toUser,
                                                                 nudge: .gameReminder,
                                                                 game: .basho,
                                                                 actionId: detail.id))
            .subscribe(onSuccess: { [weak self] res in
                self?.manageActivityIndicator.accept(false)
                self?.successNudge.accept(())
        }, onError: { [weak self] err in
            self?.manageActivityIndicator.accept(false)
            self?.manageActivityIndicator.accept(false)
            
            #if DEBUG
            print(err)
            #endif
            
            let json = JSON((err as? MoyaError)?.response?.data as Any)
            if let code = BasicResponse(json).code {
                let message = LanguageManager.shared.errorMessage(for: code)
                self?.presentAlert.accept(("", message))
            }
        }).disposed(by: self.disposeBag)
    }
    
}
