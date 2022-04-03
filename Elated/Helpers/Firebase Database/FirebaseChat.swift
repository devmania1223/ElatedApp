//
//  FirebaseChat.swift
//  Elated
//
//  Created by Marlon on 10/28/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import FirebaseDatabase
import Firebase

enum FirebaseNodeType: String {
    case chatRoom = "chat-rooms"
    case chatMessage = "chat-message"
    case userRoom = "user-room"
    case user = "user"
    case storagePhoto = "chat-photo"
    case storageVideo = "chat-video"
}

class FirebaseChat {
    
    static let shared = FirebaseChat()
    let reference: DatabaseReference = Database.database().reference()
    
    func createRoomId(invitee: Int, inviter: Int) -> String {
        let lesser = invitee < inviter ? invitee : inviter
        let greater = invitee > inviter ? invitee : inviter
        return "\(lesser)-\(greater)"
    }
    
    func createChatRoom(invitee: Int, inviter: Int) {
        let id = createRoomId(invitee: invitee, inviter: inviter)
        reference.child(FirebaseNodeType.chatRoom.rawValue)
            .child(id)
            .setValue(["id": id,
                       "invitee": invitee,
                       "inviter": inviter,
                       "created": Date().chatTimestamp,
                       "updated": Date().chatTimestamp])
    }
    
    func updateChatRoomUpdated(id: String, lastChat: String) {
        reference.child(FirebaseNodeType.chatRoom.rawValue)
            .child(id)
            .updateChildValues(["updated": Date().chatTimestamp,
                                "last_chat": lastChat])
    }
    
    func sendText(chatRoom: String, message: String) {
        let ref = reference.child(FirebaseNodeType.chatMessage.rawValue).child(chatRoom).childByAutoId()
        let newData : [String: Any] = ["id": ref.key ?? "",
                                       "message": message,
                                       "image": "",
                                       "created": Date().chatTimestamp,
                                       "updated": Date().chatTimestamp,
                                       "isImage": false,
                                       "isDeleted": false,
                                       "sender": MemCached.shared.userInfo?.id ?? 0]
        ref.setValue(newData)
        updateChatRoomUpdated(id: chatRoom, lastChat: message)
    }
    
    func sendImage(chatRoom: String, callback: ((String?) -> Void)? = nil) {
        let ref = reference.child(FirebaseNodeType.chatMessage.rawValue).child(chatRoom).childByAutoId()
        let newData : [String: Any] = ["id": ref.key ?? "",
                                       "message": "",
                                       "image": "",
                                       "created": Date().chatTimestamp,
                                       "updated": Date().chatTimestamp,
                                       "isImage": true,
                                       "isDeleted": false,
                                       "sender": MemCached.shared.userInfo?.id ?? 0]
        ref.setValue(newData)
        updateChatRoomUpdated(id: chatRoom, lastChat: "chat.image.default.message".localized)
        callback?(ref.key)
    }
    
    func updateImageURL(chatRoom: String, key: String, image: String) {
        let ref = reference.child(FirebaseNodeType.chatMessage.rawValue).child(chatRoom).child(key)
        ref.updateChildValues(["updated": Date().chatTimestamp,
                               "image": image])
        updateChatRoomUpdated(id: chatRoom, lastChat: "chat.image.default.message".localized)
    }
    
    func updateMyOnlineStatus(id: Int, isOnline: Bool) {
        reference.child(FirebaseNodeType.user.rawValue)
            .child("\(id)")
            .updateChildValues(["updated": Date().chatTimestamp,
                                "online": isOnline,
                                "id": id])
    }
    
    func deleteMessage(chatRoom: String, key: String) {
        let ref = reference.child(FirebaseNodeType.chatMessage.rawValue).child(chatRoom).child(key)
        ref.updateChildValues(["updated": Date().chatTimestamp,
                               "isDeleted": true])
        updateChatRoomUpdated(id: chatRoom, lastChat: "chat.message.deleted".localized)
    }
    
}
