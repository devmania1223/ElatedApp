//
//  StoryShareLoadingViewModel.swift
//  Elated
//
//  Created by Marlon on 10/9/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON

class StoryShareLoadingViewModel: BaseViewModel {

    let info = PublishRelay<StoryShareGameDetail>()

    func getInfo(_ id: Int) {
        manageActivityIndicator.accept(true)
        ApiProvider.shared.request(StoryShareService.getStoryShareByPath(id: id))
            .subscribe(onSuccess: { [weak self] res in
            self?.manageActivityIndicator.accept(false)
            let response = GetStoryShareResponse(JSON(res))
            if let storyShare = response.storyShare {
                self?.info.accept(storyShare)
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
