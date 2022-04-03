//
//  SparkFlirtCommonViewModel.swift
//  Elated
//
//  Created by Rey Felipe on 7/23/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Moya
import RxCocoa
import RxSwift
import SwiftyJSON


class SparkFlirtCommonViewModel: BaseViewModel {
    
    //TODO: Observe for future use
    let successNudge = PublishRelay<Void>()
    let receivedSparkFlirtDetails = PublishRelay<SparkFlirtDetail?>()
    
    func sendSparkFlirtInvite(_ match: Match, completion: ((Bool) -> Void)? = nil) {
        guard let userId = match.matchedWith?.userId else {
            completion?(false)
            return
        }
       
        ApiProvider.shared.request(SparkFlirtService.inviteSparkFlirtUser(id: userId))
            .subscribe(onSuccess: { res in
                completion?(true)
            }, onError: { [weak self] err in
                let json = JSON((err as? MoyaError)?.response?.data as Any)
                #if DEBUG
                print(err)
                #endif
                completion?(false)
                if let code = BasicResponse(json).code {
                    let message = LanguageManager.shared.errorMessage(for: code)
                    self?.presentAlert.accept(("", message))
                }
            }).disposed(by: self.disposeBag)
    }
    
    func sendGameNudge(gameData: Any) {
        var actionId = 0
        var otherUser = 0
        var game: Game = .basho
        
        switch gameData {
        case let gameDetail as GameDetail:
            guard let otherUserId = (MemCached.shared.isSelf(id: gameDetail.hostUser?.id) ? gameDetail.invitedUser?.id : gameDetail.hostUser?.id),
                  let gameTitle = gameDetail.game,
                  let gameId = gameDetail.detail?.id
            else { return }
            otherUser = otherUserId
            game = gameTitle
            actionId = gameId
        case let basho as BashoGameDetail:
            guard let otherUserId = (MemCached.shared.isSelf(id: basho.inviter?.id) ? basho.invitee?.id : basho.inviter?.id),
                  let gameId = basho.id
            else { return }
            otherUser = otherUserId
            game = .basho
            actionId = gameId
        case let emojiGo as EmojiGoGameDetail:
            guard let otherUserId = (MemCached.shared.isSelf(id: emojiGo.inviter?.id) ? emojiGo.invitee?.id : emojiGo.inviter?.id),
                  let gameId = emojiGo.id
            else { return }
            otherUser = otherUserId
            game = .emojigo
            actionId = gameId
        case let storyShare as StoryShareGameDetail:
            guard let otherUserId = (MemCached.shared.isSelf(id: storyShare.inviter?.id) ? storyShare.invitee?.id : storyShare.inviter?.id),
                  let gameId = storyShare.id
            else { return }
            otherUser = otherUserId
            game = .storyshare
            actionId = gameId
        default:
            return
        }
        
        manageActivityIndicator.accept(true)
        ApiProvider.shared.request(NotificationService.sendNudge(toUser: otherUser,
                                                                 nudge: .gameReminder,
                                                                 game: game,
                                                                 actionId: actionId))
            .subscribe(onSuccess: { [weak self] res in
                self?.manageActivityIndicator.accept(false)
                self?.successNudge.accept(())
                self?.presentAlert.accept(("common.sendNudge".localized, "common.sendNudge.message".localized))
        }, onError: { [weak self] err in
            self?.manageActivityIndicator.accept(false)
            
            #if DEBUG
            print(err)
            #endif
            
            let json = JSON((err as? MoyaError)?.response?.data as Any)
            if let code = BasicResponse(json).code {
                let message = LanguageManager.shared.errorMessage(for: code)
                self?.presentAlert.accept(("", message))
            }
            
        }).disposed(by: self.disposeBag)
    }
    
    func sendSparkFlirtNudge(info: SparkFlirtInfo) {
        guard let otherUser = info.invitedUser,
              let id = info.id else { return }
        manageActivityIndicator.accept(true)
        ApiProvider.shared.request(NotificationService.sendNudge(toUser: otherUser,
                                                                 nudge: .sparkFlirtInvite,
                                                                 game: nil,
                                                                 actionId: id))
            .subscribe(onSuccess: { [weak self] res in
                self?.manageActivityIndicator.accept(false)
                self?.successNudge.accept(())
                self?.presentAlert.accept(("common.sendNudge".localized, "common.sendNudge.message".localized))
        }, onError: { [weak self] err in
            self?.manageActivityIndicator.accept(false)
            
            #if DEBUG
            print(err)
            #endif
            
            let json = JSON((err as? MoyaError)?.response?.data as Any)
            if let code = BasicResponse(json).code {
                let message = LanguageManager.shared.errorMessage(for: code)
                self?.presentAlert.accept(("", message))
            }
        }).disposed(by: self.disposeBag)
    }
    
    func getSparkFlirtDetail(_ sparkFlirtId: Int) {
        manageActivityIndicator.accept(true)
        ApiProvider.shared.request(SparkFlirtService.getSparkFlirtDetail(id: sparkFlirtId))
            .subscribe(onSuccess: { [weak self] res in
                print(JSON(res))
                self?.manageActivityIndicator.accept(false)
                let response = SpartFlirtDetailResponse(JSON(res))
                self?.receivedSparkFlirtDetails.accept(response.data)
                
        }, onError: { [weak self] err in
            self?.manageActivityIndicator.accept(false)
            let json = JSON((err as? MoyaError)?.response?.data as Any)
            #if DEBUG
            print(err)
            #endif
            if let code = BasicResponse(json).code {
                let message = LanguageManager.shared.errorMessage(for: code)
                print(message)
                self?.presentAlert.accept(("", message))
            }
        }).disposed(by: self.disposeBag)
    }
    
}
