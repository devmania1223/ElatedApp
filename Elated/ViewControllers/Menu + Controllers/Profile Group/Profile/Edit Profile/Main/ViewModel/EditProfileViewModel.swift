//
//  EditProfileViewModel.swift
//  Elated
//
//  Created by Marlon on 3/25/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import RxSwift
import RxCocoa
import Moya
import SwiftyJSON

class EditProfileViewModel: BaseViewModel {
    
    let user = BehaviorRelay<UserInfo?>(value: MemCached.shared.userInfo)
    let nameAge = BehaviorRelay<String>(value: "")
    let quickFacts = BehaviorRelay<[(String, String)]>(value: [])
    let bio = BehaviorRelay<String>(value: "")
    let likes = BehaviorRelay<[CommonDataModel]>(value: [])
    let dislikes = BehaviorRelay<[CommonDataModel]>(value: [])
    let images = BehaviorRelay<[ProfileImage]>(value: [])
    
    //Books
    let books = BehaviorRelay<[Book]>(value: [])
    private let booksNextPage = BehaviorRelay<Int?>(value: nil)
    private let isFetchingBooks = BehaviorRelay<Bool>(value: false)

    let artists = BehaviorRelay<[SpotifyArtist]>(value: [])

    //Instagram
    let showInstagramAuth = PublishRelay<Bool>()
    
    enum QuickFacts: Int {
        case birthday
        case height
        case occupation
        case education
        case language
        case religion
        case zodiac
        case location
        case ageRange
        case distance
        case gender
        case race
        case status
        case datingPreference
        case kids
        case kidPreference
        case smokingPreference
        //case dringkingPreference

        func title() -> String {
            
            switch self {
            case .birthday:
                return "profile.editProfile.quickFacts.birthday".localized
            case .height:
                return "profile.editProfile.quickFacts.height".localized
            case .occupation:
                return "profile.editProfile.quickFacts.occupation".localized
            case .education:
                return "profile.editProfile.quickFacts.education".localized
            case .language:
                return "profile.editProfile.quickFacts.language".localized
            case .religion:
                return "profile.editProfile.quickFacts.religion".localized
            case .zodiac:
                return "profile.editProfile.quickFacts.zodiac".localized
            case .location:
                return "profile.editProfile.quickFacts.location".localized
            case .ageRange:
                return "profile.editProfile.quickFacts.ageRange".localized
            case .distance:
                return "profile.editProfile.quickFacts.distance".localized
            case .gender:
                return "profile.editProfile.quickFacts.gender".localized
            case .race:
                return "profile.editProfile.quickFacts.race".localized
            case .status:
                return "profile.editProfile.quickFacts.status".localized
            case .datingPreference:
                return "profile.editProfile.quickFacts.datingPreference".localized
            case .kids:
                return "profile.editProfile.quickFacts.kids".localized
            case .kidPreference:
                return "profile.editProfile.quickFacts.kidPreference".localized
            case .smokingPreference:
                return "profile.editProfile.quickFacts.smokingPreference".localized
//            case .dringkingPreference:
//                return "profile.editProfile.quickFacts.dringkingPreference".localized
            }
            
        }

    }
    
