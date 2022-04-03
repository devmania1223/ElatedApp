//
//  ProfileInterestViewModel.swift
//  Elated
//
//  Created by Marlon on 5/26/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON

class ProfileInterestViewModel: BaseViewModel {

    let userViewID = BehaviorRelay<Int?>(value: nil)
    let info = BehaviorRelay<String?>(value: nil)
    let nameAge = BehaviorRelay<String?>(value: nil)
    let likes = BehaviorRelay<[CommonDataModel]>(value: [])
    let dislikes = BehaviorRelay<[CommonDataModel]>(value: [])
    let images = BehaviorRelay<[ProfileImage]>(value: [])
    
    let books = BehaviorRelay<[Book]>(value: [])
    private let booksNextPage = BehaviorRelay<Int?>(value: nil)
    private let isFetchingBooks = BehaviorRelay<Bool>(value: false)

    let artists = BehaviorRelay<[SpotifyArtist]>(value: [])
    
    override init() {
        super.init()
    }
    
    func getProfile() {
        if let userId = userViewID.value {
            getUserProfile(user: userId)
        } else {
            setProfile(user: MemCached.shared.userInfo)
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
    
    private func setProfile(user: UserInfo?) {
        let user = MemCached.shared.userInfo
        
        let height = user?.profile?.heightFeet ?? ""
        let occupation = user?.profile?.occupation ?? ""
        let address = user?.location?.address ?? ""
        let info = "\(height) | \(occupation) | \(address)"
        self.info.accept(info)
        
        let nameAge = user?.getDisplayNameAge() ?? ""
        self.nameAge.accept(nameAge)
        
        if let images = user?.profileImages {
            self.images.accept(images)
        }
        
        let likes = (user?.profile?.likes ?? []).map { CommonDataModel(nil, title: $0) }
        let dislikes = (user?.profile?.dislikes ?? []).map { CommonDataModel(nil, title: $0) }
        self.likes.accept(likes)
        self.dislikes.accept(dislikes)
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
    
    func getMusic() {
        ApiProvider.shared.request(SpotifyService.getUserArtists(page: 1))
            .subscribe(onSuccess: { [weak self] res in
                //TODO:
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
