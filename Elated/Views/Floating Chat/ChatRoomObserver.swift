//
//  ChatRoomObserver.swift
//  Elated
//
//  Created by Marlon on 11/22/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class ChatRoomObserver {

    static let shared = ChatRoomObserver()
    let reference: DatabaseReference = Database.database().reference()
    
}
