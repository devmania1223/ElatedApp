//
//  SideMenuViewModel.swift
//  Elated
//
//  Created by Marlon on 2021/3/2.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import RxSwift
import RxCocoa

class SideMenuViewModel: BaseViewModel {

    enum MenuOption: String {
        case profile = "menu.button.profile"
        case sparkFlirt = "menu.item.sparkFlirt"
        case settings = "menu.item.settings"
        case inviteFriends = "menu.item.inviteFriends"
        case howToUse = "menu.item.howToUse"
        case contactUs = "menu.item.contactUs"
        case legal = "menu.item.legal"
    }
    
    let activeScreen = BehaviorRelay<MenuOption>(value: .profile)
    let nameAge = BehaviorRelay<String?>(value: nil)
    let images = BehaviorRelay<[ProfileImage]>(value: [])

    let titles = [MenuOption.sparkFlirt.rawValue,
                  MenuOption.settings.rawValue,
                  MenuOption.inviteFriends.rawValue,
                  MenuOption.howToUse.rawValue,
                  MenuOption.contactUs.rawValue,
                  MenuOption.legal.rawValue]
    
    override init() {
        super.init()
        getProfile()
    }
    
    func getProfile() {
        let user = MemCached.shared.userInfo
        self.nameAge.accept(user?.getDisplayNameAge())
        self.images.accept(user?.profileImages ?? [])
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
    
}
