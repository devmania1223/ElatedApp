//
//  UserProfileViewModel.swift
//  Elated
//
//  Created by Rey Felipe on 11/4/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Moya
import SwiftyJSON

class UserProfileViewModel: BaseViewModel {
    
    func firstTimeEvent(eventType: FirstTimeEvent) {
        // This is a call and forget endpoint call
        ApiProvider.shared.request(UserServices.firstTimeEvent(eventType: eventType.rawValue))
            .subscribe(onSuccess: { res in
            // Do nothing
            print(JSON(res))
            print("1st time event called")
        }, onError: { [weak self] err in
            let json = JSON((err as? MoyaError)?.response?.data as Any)
            #if DEBUG
            print(err)
            #endif
            if let code = BasicResponse(json).code {
                let message = LanguageManager.shared.errorMessage(for: code)
                //present alert triggers binding on the view controller, make sure its handled
                self?.presentAlert.accept(("", message))
            }
        }).disposed(by: self.disposeBag)
    }
    
}
