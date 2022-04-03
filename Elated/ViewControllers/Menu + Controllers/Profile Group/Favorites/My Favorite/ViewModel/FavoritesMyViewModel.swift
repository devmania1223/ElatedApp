//
//  FavoritesMyVoewModel.swift
//  Elated
//
//  Created by Marlon on 6/20/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import RxSwift
import RxCocoa
import SwiftyJSON
import Moya

class FavoritesMyViewModel: BaseViewModel {

    let favorites = BehaviorRelay<[Match]>(value: [])
    private let favoritesNextPage = BehaviorRelay<Int?>(value: nil)
    private let isFetchingFavorites = BehaviorRelay<Bool>(value: false)

    override init() {
        super.init()
    }
    
    func getFavorites(initialPage: Bool) {
        guard !isFetchingFavorites.value else { return }
        var page = 1
        if !initialPage {
            guard let nextPage = favoritesNextPage.value else { return }
            page = nextPage
        }
        isFetchingFavorites.accept(true)
        
        ApiProvider.shared.request(MatchesService.getFavorites(page: page))
            .subscribe(onSuccess: { [weak self] res in
                guard let self = self else { return }
                let response = GetMatchesResponse(JSON(res))
                self.favoritesNextPage.accept(response.next)
                if page == 1 {
                    self.favorites.accept(response.data)
                } else {
                    self.favorites.append(contentsOf: response.data)
                }
                self.isFetchingFavorites.accept(false)
        }, onError: { [weak self] err in
            self?.isFetchingFavorites.accept(false)
        }).disposed(by: self.disposeBag)
    }
    
    func deleteFavorite(_ userId: Int) {
        self.manageActivityIndicator.accept(true)
        ApiProvider.shared.request(MatchesService.deleteFavorites(id: userId))
            .subscribe(onSuccess: { [weak self] res in
                guard let self = self else { return }
                self.manageActivityIndicator.accept(false)
                self.getFavorites(initialPage: true)
        }, onError: { [weak self] err in
            #if DEBUG
            print(err)
            #endif
            self?.manageActivityIndicator.accept(false)
        }).disposed(by: self.disposeBag)
    }
  
}
