//
//  SparkFlirtQRCodeViewModel.swift
//  Elated
//
//  Created by Rey Felipe on 10/2/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Moya
import RxCocoa
import RxSwift
import SwiftyJSON


class SparkFlirtQRCodeViewModel: BaseViewModel {
    
    private let isValidatingQRCode = BehaviorRelay<Bool>(value: false)
    let success = PublishRelay<(Int)>()
    
    func claimQRCode(_ qrCode: String) {
        guard !isValidatingQRCode.value else { return }
        
        isValidatingQRCode.accept(true)
        manageActivityIndicator.accept(true)
        
        //TODO: update this endpoint once BE is done
        ApiProvider.shared.request(SparkFlirtService.getSparkFlirtsPuchaseHistory(page: 1))
            .subscribe(onSuccess: { [weak self] res in
                guard let self = self else { return }
                print(JSON(res))
                self.manageActivityIndicator.accept(false)
                //TODO: BE should return the number of SF invite credited
                self.success.accept((10))
                //self.isValidatingQRCode.accept(false)
        }, onError: { [weak self] err in
            self?.manageActivityIndicator.accept(false)
            self?.isValidatingQRCode.accept(false)
            let json = JSON((err as? MoyaError)?.response?.data as Any)
            #if DEBUG
            print(err)
            #endif
            if let code = BasicResponse(json).code {
                let message = LanguageManager.shared.errorMessage(for: code)
                //present alert triggers binding on the view controller, make sure its handled
                print(message)
                self?.presentAlert.accept(("", message))
            }
        }).disposed(by: self.disposeBag)
    }
    
    func isBusy() -> Bool {
        return isValidatingQRCode.value
    }
}
