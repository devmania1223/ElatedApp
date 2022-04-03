//
//  SettingsAccountViewModel.swift
//  Elated
//
//  Created by Yiel Miranda on 3/25/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import RxSwift
import RxCocoa
import Moya
import SwiftyJSON

enum SettingsAccountType {
    case Pause, Delete
}

class SettingsAccountViewModel: BaseViewModel {
    
    //MARK: - Properties
    
    let settingsAccountType = BehaviorRelay<SettingsAccountType>(value: .Pause)

    let titleText = BehaviorRelay<String>(value: "")
    let messageText = BehaviorRelay<String>(value: "")
    let cancelButtonText = BehaviorRelay<String>(value: "")
    let proceedButtonText = BehaviorRelay<String>(value: "")
    
    let success = PublishRelay<Void>()
    
    var successMessageText = ""
    let successButtonText = "Continue"
    
    //MARK: - Custom
    
    func setSettingsAccountType(type: SettingsAccountType) {
        if type == .Pause {
            titleText.accept("settings.notification.title.pause".localized)
            messageText.accept("settings.notification.message.pause".localized)
            cancelButtonText.accept("settings.notification.cancel.pause".localized)
            proceedButtonText.accept("settings.notification.confirm.pause".localized)
        } else {
            titleText.accept("settings.notification.title.delete".localized)
            messageText.accept("settings.notification.message.delete".localized)
            cancelButtonText.accept("settings.notification.cancel.delete".localized)
            proceedButtonText.accept("settings.notification.confirm.delete".localized)
        }
    }
    
    func didCancel() {
        if settingsAccountType.value == .Pause {
            //Log out
            NotificationCenter.default.post(Notification(name: .userLogout))
        } else {
            //Pause
            successMessageText = "Account Paused"
            self.pauseAccount()
        }
    }
    
    func didProceed() {
        if settingsAccountType.value == .Pause {
            //Pause
            successMessageText = "Account Paused"
            self.pauseAccount()
        } else {
            //Delete
            successMessageText = "Account Deleted"
            self.deleteAccount()
        }
    }
    
    func unregisterNotification() {
        //unregister remote notification
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            ApiProvider.shared.request(NotificationService.unregisterDevice(uuid: uuid))
                .subscribe(onSuccess: { res in
                    #if DEBUG
                        print("Success Unregistration of Notification Token")
                    #endif
            }, onError: { err in
                #if DEBUG
                    print("Error Unregistration of Notification Token: \(err)")
                #endif
            }).disposed(by: disposeBag)
        }
    }
    
    private func pauseAccount() {
        //TODO: Pause Account API not yet available
        self.success.accept(())
    }
    
    private func deleteAccount() {
        manageActivityIndicator.accept(true)
        
        ApiProvider.shared.request(AuthService.deleteMe)
            .subscribe(onSuccess: { [weak self] res in
            self?.manageActivityIndicator.accept(false)
            self?.success.accept(())
        }, onError: { [weak self] err in
            self?.presentAlert.accept(("common.error".localized,
                                       "common.error.somethingWentWrong".localized))
        }).disposed(by: self.disposeBag)
    }
}
