//
//  EditProfileCommonViewModel.swift
//  Elated
//
//  Created by Marlon on 3/25/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import RxSwift
import RxCocoa
import Moya
import SwiftyJSON

class EditProfileCommonViewModel: BaseViewModel {

    enum RequestType {
        //edit
        case birthday
        case bio
        case occupation
        case race
        case height
        case education
        case language
        case religion
        case zodiac
        case politics
        case location
        case ageRange
        case distance
        case gender
        case status
        case datingPreference
        case kidsPreference
        case haveKids
        case smokingPrefence
        case dringkingPrefence
        
        //onboarding
        case name
    }
    
    let birthday = BehaviorRelay<Date?>(value: nil)
    let bio = BehaviorRelay<String?>(value: nil)
    let occupation = BehaviorRelay<String?>(value: nil)
    let race = BehaviorRelay<Race?>(value: nil)
    let otherRace = BehaviorRelay<String?>(value: nil)
    let height = BehaviorRelay<Double?>(value: 70)
    let heightType = BehaviorRelay<HeightType?>(value: .feet)
    let education = BehaviorRelay<String?>(value: nil)
    let langauge = BehaviorRelay<[String]?>(value: nil)
    let religion = BehaviorRelay<Religion?>(value: nil)
    let otherReligion = BehaviorRelay<String?>(value: nil)
    let zodiac = BehaviorRelay<Zodiac?>(value: nil)
    let politics = BehaviorRelay<String?>(value: nil)
    let ageRange = BehaviorRelay<(Int, Int)?>(value: nil) //min - max
    let distance = BehaviorRelay<Int?>(value: nil)
    let distanceType = BehaviorRelay<DistanceType?>(value: .miles)
    let gender = BehaviorRelay<Gender?>(value: nil)
    let status = BehaviorRelay<MaritalStatus?>(value: nil)
    let datingPreference = BehaviorRelay<DatingPreference?>(value: nil)
    let kidsPreference = BehaviorRelay<FamilyPreference?>(value: nil)
    let haveKids = BehaviorRelay<HaveKids?>(value: nil)
    let smokingPreference = BehaviorRelay<[SmokingPreference]>(value: [])
    let dringkingPrefence = BehaviorRelay<String?>(value: nil)
    
    let firstName = BehaviorRelay<String?>(value: nil)
    let lastName = BehaviorRelay<String?>(value: nil)

    //location update
    let address = BehaviorRelay<String>(value: "")
    let zipCode = BehaviorRelay<String>(value: "")
    let lat = BehaviorRelay<Float?>(value: nil)
    let lng = BehaviorRelay<Float?>(value: nil)
    let placesID = BehaviorRelay<String?>(value: nil)
    let locationType = BehaviorRelay<MatchPrefLocationType>(value: .other)

    
    //editType
    let isGenderPreference = BehaviorRelay<Bool>(value: false)
    let editType = BehaviorRelay<EditInfoControllerType>(value: .edit)
    let titleLabelTopSpace = BehaviorRelay<Float>(value: 40)

    //places api
    let places = BehaviorRelay<[Place]>(value: [])
    let selectedPlace = BehaviorRelay<Place?>(value: nil)

    //books api
    let userBooks = BehaviorRelay<[Book]>(value: [])
    private let booksNextPage = BehaviorRelay<Int?>(value: nil)
    private let isFetchingBooks = BehaviorRelay<Bool>(value: false)

    //music api
    //let userArtists = BehaviorRelay<[Artist]?>(value: nil)

    let success = PublishRelay<Void>()
    
