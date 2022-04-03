//
//  SettingsCommonViewModel.swift
//  Elated
//
//  Created by Yiel Miranda on 4/7/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import RxSwift
import RxCocoa

class SettingsCommonViewModel: BaseViewModel {
    
    enum RequestType {
        case ageRange
        case location
        case notificationFrequency
    }
    
    //MARK: - Properties
    
    let gender = BehaviorRelay<Gender>(value: .other)

    let editType = BehaviorRelay<EditInfoControllerType>(value: .settings)
    let minAge = BehaviorRelay<Int>(value: 18)
    let maxAge = BehaviorRelay<Int>(value: 32)
    
    let distance = BehaviorRelay<Int>(value: 18)
    let computedDistance = BehaviorRelay<Int>(value: 0)
    let distanceMetric = BehaviorRelay<DistanceType>(value: .kilometeres)
    
    //location update
    let selectedLocation = BehaviorRelay<MatchPrefLocationType>(value: .other)
    let address = BehaviorRelay<String>(value: "")
    let zipCode = BehaviorRelay<String>(value: "")
    let lat = BehaviorRelay<Float?>(value: nil)
    let lng = BehaviorRelay<Float?>(value: nil)
    let placesID = BehaviorRelay<String?>(value: nil)

    let notificationFrequency = BehaviorRelay<NotificationFrequency?>(value: nil)
    
    let success = PublishRelay<Void>()
    
    //MARK: - Properties
    
    func getMinMaxAgeString() -> String {
        return "\(minAge.value)-\(maxAge.value)"
    }
    
    func getDistanceString() -> String {
        let metric = distanceMetric.value == .miles
            ? "settings.distance.miles.abbreviation".localized
            : "settings.distance.kilometers.abbreviation".localized
        return "\(computedDistance.value) \(metric)"
    }
    
    private func convert(from: UnitLength, to: UnitLength, value: Double) -> Double {
        let distance = Measurement(value: Double(value), unit: from)
        let converted = distance.converted(to: to)
        
        return converted.value
    }
    
    //MARK: - API
    
    func sendRequest(_ type: RequestType) {
        var parameters: [String: Any]? = nil

        switch type {
        case .ageRange:
            parameters = ["match_preferences": ["age_min" : minAge.value, "age_max": maxAge.value]]
            updateProfile(parameters: parameters!)
        case .location:
            var location = [String: Any]()
            if selectedLocation.value == .nearMe {
                parameters = ["match_preferences": ["location_type": selectedLocation.value.rawValue]]
            } else {
                if !self.address.value.isEmpty {
                    location["formatted_address"] = self.address.value
                }
                if let zip = Int(self.zipCode.value) {
                    location["zip_code"] = zip
                }
                if let lat = self.lat.value {
                    location["lat"] = lat
                }
                if let lng = self.lng.value {
                    location["lng"] = lng
                }
                if let placesID = self.placesID.value {
                    location["places_id"] = placesID
                }
                parameters = ["match_preferences": ["location" : location,
                                                    "location_type": selectedLocation.value.rawValue]]
            }
            updateProfile(parameters: parameters!)
        case .notificationFrequency:
            if let frequency = notificationFrequency.value?.rawValue {
                parameters = ["settings": ["notification_frequency": frequency]]
            }
            updateProfile(parameters: parameters!)
        }
    }

    private func updateProfile(parameters: [String: Any]) {
        manageActivityIndicator.accept(true)
        ApiProvider.shared.request(UserSettingsService.updateProfile(parameters: parameters))
            .subscribe(onSuccess: { [weak self] res in
            self?.manageActivityIndicator.accept(false)
            self?.success.accept(())
        }, onError: { [weak self] err in
            self?.manageActivityIndicator.accept(false)
            self?.presentAlert.accept(("common.error".localized,
                                       "common.error.somethingWentWrong".localized))
        }).disposed(by: self.disposeBag)
    }
    
    func updateUserNotificationSettings(parameters: [String: Any]) {
        manageActivityIndicator.accept(true)
        ApiProvider.shared.request(UserSettingsService.updateNotification(parameters: parameters))
            .subscribe(onSuccess: { [weak self] res in
            self?.manageActivityIndicator.accept(false)
            self?.success.accept(())
        }, onError: { [weak self] err in
            self?.manageActivityIndicator.accept(false)
            self?.presentAlert.accept(("common.error".localized,
                                       "common.error.somethingWentWrong".localized))
        }).disposed(by: self.disposeBag)
    }
}
