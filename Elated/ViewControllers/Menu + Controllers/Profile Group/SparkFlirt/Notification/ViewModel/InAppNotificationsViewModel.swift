//
//  InAppNotificationsViewModel.swift
//  Elated
//
//  Created by Rey Felipe on 11/15/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Moya
import RxCocoa
import RxSwift
import SwiftyJSON


class InAppNotificationsViewModel: BaseViewModel {
    
    let unreadNotifs = BehaviorRelay<Int>(value: 0)
    let notifs = BehaviorRelay<[InAppNotificationData]>(value: [])
    let selectedIndex = BehaviorRelay<Int>(value: 0)
    
    func getNotifications(_ page: Int) {
        
        self.manageActivityIndicator.accept(true)
        
        ApiProvider.shared.request(InAppNotificationService.getNotifications(page: page))
            .subscribe(onSuccess: { [weak self] res in
                
                self?.manageActivityIndicator.accept(false)
                print(JSON(res))
                let response = InAppNotificationResponse(JSON(res))
                self?.notifs.accept(response.data)
                
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
    
    func getTotalUnreadNotificationCounter() {
        
        ApiProvider.shared.request(InAppNotificationService.getNumberOfUnreadNotifications)
            .subscribe(onSuccess: { res in
                print(JSON(res))
                let response = InAppNotificationUnreadCountResponse(JSON(res))
                self.unreadNotifs.accept(response.unreadNotifs)
            }, onError: { [weak self] err in
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
    
    func notificationMarkAsRead(_ notificationId: Int, index: Int) {
        ApiProvider.shared.request(InAppNotificationService.markAsRead(id: notificationId))
            .subscribe(onSuccess: { res in
                //Update and reload data
                var notif = self.notifs.value[index]
                self.notifs.remove(at: index)
                notif.isRead = true
                self.notifs.insert(notif, at: index)
            }, onError: { err in
                #if DEBUG
                print(err)
                #endif
            }).disposed(by: self.disposeBag)
    }
    
    func deleteNotification(_ notificationId: Int, index: Int) {
        ApiProvider.shared.request(InAppNotificationService.deleteItem(id: notificationId))
            .subscribe(onSuccess: { res in
                //Remove and reload data
                self.notifs.remove(at: index)
            }, onError: { err in
                print(err)
            }).disposed(by: self.disposeBag)
    }
    
}
