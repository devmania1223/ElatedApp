//
//  IAPurchaseViewModel.swift
//  Elated
//
//  Created by Rey Felipe on 8/23/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Moya
import RxCocoa
import RxSwift
import SwiftyJSON


class IAPurchaseViewModel: BaseViewModel {
    
    func processTransaction(transactionId: String,
                            productId: String,
                            price: String,
                            receiptData: String,
                            completion: ((Bool) -> Void)? = nil) {
        
        manageActivityIndicator.accept(true)
        print("InAppPurchaseService.processTransaction(\(transactionId), \(productId), \(price)")
        print("Receipt: \(receiptData)")
        
        ApiProvider.shared.request(InAppPurchaseService.processTransaction(transactionId: transactionId, productId: productId, price: price, receiptData: receiptData))
            .subscribe(onSuccess: { [weak self] res in
                self?.manageActivityIndicator.accept(false)
                completion?(true)
            }, onError: { [weak self] err in
                let json = JSON((err as? MoyaError)?.response?.data as Any)
                #if DEBUG
                print(err)
                #endif
                self?.manageActivityIndicator.accept(false)
                completion?(false)
                if let code = BasicResponse(json).code {
                    let message = LanguageManager.shared.errorMessage(for: code)
                    self?.presentAlert.accept(("", message))
                }
            }).disposed(by: self.disposeBag)
        
    }
    
}
