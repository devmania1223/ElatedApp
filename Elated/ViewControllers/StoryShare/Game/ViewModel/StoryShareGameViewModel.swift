//
//  StoryShareGameViewModel.swift
//  Elated
//
//  Created by Marlon on 10/7/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON
import Moya

class StoryShareGameViewModel: BaseViewModel {

    //"they", "them", "there", "their", "his", "her", "she",
    let staticWords = ["on", "in", "at", "and", "but", "nor", "either", "or",
                       "to", "it",  "he", "my", "your", "has", "have", "been",
                       "is", "are", "was", "were", "am", "had", "do", "does",
                       "did", "will", "would", "shall", "should", "may",
                       "might", "must", "can", "could", "the", "for", "yet",
                       "so", "as", "if", "i", "you", "a", "of"]
                    
    let detail = BehaviorRelay<StoryShareGameDetail?>(value: nil)
    let successBlockUser = PublishRelay<Void>()
    let successEndStoryShare = PublishRelay<Void>()
    let currentInput = BehaviorRelay<String?>(value: nil)
    let showDefinition = PublishRelay<BashoWordDefinition>()
    var isFromLineView = false

    override init() {
        super.init()
        
    }
    
    func getDefinition(_ word: String) {
        manageActivityIndicator.accept(true)
        guard let userID = MemCached.shared.userInfo?.id else { return }
        ApiProvider.shared.request(BashoService.getWordDefinition(userId: userID, word: word))
            .subscribe(onSuccess: { [weak self] res in
                guard let self = self else { return }
                self.manageActivityIndicator.accept(false)
                let response = GetBashoDefinitionResponse(JSON(res))
                if let definition = response.definition {
                    self.showDefinition.accept(definition)
                }
        }, onError: { [weak self] err in
            self?.manageActivityIndicator.accept(false)
            #if DEBUG
            print(err)
            #endif
        }).disposed(by: self.disposeBag)
    }
    
    func sendPhrase() {
        guard let phrase = currentInput.value else { return }
        manageActivityIndicator.accept(true)
        guard let id = self.detail.value?.id else { return }
        ApiProvider.shared.request(StoryShareService.sendPharse(id: id, phrase: phrase))
            .subscribe(onSuccess: { [weak self] res in
                self?.manageActivityIndicator.accept(false)
                let response = GetStoryShareResponse(JSON(res))
                if let detail = response.storyShare {
                    self?.detail.accept(detail)
                }
        }, onError: { [weak self] err in
            self?.manageActivityIndicator.accept(false)
            let json = JSON((err as? MoyaError)?.response?.data as Any)
            if let message = BasicResponse(json).msg, !message.isEmpty {
                self?.presentAlert.accept(("common.error".localized, message))
            } else {
                self?.presentAlert.accept(("common.error".localized, "common.somethingWentWrong".localized))
            }
            #if DEBUG
            print(err)
            #endif
        }).disposed(by: self.disposeBag)
    }
    
    func endGame() {
        manageActivityIndicator.accept(true)
        guard let id = self.detail.value?.id else { return }
        ApiProvider.shared.request(StoryShareService.cancel(id: id))
            .subscribe(onSuccess: { [weak self] res in
                self?.manageActivityIndicator.accept(false)
                self?.successEndStoryShare.accept(())
        }, onError: { [weak self] err in
            self?.manageActivityIndicator.accept(false)
            let json = JSON((err as? MoyaError)?.response?.data as Any)
            if let message = BasicResponse(json).msg, !message.isEmpty {
                self?.presentAlert.accept(("common.error".localized, message))
            } else {
                self?.presentAlert.accept(("common.error".localized, "common.somethingWentWrong".localized))
            }
            #if DEBUG
            print(err)
            #endif
        }).disposed(by: self.disposeBag)
    }
    
    func periodGame() {
        manageActivityIndicator.accept(true)
        guard let id = self.detail.value?.id else { return }
        ApiProvider.shared.request(StoryShareService.period(id: id))
            .subscribe(onSuccess: { [weak self] res in
                self?.manageActivityIndicator.accept(false)
                let response = GetStoryShareResponse(JSON(res))
                if let detail = response.storyShare {
                    self?.detail.accept(detail)
                }
        }, onError: { [weak self] err in
            self?.manageActivityIndicator.accept(false)
            let json = JSON((err as? MoyaError)?.response?.data as Any)
            if let message = BasicResponse(json).msg, !message.isEmpty {
                self?.presentAlert.accept(("common.error".localized, message))
            } else {
                self?.presentAlert.accept(("common.error".localized, "common.somethingWentWrong".localized))
            }
            #if DEBUG
            print(err)
            #endif
        }).disposed(by: self.disposeBag)
    }
    
    func blockUser() {
        guard let userID = MemCached.shared.userInfo?.id else { return }
        var blocked = 0
        if detail.value?.inviter?.id == userID {
            blocked = detail.value!.inviter?.id ?? 0
        } else {
            blocked = detail.value!.invitee?.id ?? 0
        }
        manageActivityIndicator.accept(true)
        ApiProvider.shared.request(BlockService.blockUser(blocker: userID, blocked: blocked))
            .subscribe(onSuccess: { [weak self] res in
                self?.manageActivityIndicator.accept(false)
                self?.successBlockUser.accept(())
        }, onError: { [weak self] err in
            self?.manageActivityIndicator.accept(false)
            #if DEBUG
            print(err)
            #endif
        }).disposed(by: self.disposeBag)
    }
    
}
