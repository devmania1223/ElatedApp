//
//  Array+Extensions.swift
//  Elated
//
//  Created by John Lester Celis on 2/25/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {

    // Remove first collection element that is equal to the given `object`:
    mutating func remove(_ object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}

extension Array {
   func chunked(into size: Int) -> [[Element]] {
      return stride(from: 0, to: count, by: size).map {
      Array(self[$0 ..< Swift.min($0 + size, count)]) }
   }
}
