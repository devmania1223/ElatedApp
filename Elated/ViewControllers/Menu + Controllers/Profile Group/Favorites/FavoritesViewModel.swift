//
//  FavoritesViewModel.swift
//  Elated
//
//  Created by Rey Felipe on 7/12/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Moya
import RxCocoa
import RxSwift
import SwiftyJSON

class FavoritesViewModel: BaseViewModel {
    
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

