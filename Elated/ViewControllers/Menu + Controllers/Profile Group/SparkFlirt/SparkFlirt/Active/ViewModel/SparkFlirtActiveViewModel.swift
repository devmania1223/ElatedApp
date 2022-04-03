//
//  SparkFlirtActiveViewModel.swift
//  Elated
//
//  Created by Rey Felipe on 7/7/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Moya
import RxCocoa
import RxSwift
import SwiftyJSON

class SparkFlirtActiveViewModel: SparkFlirtCommonViewModel {
    
    let games = BehaviorRelay<[GameDetail]>(value: [])
    
    override init() {
        super.init()
    }
    
    func getGames() {
        //TODO: Add pagination
        manageActivityIndicator.accept(true)
        ApiProvider.shared.request(SparkFlirtService.getGames(status: [.active]))
            .subscribe(onSuccess: { [weak self] res in
            self?.manageActivityIndicator.accept(false)
            let response = GetGamesResponse(JSON(res))
            self?.games.accept(response.games)
        }, onError: { [weak self] err in
            self?.manageActivityIndicator.accept(false)
            #if DEBUG
            print(err)
            #endif
        }).disposed(by: self.disposeBag)
    }
    
}
