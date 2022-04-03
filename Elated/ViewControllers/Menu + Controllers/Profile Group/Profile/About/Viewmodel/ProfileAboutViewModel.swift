//
//  ProfileAboutViewModel.swift
//  Elated
//
//  Created by Marlon on 5/22/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya
import SwiftyJSON

class ProfileAboutViewModel: BaseViewModel {

    let userViewID = BehaviorRelay<Int?>(value: nil)
    let bio = BehaviorRelay<String?>(value: nil)
    let info = BehaviorRelay<String?>(value: nil)
    let nameAge = BehaviorRelay<String?>(value: nil)
    let quickInfo = BehaviorRelay<[CommonDataModel]>(value: [])
    let images = BehaviorRelay<[ProfileImage]>(value: [])

    override init() {
        super.init()
    }
    
    func getProfile() {
        if let userId = userViewID.value {
            getUserProfile(user: userId)
        } else if let user = MemCached.shared.userInfo {
            setProfile(user: user)
        }
    }
    
    private func getUserProfile(user: Int) {
        ApiProvider.shared.request(UserServices.getUsersByPath(id: user))
            .subscribe(onSuccess: { [weak self] res in
                let response = GetUserInfoResponse(JSON(res))
                if let user = response.user {
                    self?.setProfile(user: user)
                }
        }, onError: { [weak self] err in
            #if DEBUG
                print(err)
            #endif
            //keep trying
            self?.getUserProfile(user: user)
        }).disposed(by: self.disposeBag)
    }
    
    private func setProfile(user: UserInfo) {
        
        bio.accept(user.profile?.bio)
        
        let height = user.profile?.heightFeet ?? ""
        let occupation = user.profile?.occupation ?? ""
        let address = user.location?.address ?? ""
        let info = "\(height) | \(occupation) | \(address)"
        self.info.accept(info)
        
        let nameAge = user.getDisplayNameAge()
        self.nameAge.accept(nameAge)
        self.images.accept(user.profileImages)
        
        var quickFacts = [CommonDataModel]()
        if let religion = user.profile?.religionDisplay, !religion.isEmpty {
            quickFacts.append(CommonDataModel(#imageLiteral(resourceName: "icon-religion"), title: religion == "NONE"
                                                ? "religion.spiritual".localized
                                                : religion.capitalized))
        }
        if let college = user.profile?.college, !college.isEmpty {
            quickFacts.append(CommonDataModel(#imageLiteral(resourceName: "icon-education"), title: college))
        }
        if let occupation = user.profile?.occupation, !occupation.isEmpty {
            quickFacts.append(CommonDataModel(#imageLiteral(resourceName: "icon-work"), title: occupation))
        }
        if let race = user.profile?.raceDisplay {
            let enumRace = Race(rawValue: race)?.getName()
            quickFacts.append(CommonDataModel(#imageLiteral(resourceName: "icon-group"), title: enumRace != nil
                                                ? enumRace ?? ""
                                                : race))
        }
        if let languages = user.profile?.languages,
           languages.count > 0 {
            let all = languages.joined(separator: ", ")
            quickFacts.append(CommonDataModel(#imageLiteral(resourceName: "icon-language"), title: all))
        }
        if let zodiac = user.profile?.zodiac {
            let image = UIImage(named: zodiac.getIconName())
            quickFacts.append(CommonDataModel(image, title: zodiac.rawValue.capitalized))
        }
        self.quickInfo.accept(quickFacts)
        
    }
    
}
                                                                                    
