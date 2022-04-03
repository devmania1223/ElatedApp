//
//  StoryShareColorPickerViewModel.swift
//  Elated
//
//  Created by Marlon on 10/10/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya
import SwiftyJSON

class StoryShareColorPickerViewModel: BaseViewModel {

    let colorSelected = BehaviorRelay<StoryShareColor?>(value: nil)

    let detail = BehaviorRelay<StoryShareGameDetail?>(value: nil)
    let successSettingColor = PublishRelay<Void>()

    func setColor() {
        manageActivityIndicator.accept(true)
        guard let id = self.detail.value?.id,
              let color = colorSelected.value?.rawValue
        else { return }
        ApiProvider.shared.request(StoryShareService.sendColor(id: id, color: color))
            .subscribe(onSuccess: { [weak self] res in
                self?.manageActivityIndicator.accept(false)
                self?.successSettingColor.accept(())
        }, onError: { [weak self] err in
            self?.manageActivityIndicator.accept(false)
            let json = JSON((err as? MoyaError)?.response?.data as Any)
            if let message = BasicResponse(json).msg, !message.isEmpty {
                self?.presentAlert.accept(("common.error".localized, message))
            } else {
                self?.presentAlert.accept(("common.error".localized, "common.somethingWentWrong".localized))
            }
            #if DEBUG
            print(err)
            #endif
        }).disposed(by: self.disposeBag)
    }
    
}
