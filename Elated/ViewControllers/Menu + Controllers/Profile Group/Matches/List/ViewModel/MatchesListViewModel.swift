//
//  MatchesListViewModel.swift
//  Elated
//
//  Created by Marlon on 6/16/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON
import Moya

class MatchesListViewModel: BaseViewModel {

    let selectedItem = BehaviorRelay<Int>(value: 0)
    let type = BehaviorRelay<MatchType>(value: .best)
    let bestMatches = BehaviorRelay<[Match]>(value: [])
    let recentMatches = BehaviorRelay<[Match]>(value: [])

    override init() {
        super.init()
    }
    
    func getMatches() {
        self.manageActivityIndicator.accept(true)
        ApiProvider.shared.request(MatchesService.getMatches(page: 1))
            .subscribe(onSuccess: { [weak self] res in
                guard let self = self else { return }
                self.manageActivityIndicator.accept(false)
                let response = GetMatchesResponse(JSON(res))
                
                var recents = self.recentMatches.value
                var bestMatches = self.bestMatches.value
                recents.append(contentsOf: response.data.filter { $0.matchType == .recent })
                bestMatches.append(contentsOf: response.data.filter { $0.matchType == .best })

                self.recentMatches.accept(recents)
                self.bestMatches.accept(bestMatches)
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
    
    func deleteMatch(_ match: Match) {
        guard let id = match.id else {
            return
        }
        self.manageActivityIndicator.accept(true)
        ApiProvider.shared.request(MatchesService.updateMatchesPartial(id: id,
                                                                       state: MatchStateInt.rejected.rawValue))
            .subscribe(onSuccess: { [weak self] res in
                guard let self = self else { return }
                self.manageActivityIndicator.accept(false)
                self.getMatches()
        }, onError: { [weak self] err in
            #if DEBUG
            print(err)
            #endif
            self?.manageActivityIndicator.accept(false)
        }).disposed(by: self.disposeBag)
    }
    
    func setFavorite(_ userId:  Int) {
        self.manageActivityIndicator.accept(true)
        
        ApiProvider.shared.request(MatchesService.createFavorites(userID: userId))
            .subscribe(onSuccess: { [weak self] res in
                guard let self = self else { return }
                self.manageActivityIndicator.accept(false)
                self.getMatches()
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
