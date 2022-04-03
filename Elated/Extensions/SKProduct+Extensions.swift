//
//  SKProduct+Extensions.swift
//  Elated
//
//  Created by Rey Felipe on 8/18/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//
// Reference: https://bendodson.com/weblog/2014/12/10/skproduct-localized-price-in-swift/

import StoreKit

extension SKProduct {
    
    var localizedPrice: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)
    }

}
