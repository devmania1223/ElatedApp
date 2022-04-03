//
//  UserManager.swift
//  Elated
//
//  Created by John Lester Celis on 3/11/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class MemCached {
    
    static let shared = MemCached()
    
    var userInfo: UserInfo?
    
    func isSelf(id: Int?) -> Bool {
        return userInfo?.id == id
    }
        
}
