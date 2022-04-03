//
//  SparkFlirtSettingsBalanceViewModel.swift
//  Elated
//
//  Created by Marlon on 5/7/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Moya
import RxCocoa
import RxSwift
import SwiftyJSON


class SparkFlirtSettingsBalanceViewModel: BaseViewModel {
    
    let selectedPurchaseItem = BehaviorRelay<Int>(value: 0)
    let availableCredits = BehaviorRelay<Int>(value: 0)
    let purchases = BehaviorRelay<[SparkFlirtPurchaseData]>(value: [])
    private let purchasesNextPage = BehaviorRelay<Int?>(value: nil)
    private let isFetchingPurchases = BehaviorRelay<Bool>(value: false)
    
    func getSparkFlirtAvailableCredit() {
        self.manageActivityIndicator.accept(true)
        ApiProvider.shared.request(SparkFlirtService.getUnusedSparkFlirt)
            .subscribe(onSuccess: { [weak self] res in
                self?.manageActivityIndicator.accept(false)
                let response = SparkFlirtCreditsResponse(JSON(res))
                self?.availableCredits.accept(response.credits)
        }, onError: { [weak self] err in
            self?.manageActivityIndicator.accept(false)
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

    func getSparkFlirtPurchaseHistory(initialPage: Bool = false) {
        guard !isFetchingPurchases.value else { return }
        var page = 1
        if !initialPage {
            guard let nextPage = purchasesNextPage.value else { return }
            page = nextPage
        }
        isFetchingPurchases.accept(true)
        
        if page == 1 {
            manageActivityIndicator.accept(true)
        }
        
        ApiProvider.shared.request(SparkFlirtService.getSparkFlirtsPuchaseHistory(page: page))
            .subscribe(onSuccess: { [weak self] res in
                guard let self = self else { return }
                self.manageActivityIndicator.accept(false)
                let response = SparkFlirtPurchaseHistoryResponse(JSON(res))
                self.purchasesNextPage.accept(response.next)
                if page == 1 {
                    self.purchases.accept(response.data)
                } else {
                    self.purchases.append(contentsOf: response.data)
                }
                self.isFetchingPurchases.accept(false)
                print(response)
        }, onError: { [weak self] err in
            self?.manageActivityIndicator.accept(false)
            self?.isFetchingPurchases.accept(false)
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
}
