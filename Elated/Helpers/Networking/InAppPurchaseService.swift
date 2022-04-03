//
//  InAppPurchaseService.swift
//  Elated
//
//  Created by Rey Felipe on 8/30/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import Moya

enum InAppPurchaseService {
    case processTransaction(transactionId: String,
                            productId: String,
                            price: String,
                            receiptData: String)
}

extension InAppPurchaseService: TargetType {
    var baseURL: URL {
        return URL(string: Environment.rootURLString + "/api/v1/orders")!
    }
    
    var path: String {
        switch self {
        case .processTransaction(_, _, _, _):
            return "/fulfill_order/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .processTransaction:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case let .processTransaction(transactionId, productId, price, receiptData):
            return .requestParameters(parameters: ["payment_gateway": "APPLE",
                                                   "custom_product_id": productId,
                                                   "transaction_id": transactionId,
                                                   "metadata": ["receipt": receiptData,
                                                                "converted_price": price]],
                                      encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return NetworkManager.commonHeaders
    }
    
}

