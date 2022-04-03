//
//  FavoritesFavedViewModel.swift
//  Elated
//
//  Created by Marlon on 6/20/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import RxSwift
import RxCocoa
import SwiftyJSON
import Moya

class FavoritesFavedViewModel: BaseViewModel {

    let fans = BehaviorRelay<[Match]>(value: [])
    private let fansNextPage = BehaviorRelay<Int?>(value: nil)
    private let isFetchingFans = BehaviorRelay<Bool>(value: false)

    override init() {
        super.init()
    }
    
    func getFans(initialPage: Bool) {
        guard !isFetchingFans.value else { return }
        var page = 1
        if !initialPage {
            guard let nextPage = fansNextPage.value else { return }
            page = nextPage
        }
        isFetchingFans.accept(true)
        
        ApiProvider.shared.request(MatchesService.getFans(page: page))
            .subscribe(onSuccess: { [weak self] res in
                guard let self = self else { return }
                let response = GetMatchesResponse(JSON(res))
                self.fansNextPage.accept(response.next)
                if page == 1 {
                    self.fans.accept(response.data)
                } else {
                    self.fans.append(contentsOf: response.data)
                }
                self.isFetchingFans.accept(false)
        }, onError: { [weak self] err in
            self?.isFetchingFans.accept(false)
        }).disposed(by: self.disposeBag)
    }
    
    func setFavorite(_ userId:  Int) {
        self.manageActivityIndicator.accept(true)
        ApiProvider.shared.request(MatchesService.createFavorites(userID: userId))
            .subscribe(onSuccess: { [weak self] res in
                guard let self = self else { return }
                self.manageActivityIndicator.accept(false)
        }, onError: { [weak self] err in
            let json = JSON((err as? MoyaError)?.response?.data as Any)
            #if DEBUG
            print(err)
            #endif
            self?.manageActivityIndicator.accept(false)
            if let code = BasicResponse(json).code {
                let message = LanguageManager.shared.errorMessage(for: code)
                self?.presentAlert.accept(("", message))
            }
        }).disposed(by: self.disposeBag)
    }
  
}
