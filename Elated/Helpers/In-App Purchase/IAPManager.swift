//
//  IAPManager.swift
//  Elated
//
//  Created by Rey Felipe on 8/18/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import StoreKit

final class IAPManager: NSObject {
    static let shared = IAPManager()
    
    var products =  [SKProduct]()
    let viewModel = IAPurchaseViewModel()
    
    enum Product: String, CaseIterable {
        case sfInviteCredit1 = "sparkflirt.invite.credit.1"
        case sfInviteCredit3 = "sparkflirt.invite.credit.3"
        case sfInviteCredit5 = "sparkflirt.invite.credit.5"
        case sfInviteCredit10 = "sparkflirt.invite.credit.10"
        
        var credits: Int {
            switch self {
            case .sfInviteCredit1: return 1
            case .sfInviteCredit3: return 3
            case .sfInviteCredit5: return 5
            case .sfInviteCredit10: return 10
            }
        }
    }
    
    var purchaseCompleteHandler: ((String) -> Void)?
    
    public func fetchProducts() {
        let request = SKProductsRequest(productIdentifiers: Set(Product.allCases.compactMap( { $0.rawValue } )))
        request.delegate = self
        request.start()
    }
    
    public func purchase(product: String) {
        guard SKPaymentQueue.canMakePayments() else {
            UIApplication.topViewController()?.presentAlert(
              title: "common.error".localized,
              message: "inapp.purchase.device.not.allowed".localized,
              completion: nil)
            return
        }
        
        guard let storeKitProduct = products.first(where: { $0.productIdentifier == product } ) else { return }
        
        let paymentRequest = SKPayment(product: storeKitProduct)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(paymentRequest)
    }
    
    private func getReceiptString() -> String? {
        if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
            FileManager.default.fileExists(atPath: appStoreReceiptURL.path) {

            do {
                let receiptData = try Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
                let receiptString = receiptData.base64EncodedString(options: [])
                return receiptString
            } catch {
                print("Couldn't read receipt data with error: " + error.localizedDescription)
            }
        }
        return nil
    }
}

extension IAPManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("IAP Product Count: \(response.products.count)")
        self.products = response.products
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        //TODO: REY clean this later, once IAP is tested on actual device
        print("Failed to load list of products.")
        print("Error: \(error.localizedDescription)")
    }
}

extension IAPManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach({
            switch $0.transactionState {
            case .deferred, .failed, .purchasing:
                print("In-App Purchase Failed")
                break
            case .purchased:
                let transaction = $0
                let productId = transaction.payment.productIdentifier
                let storeKitProduct = products.first(where: { $0.productIdentifier == productId })
                let price = storeKitProduct?.localizedPrice ?? ""
                guard let transactionId = transaction.transactionIdentifier else { return }
                let receiptData = getReceiptString() ?? ""
                //Process transaction to BE, is successful call finishTransaction,
                viewModel.processTransaction(transactionId: transactionId,
                                             productId: productId,
                                             price: price,
                                             receiptData: receiptData) { success in
                        guard success else { return }
                        SKPaymentQueue.default().finishTransaction(transaction)
                        SKPaymentQueue.default().remove(self)
                        self.purchaseCompleteHandler?(productId)
                }
                
                break
            case .restored:
                break
            @unknown default:
                break
            }
        })
    }
}
