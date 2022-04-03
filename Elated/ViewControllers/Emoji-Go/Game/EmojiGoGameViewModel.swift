//
//  EmojiGoGameViewModel.swift
//  Elated
//
//  Created by Marlon on 9/3/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON
import Moya

class EmojiGoGameViewModel: BaseViewModel {
    
    let successBlockUser = PublishRelay<Void>()
    let successEndEmojiGo = PublishRelay<Void>()
    let timesUpEmojiGo  = PublishRelay<Void>()
    let turnSkipped = PublishRelay<Void>()
    let turnDenied = PublishRelay<Void>()
    let currentTime = BehaviorRelay<Int>(value: 15)
    let detail = BehaviorRelay<EmojiGoGameDetail?>(value: nil)
    let questions = BehaviorRelay<[EmojiGoQuestion]>(value: [])
    var earnedPopupKeyboardShowed = false //show only once

    //get updated EmojiGo details every 5secs
    var turnTimer: Timer?
    
    var tutorialMode: Bool = false
    
    convenience init(tutorialMode: Bool) {
        self.init()
        self.tutorialMode = tutorialMode
    }
    
    override init() {
        super.init()
        
        detail.subscribe(onNext: { [weak self] detail in
            guard let self = self,
                  let detail = detail,
                  !self.tutorialMode
            else { return }
            
            if MemCached.shared.isSelf(id: detail.currentPlayerTurn)
                && detail.turnType == .question {
                self.getQuestion()
                self.turnTimer?.invalidate()
            } else {
                self.turnTimer = Timer.scheduledTimer(timeInterval: 5,
                                                      target: self,
                                                      selector: #selector(self.getTimelyUpdate),
                                                      userInfo: nil,
                                                      repeats: true)
                self.turnTimer?.fire()
            }
        }).disposed(by: disposeBag)
        
        currentTime.subscribe(onNext: { [weak self] time in
            guard let self = self else { return }
            if self.detail.value != nil,
               time == 0 {
                self.timesUpEmojiGo.accept(())
            }
        }).disposed(by: disposeBag)
        
    }
    
    func sendAnswer(_ answer: String) {
        manageActivityIndicator.accept(true)
        guard let id = self.detail.value?.id else { return }
        ApiProvider.shared.request(EmojiGoService.sendAnswer(id, answer: answer))
            .subscribe(onSuccess: { [weak self] res in
                self?.manageActivityIndicator.accept(false)
                let response = GetEmojiGoResponse(JSON(res))
                if let detail = response.emojiGo {
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
    
    func getQuestion() {
        manageActivityIndicator.accept(true)
        guard let id = self.detail.value?.id else { return }
        ApiProvider.shared.request(EmojiGoService.getQuestion(id))
            .subscribe(onSuccess: { [weak self] res in
                self?.manageActivityIndicator.accept(false)
                let response = GetEmojiGoQuestionsResponse(JSON(res))
                #if DEBUG
                print("Questions: \(JSON(res))")
                #endif
                self?.questions.accept(response.questions)
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
    
    func sendQuestion(questionID: Int?, question: String?) {
        manageActivityIndicator.accept(true)
        guard let id = self.detail.value?.id else { return }
        ApiProvider.shared.request(EmojiGoService.sendQuestion(id, id: questionID, question: question))
            .subscribe(onSuccess: { [weak self] res in
                self?.manageActivityIndicator.accept(false)
                let response = GetEmojiGoResponse(JSON(res))
                if let detail = response.emojiGo {
                    self?.detail.accept(detail)
                }
        }, onError: { [weak self] err in
            self?.manageActivityIndicator.accept(false)
            let json = JSON((err as? MoyaError)?.response?.data as Any)
            let response = BasicResponse(json)
            if let message = response.msg, !message.isEmpty {
                self?.presentAlert.accept(("common.error".localized, message))
            } else {
                self?.presentAlert.accept(("common.error".localized, "common.somethingWentWrong".localized))
            }
            #if DEBUG
            print(err)
            #endif
        }).disposed(by: self.disposeBag)
    }
    
    func resetTimer() {
        guard let id = self.detail.value?.id else { return }
        ApiProvider.shared.request(EmojiGoService.resetTimer(id))
            .subscribe(onSuccess: { _ in
                #if DEBUG
                print("Reset success")
                #endif
        }).disposed(by: disposeBag)
    }
    
    func skipTurn() {
        manageActivityIndicator.accept(true)
        guard let id = self.detail.value?.id else { return }
        ApiProvider.shared.request(EmojiGoService.skipTurn(id))
            .subscribe(onSuccess: { [weak self] res in
                let response = GetEmojiGoResponse(JSON(res))
                if let detail = response.emojiGo {
                    self?.detail.accept(detail)
                }
                self?.turnSkipped.accept(())
        }, onError: { [weak self] err in
            self?.manageActivityIndicator.accept(false)
            let json = JSON((err as? MoyaError)?.response?.data as Any)
            if let message = BasicResponse(json).msg, !message.isEmpty {
                self?.presentAlert.accept(("emojiGo.settings.pass".localized, "emojiGo.round.skip.notAllowed".localized))
                #if DEBUG
                print(message)
                #endif
            } else {
                self?.presentAlert.accept(("common.error".localized, "common.somethingWentWrong".localized))
                #if DEBUG
                print(err)
                #endif
            }
            self?.turnDenied.accept(())
        }).disposed(by: self.disposeBag)
    }
    
    func endGame() {
        manageActivityIndicator.accept(true)
        guard let id = self.detail.value?.id else { return }
        ApiProvider.shared.request(EmojiGoService.cancel(id))
            .subscribe(onSuccess: { [weak self] res in
                self?.manageActivityIndicator.accept(false)
                self?.successEndEmojiGo.accept(())
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
    
    //TODO: Replace with sockets
    @objc private func getTimelyUpdate() {
        guard let id = detail.value?.id else { return }
        manageActivityIndicator.accept(true)
        ApiProvider.shared.request(EmojiGoService.getEmogigoDetails(id: id))
            .subscribe(onSuccess: { [weak self] res in
            self?.manageActivityIndicator.accept(false)
            let response = GetEmojiGoResponse(JSON(res))
            if let detail = response.emojiGo {
                //ONLY GET THE UPDATE IF CURRENT TURN IS DIFFERENT FROM THE PREVIOUS
                if detail.currentPlayerTurn != self?.detail.value?.currentPlayerTurn {
                    self?.detail.accept(detail)
                }
            }
        }, onError: { err in
            #if DEBUG
            print(err)
            #endif
        }).disposed(by: self.disposeBag)
    }
    
}
