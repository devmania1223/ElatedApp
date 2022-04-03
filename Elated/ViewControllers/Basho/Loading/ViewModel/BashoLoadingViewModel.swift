//
//  BashoLoadingViewModel.swift
//  Elated
//
//  Created by Marlon on 4/13/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import RxCocoa
import RxSwift
import SwiftyJSON
import Moya

class BashoLoadingViewModel: BaseViewModel {

    let info = PublishRelay<BashoGameDetail>()

    func getInfo(_ id: Int) {
        manageActivityIndicator.accept(true)
        ApiProvider.shared.request(BashoService.getBashoByPath(id: id))
            .subscribe(onSuccess: { [weak self] res in
            self?.manageActivityIndicator.accept(false)
            let response = GetBashoResponse(JSON(res))
            if let basho = response.basho {
                self?.info.accept(basho)
            } else {
                //keep trying
                self?.getInfo(id)
            }
        }, onError: { [weak self] err in
            self?.manageActivityIndicator.accept(false)
            //keep trying
            self?.getInfo(id)
            #if DEBUG
            print(err)
            #endif
        }).disposed(by: self.disposeBag)
    }
    
}
