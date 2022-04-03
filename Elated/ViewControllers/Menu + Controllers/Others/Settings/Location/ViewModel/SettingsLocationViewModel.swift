//
//  SettingsLocationViewModel.swift
//  Elated
//
//  Created by Yiel Miranda on 3/24/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import RxSwift
import RxCocoa
import SwiftyJSON

class SettingsLocationViewModel: SettingsCommonViewModel {

    //MARK: - Properties
    
    let locations = ["settings.location.nearme".localized,
                     "settings.location.other".localized]
    
    let allowSave = BehaviorRelay<Bool>(value: false)
    let places = BehaviorRelay<[Place]>(value: [])
    let selectedPlace = BehaviorRelay<Place?>(value: nil)
    let titleLabelTopSpace = BehaviorRelay<Float>(value: 40)

    //MARK: - Init
    
    override init() {
        super.init()
        
        Observable.combineLatest(address, zipCode, selectedLocation)
            .subscribe(onNext: { [weak self] address, zipCode, type in
                guard let self = self else { return }
                
                let addressValid = !address.isEmpty
                let zipCodeValid = !zipCode.isEmpty
                
                self.allowSave.accept((addressValid && zipCodeValid) || type == .nearMe)
            }).disposed(by: self.disposeBag)
        
        address.subscribe(onNext: { [weak self] address in
            self?.getPlaces(keyword: address)
        }).disposed(by: self.disposeBag)
        
        selectedPlace.subscribe(onNext: { [weak self] place in
            guard let self = self, let place = place else { return }
            self.address.accept(place.address ?? "")
            if let zip = place.location?.zipCode {
                self.zipCode.accept("\(zip)")
            }
            if let id = place.placeID {
                self.placesID.accept(id)
            }
            if let lat = place.location?.lat {
                self.lat.accept(lat)
            }
            if let lng = place.location?.lng {
                self.lng.accept(lng)
            }
        }).disposed(by: self.disposeBag)
        
        editType.subscribe(onNext: { [weak self] type in
            guard let self = self else { return }
            self.titleLabelTopSpace.accept((type == .onboarding && Util.heigherThanIphone6) ? 84 : 40)
        }).disposed(by: disposeBag)
        
    }
    
    func getPlaces(keyword: String) {
        ApiProvider.shared.request(ThirdPartyService.getPlaces(keyword: keyword))
            .subscribe(onSuccess: { [weak self] res in
                self?.manageActivityIndicator.accept(false)
                let response = PlacesResponse(JSON(res))
                self?.places.accept(response.places)
        }, onError: { [weak self] err in
            self?.manageActivityIndicator.accept(false)
        }).disposed(by: self.disposeBag)
    }
    
}

