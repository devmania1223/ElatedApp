//
//  EditMusciViewModel.swift
//  Elated
//
//  Created by Marlon on 7/8/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON
import Moya

class EditMusicViewModel: EditProfileCommonViewModel {

    let spotifyAccountFound = BehaviorRelay<Bool>(value: false)
    let artists = BehaviorRelay<[SpotifyArtist]?>(value: nil)

    override init() {
        super.init()
    }
    
    func findProfile() {
        self.manageActivityIndicator.accept(true)
        ApiProvider.shared.request(SpotifyThirdPartyAuthService.getProfile)
            .subscribe(onSuccess: { [weak self] res in
                self?.manageActivityIndicator.accept(false)
                self?.spotifyAccountFound.accept(true)
        }, onError: { [weak self] err in
            self?.manageActivityIndicator.accept(false)
            self?.spotifyAccountFound.accept(false)
        }).disposed(by: self.disposeBag)
    }
    
    func loginUser(accessToken: String) {
        self.manageActivityIndicator.accept(true)
        ApiProvider.shared.request(SpotifyThirdPartyAuthService.register(token: accessToken))
            .subscribe(onSuccess: { [weak self] res in
                self?.manageActivityIndicator.accept(false)
                self?.spotifyAccountFound.accept(true)
        }, onError: { [weak self] err in
            self?.manageActivityIndicator.accept(false)
            self?.spotifyAccountFound.accept(false)
            let json = JSON((err as? MoyaError)?.response?.data as Any)
            #if DEBUG
            print(err)
            #endif
            let response = BasicResponse(json)
            if let code = response.code {
                let message = LanguageManager.shared.errorMessage(for: code)
                self?.presentAlert.accept(("", message))
            } else {
                self?.presentAlert.accept(("common.error".localized, "common.error.somethingWentWrong".localized))
            }
        }).disposed(by: self.disposeBag)
    }
    
    func getArtist() {
        self.manageActivityIndicator.accept(true)
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