    override init() {
        super.init()
        
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
    
    func sendRequest(_ type: RequestType) {
        
        var parameters: [String: Any]? = nil

        switch type {
        
        case .birthday:
            guard let data = birthday.value else { return }
            parameters = ["profile": ["birthdate": data.dateToString()]]
            updateProfile(parameters: parameters!)
        case .bio:
            guard let data = bio.value else { return }
            parameters = ["profile": ["bio" : data]]
            updateProfile(parameters: parameters!)
        case .occupation:
            guard let data = occupation.value else { return }
            parameters = ["profile": ["occupation" : data]]
            updateProfile(parameters: parameters!)
            return
        case .education:
            guard let data = education.value else { return }
            parameters = ["profile": ["college" : data]]
            updateProfile(parameters: parameters!)
            return
        case .race:
            guard let data = race.value else { return }
            if data == .other {
                if let other = otherRace.value, !other.isEmpty {
                    parameters = ["profile": ["other_race" : other, "race": data.rawValue]]
                }
            } else {
                parameters = ["profile": ["race" : data.rawValue]]
            }
            updateProfile(parameters: parameters!)
        case .height:
            //Height should always update height cm
            guard let data = height.value, let type = heightType.value else { return }
            parameters = ["profile": ["height_cm" : data * 2.54,
                                      "height_type": type.rawValue]]
            updateProfile(parameters: parameters!)
        case .language:
            guard let data = langauge.value else { return }
            parameters = ["profile": ["languages" : data]]
            updateProfile(parameters: parameters!)
        case .religion:
            guard let data = religion.value else { return }
            if data == .other {
                if let other = otherReligion.value, !other.isEmpty {
                    parameters = ["profile": ["other_religion" : other, "religion": data.rawValue]]
                }
            } else {
                parameters = ["profile": ["religion" : data.rawValue]]
            }
            updateProfile(parameters: parameters!)
        case .zodiac:
            guard let data = zodiac.value?.rawValue else { return }
            parameters = ["profile": ["zodiac" : data]]
            updateProfile(parameters: parameters!)
            return
        case .politics:
            guard let data = politics.value else { return }
            parameters = ["profile": ["political_stance" : data]]
            updateProfile(parameters: parameters!)
        case .location:
            var location = [String: Any]()
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
            parameters = ["location" : location]
            updateProfile(parameters: parameters!)
        case .ageRange:
            guard let ageMin = ageRange.value?.0,
                  let ageMax = ageRange.value?.1
            else { return }
            parameters = ["match_preferences": ["age_min" : ageMin, "age_max": ageMax]]
            updateProfile(parameters: parameters!)
        case .distance:
            guard let data = distance.value,
                  let type = distanceType.value
            else { return }
            parameters = ["match_preferences": ["max_distance": data, "distance_type": type.rawValue]]
            updateProfile(parameters: parameters!)
        case .gender:
            guard let data = gender.value?.rawValue else { return }
            parameters = isGenderPreference.value
                ? ["match_preferences": ["gender_pref" : data]]
                : ["profile": ["gender" : data]]
            updateProfile(parameters: parameters!)
        case .status:
            guard let data = status.value?.rawValue else { return }
            parameters = ["profile": ["marital_status" : data]]
            updateProfile(parameters: parameters!)
        case .datingPreference:
            guard let data = datingPreference.value?.rawValue else { return }
            parameters = ["match_preferences": ["relationship_pref" : data]]
            updateProfile(parameters: parameters!)
        case .kidsPreference:
            guard let data = kidsPreference.value?.rawValue else { return }
            parameters = ["match_preferences": ["family_pref" : data]]
            updateProfile(parameters: parameters!)
        case .haveKids:
            guard let data = haveKids.value?.rawValue else { return }
            parameters = ["profile": ["have_kids" : data]]
            updateProfile(parameters: parameters!)
            return
        case .smokingPrefence:
            parameters = ["match_preferences": ["smoking_pref" : smokingPreference.value.map { $0.rawValue }]]
            updateProfile(parameters: parameters!)
            return
        case .dringkingPrefence:
            return
        case .name:
            guard let fname = firstName.value,
                  let lname = lastName.value else { return }
            parameters = ["first_name": fname, "last_name": lname]
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
            self?.presentAlert.accept(("common.error".localized,
                                       "common.error.somethingWentWrong".localized))
        }).disposed(by: self.disposeBag)
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
    
    func getBooks(initialPage: Bool) {
        guard !isFetchingBooks.value else { return }
        var page = 1
        if !initialPage {
            guard let nextPage = booksNextPage.value else { return }
            page = nextPage
        }
        isFetchingBooks.accept(true)
        
        ApiProvider.shared.request(UserSettingsService.getBookList(page: page))
            .subscribe(onSuccess: { [weak self] res in
                guard let self = self else { return }
                let response = BookResponse(JSON(res))
                self.booksNextPage.accept(response.next)
                if page == 1 {
                    self.userBooks.accept(response.books)
                } else {
                    self.userBooks.append(contentsOf: response.books)
                }
                self.isFetchingBooks.accept(false)
        }, onError: { [weak self] err in
            self?.isFetchingBooks.accept(false)
        }).disposed(by: self.disposeBag)
    }
    
    func deleteBook(_ id: Int) {
        manageActivityIndicator.accept(true)
        ApiProvider.shared.request(UserSettingsService.deleteBook(id: id))
            .subscribe(onSuccess: { [weak self] res in
            self?.manageActivityIndicator.accept(false)
            self?.getBooks(initialPage: true)
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
    
    func uploadImage(_ image: UIImage) {
        guard let userID = MemCached.shared.userInfo?.id else { return }
        manageActivityIndicator.accept(true)
        ApiProvider.shared.request(UserServices.uploadProfilePicture(id: userID,
                                                                     image: image,
                                                                     caption: ""))
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
