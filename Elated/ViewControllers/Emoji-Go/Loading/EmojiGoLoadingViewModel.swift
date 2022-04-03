//
//  EmojiGoLoadingViewModel.swift
//  Elated
//
//  Created by Marlon on 9/10/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON

class EmojiGoLoadingViewModel: BaseViewModel {

    let info = PublishRelay<EmojiGoGameDetail>()

    func getInfo(_ id: Int) {
        manageActivityIndicator.accept(true)
        ApiProvider.shared.request(EmojiGoService.getEmogigoDetails(id: id))
            .subscribe(onSuccess: { [weak self] res in
            self?.manageActivityIndicator.accept(false)
            let response = GetEmojiGoResponse(JSON(res))
            if let detail = response.emojiGo {
                self?.info.accept(detail)
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
