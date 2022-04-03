//
//  SettingsViewModel.swift
//  Elated
//
//  Created by Yiel Miranda on 3/22/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import RxSwift
import RxCocoa
import SwiftyJSON
import Moya

class SettingsViewModel: BaseViewModel {
    
    let gender = BehaviorRelay<Gender>(value: .other)

    let minAge = BehaviorRelay<Int>(value: 18)
    let maxAge = BehaviorRelay<Int>(value: 32)
    
    let distance = BehaviorRelay<Int>(value: 18)
    let distanceMetric = BehaviorRelay<DistanceType>(value: .kilometeres)
    
    let selectedLocation = BehaviorRelay<MatchPrefLocationType>(value: .other)
    let address = BehaviorRelay<String>(value: "")
    let zipCode = BehaviorRelay<String>(value: "")
    
    let notifFrequency = BehaviorRelay<NotificationFrequency?>(value: nil)

    //notifications
    let notifMatch = BehaviorRelay<Bool>(value: false)
    let notifEmail = BehaviorRelay<Bool>(value: false)
    let notifSparkFlirtInvite = BehaviorRelay<Bool>(value: false)
    let notifFavorite = BehaviorRelay<Bool>(value: false)
    let notifNudge = BehaviorRelay<Bool>(value: false)
    
    let sectionTitles = ["settings.header.title.notifications".localized,
                         "settings.header.title.account".localized]
    
    let rowTitles = ["settings.cell.title.match".localized,
                     "settings.cell.title.age".localized,
                     "settings.cell.title.distance".localized,
                     "settings.cell.title.location".localized,
                     "settings.cell.title.notification".localized,
                     "settings.cell.title.new.match".localized,
                     "settings.cell.title.new.message".localized,
                     "settings.cell.title.sparkflirt".localized,
                     "settings.cell.title.favorited".localized,
                     "settings.cell.title.nudge".localized,
                     "settings.cell.title.pause".localized,
                     "settings.cell.title.delete".localized]
    
    var rowSubtitles = [String]()
    
    let user = BehaviorRelay<UserInfo?>(value: MemCached.shared.userInfo)
    
    //MARK: - Init
    
    override init() {
        super.init()
        
        user.subscribe(onNext: { [weak self] user in
            guard let self = self else { return }
            let matchPref = user?.matchPreferences
            let settings = user?.settings
            let notification = user?.notification

            let gender = matchPref?.genderPref ?? Gender.other
            let genderString = gender.rawValue.lowercased().capitalized
            var minAge = matchPref?.ageMin ?? 18
            minAge = minAge == 0 ? 18 : minAge
            var maxAge = matchPref?.ageMax ?? 32
            maxAge = maxAge == 0 ? 32 : maxAge
            let range = matchPref?.maxDistance ?? 18
            let metric = matchPref?.distanceType ?? .kilometeres//DistanceType.kilometeres
            
            let address = matchPref?.location?.address
            let zipCode = matchPref?.location?.zipCode
            self.address.accept(address ?? "")
            self.zipCode.accept(zipCode ?? "")

            self.gender.accept(gender)
            self.minAge.accept(minAge)
            self.maxAge.accept(maxAge)
            
            self.distance.accept(range)
            self.distanceMetric.accept(metric)
            
            self.selectedLocation.accept(matchPref?.locationType ?? .nearMe)
            
            self.notifFrequency.accept(settings?.notificationFrequency)
            
            self.notifMatch.accept(notification?.match ?? false)
            self.notifEmail.accept(notification?.email ?? false)
            self.notifSparkFlirtInvite.accept(notification?.sparkFlirtInvite ?? false)
            self.notifFavorite.accept(notification?.favorite ?? false)
            self.notifNudge.accept(notification?.nudge ?? false)
            
            self.rowSubtitles = [genderString,
                                 "\(minAge)-\(maxAge)",
                                 "\(range)\(metric.getAbbreviation())",
                                 self.selectedLocation.value.getName()]
        }).disposed(by: disposeBag)
     
        Observable.combineLatest(notifEmail, notifMatch, notifSparkFlirtInvite, notifNudge, notifFavorite)
            .subscribe(onNext: { [weak self] _, _, _, _, _ in
                self?.updateNotification()
            }).disposed(by: disposeBag)
        
    }
    
    func getProfile() {
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
    
    func updateNotification() {
        var parameters = [String: Any]()
        parameters["email"] = notifEmail.value
        parameters["match"] = notifMatch.value
        parameters["sparkflirt_invite"] = notifSparkFlirtInvite.value
        parameters["nudge"] = notifNudge.value
        parameters["favorite"] = notifFavorite.value

        manageActivityIndicator.accept(true)
        ApiProvider.shared.request(UserSettingsService.updateProfile(parameters: ["notification": parameters]))
            .subscribe(onSuccess: { [weak self] res in
            self?.manageActivityIndicator.accept(false)
        }, onError: { [weak self] err in
            self?.manageActivityIndicator.accept(false)
            self?.presentAlert.accept(("common.error".localized,
                                       "common.error.somethingWentWrong".localized))
        }).disposed(by: self.disposeBag)
    }
    
}