    override init() {
        super.init()
        
        user.subscribe(onNext: { [weak self] arg in
            guard let user = arg, let self = self else { return }
            
            self.nameAge.accept(user.getDisplayNameAge())
            self.images.accept(user.profileImages)
            
            var language = ""
            if let languages = user.profile?.languages {
                language = languages.joined(separator: ", ")
            }
            
            let raceDisplay = user.profile?.race == .other
                ? (user.profile?.otherRace ?? "")
                : user.profile?.race?.getName() ?? ""
            
            var smokePref = ""
            if let smoking = user.matchPreferences?.smokePref {
                for sm in smoking {
                    smokePref += " " + sm.getName()
                }
            }
            
            let distanceType = user.matchPreferences?.distanceType?.getAbbreviation().capitalized ?? ""
            
            let profile = user.profile
            let location = user.location
            let height =  profile?.heightType == .cm ? String(format: "%.2f", profile?.heightCm ?? 80) : profile?.heightFeet
            let matchPreferences = user.matchPreferences

            let likes = (user.profile?.likes ?? []).map { CommonDataModel(nil, title: $0) }
            let dislikes = (user.profile?.dislikes ?? []).map { CommonDataModel(nil, title: $0) }
            let religion = profile?.religion == Religion.none
                                ? "religion.spiritual".localized
                                : profile?.religion == .other
                                    ? (profile?.otherReligion ?? "")
                                    : (profile?.religion?.rawValue ?? "")
            let quickFacts : [(String, String)] = [(QuickFacts.birthday.title(), (profile?.birthdate ?? "").stringToBdayDateToReadable()),
                                            (QuickFacts.height.title(), height ?? ""),
                                            (QuickFacts.occupation.title(), profile?.occupation ?? ""),
                                            (QuickFacts.education.title(), profile?.college ?? ""),
                                            (QuickFacts.language.title(), language),
                                            (QuickFacts.religion.title(), religion.capitalized),
                                            (QuickFacts.zodiac.title(), profile?.zodiac?.rawValue ?? ""),
                                            (QuickFacts.location.title(), location?.address ?? ""),
                                            (QuickFacts.ageRange.title(), "\(matchPreferences?.ageMin ?? 0) - \(matchPreferences?.ageMax ?? 0)"),
                                            (QuickFacts.distance.title(), "\(matchPreferences?.maxDistance ?? 0) \(distanceType)"),
                                            (QuickFacts.gender.title(), profile?.gender?.getName() ?? ""),
                                            (QuickFacts.race.title(), raceDisplay),
                                            (QuickFacts.status.title(), profile?.maritalStatus?.getName() ?? ""),
                                            (QuickFacts.datingPreference.title(), matchPreferences?.relationshipPref?.getName() ?? ""),
                                            (QuickFacts.kids.title(), profile?.haveKids?.getName() ?? ""),
                                            (QuickFacts.kidPreference.title(), matchPreferences?.familyPref?.getName() ?? ""),
                                            (QuickFacts.smokingPreference.title(), smokePref)]
            
            
            self.likes.accept(likes)
            self.dislikes.accept(dislikes)
            self.quickFacts.accept(quickFacts)
            self.bio.accept(user.profile?.bio ?? "")
            
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
    
    func removeLikes(likes: [String]) {
        self.manageActivityIndicator.accept(true)
        ApiProvider.shared.request(UserSettingsService.removeLikes(likes: likes))
            .subscribe(onSuccess: { [weak self] res in
            self?.manageActivityIndicator.accept(false)
        }, onError: { [weak self] err in
            self?.manageActivityIndicator.accept(false)
        }).disposed(by: self.disposeBag)
    }
    
    func removedislikes(likes: [String]) {
        self.manageActivityIndicator.accept(true)
        ApiProvider.shared.request(UserSettingsService.removeDislikes(dislikes: likes))
            .subscribe(onSuccess: { [weak self] res in
            self?.manageActivityIndicator.accept(false)
        }, onError: { [weak self] err in
            self?.manageActivityIndicator.accept(false)
        }).disposed(by: self.disposeBag)
    }
    
    func deleteImage(_ id: Int) {
        manageActivityIndicator.accept(true)
        ApiProvider.shared.request(UserServices.deleteProfileImage(id: id))
            .subscribe(onSuccess: { [weak self] res in
            self?.manageActivityIndicator.accept(false)
            self?.getProfile()
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
    
    func swapImagePositions(imageId: Int, newPosition: Int) {
        manageActivityIndicator.accept(true)
        ApiProvider.shared.request(UserServices.swapImagePositions(imageId: imageId, newPosition: newPosition))
            .subscribe(onSuccess: { [weak self] res in
            self?.manageActivityIndicator.accept(false)
            self?.getProfile()
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
                    self.books.accept(response.books)
                } else {
                    self.books.append(contentsOf: response.books)
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
    
    func getMusic() {
        ApiProvider.shared.request(SpotifyService.getUserArtists(page: 1))
            .subscribe(onSuccess: { [weak self] res in
                //TODO:
        }).disposed(by: self.disposeBag)
    }
    
    func getInstagramUsername() {
        manageActivityIndicator.accept(true)
        ApiProvider.shared.request(InstagramAuthService.getUsername)
            .subscribe(onSuccess: { [weak self] res in
            self?.manageActivityIndicator.accept(false)
            self?.showInstagramAuth.accept(false)
        }, onError: { [weak self] err in
            self?.manageActivityIndicator.accept(false)
            self?.showInstagramAuth.accept(true)
        }).disposed(by: self.disposeBag)
    }
    
    func getArtist() {
        ApiProvider.shared.request(SpotifyThirdPartyAuthService.getArtists)
            .subscribe(onSuccess: { [weak self] res in
                let response = GetSpotifyArtistsResponse(JSON(res))
                self?.manageActivityIndicator.accept(false)
                self?.artists.accept(response.data)
        }, onError: { [weak self] err in
            self?.manageActivityIndicator.accept(false)
        }).disposed(by: self.disposeBag)
    }
    
}
