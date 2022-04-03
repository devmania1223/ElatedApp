//
//  ReviewSparkFlirtHistory.swift
//  Elated
//
//  Created by Marlon on 11/20/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SwiftyJSON

class ReviewerSparkFlirtHistory {
    
    let disposeBag = DisposeBag()
    let hasSuccessfulSparkFlirt = BehaviorRelay<Bool>(value: true)
    let lockImage = BehaviorRelay<UIImage?>(value: nil)
    let gameDetail = BehaviorRelay<Any?>(value: nil)

    private let db = FirebaseChat.shared.reference
    private let messages = BehaviorRelay<[FirebaseChatMessage]>(value: [])
    private let otherUser = BehaviorRelay<Int?>(value: nil)
    
    init(otherUserID: Int) {
        
        self.otherUser.accept(otherUserID)
        
        guard let myID = MemCached.shared.userInfo?.id else { return }
        
        let roomID = FirebaseChat.shared.createRoomId(invitee: myID,
                                                      inviter: otherUserID)
        
        db.child(FirebaseNodeType.chatMessage.rawValue).child(roomID).observe(.value) { snapShot in
            DispatchQueue.main.async {
                guard snapShot.value is [String: Any] else {
                    print(snapShot.value ?? "")
                    self.hasSuccessfulSparkFlirt.accept(false)
                    return
                }
                self.hasSuccessfulSparkFlirt.accept(true)
            }
        }
        
        self.gameDetail.subscribe(onNext: { [weak self] gameDetail in
            guard let gameDetail = gameDetail else { return }
            if let basho = gameDetail as? BashoGameDetail {
                self?.handleBashoGame(basho)
            } else if let storyShare = gameDetail as? StoryShareGameDetail {
                self?.handleStoryShareGame(storyShare)
            } else if let emojiGo = gameDetail as? EmojiGoGameDetail {
                self?.handleEmojiGoGame(emojiGo)
            }
        }).disposed(by: disposeBag)
        
        self.hasSuccessfulSparkFlirt.subscribe(onNext: { [weak self] hasOne in
            guard let self = self else { return }
            if hasOne {
                self.lockImage.accept(nil)
            }
        }).disposed(by: disposeBag)
        
    }
    
    private func handleBashoGame(_ detail: BashoGameDetail) {
        let lines =  detail.basho.count + 1 > 3 ? 2 : detail.basho.count + 1
        let haikuline = HaikuLine(rawValue: lines)!
        let image = hasSuccessfulSparkFlirt.value
                    ? UIImage(named: "asset-75px-chat-locked-\(haikuline.rawValue)")
                    : nil
        self.lockImage.accept(image)
    }
    
    private func handleStoryShareGame(_ detail: StoryShareGameDetail) {
        let count = detail.phrases.count > 4 ? 4 : detail.phrases.count
        let image = hasSuccessfulSparkFlirt.value
                    ? UIImage(named: "asset-75px-chat-locked-\(count)")
                    : nil
        self.lockImage.accept(image)
    }
    
    private func handleEmojiGoGame(_ detail: EmojiGoGameDetail) {
        let round = detail.round > 4 ? 4 : detail.round
        let image = hasSuccessfulSparkFlirt.value
                    ? UIImage(named: "asset-75px-chat-locked-\(round)")
                    : nil
        self.lockImage.accept(image)
    }
    
}
