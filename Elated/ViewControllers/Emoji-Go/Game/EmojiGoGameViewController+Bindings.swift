//
//  EmojiGoGameViewController+Bindings.swift
//  Elated
//
//  Created by Marlon on 9/10/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import NSObject_Rx

extension EmojiGoGameViewController {

    func bindView() {
        
        viewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)

        viewModel.presentAlert.subscribe( onNext: { [weak self] args in
            let (title, message) = args
            self?.presentAlert(title: title, message: message)
        }).disposed(by: disposeBag)
        
        settingsButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.timer.invalidate()
            
            self.view.endEditing(true)
            self.presentViewPopup(popup: self.settingsView)
            self.settingsView.isFromTimesUp.accept(false)
        }.disposed(by: disposeBag)
        
        //Popups
        timesUpView.didReset.subscribe(onNext: { [weak self] option in
            guard let self = self else { return }
            self.dismissViewPopup(popup: self.timesUpView) {
                self.resetTimer()
                self.viewModel.resetTimer()
                
                if MemCached.shared.isSelf(id: self.viewModel.detail.value?.currentPlayerTurn)
                    && self.viewModel.detail.value?.turnType == .answer {
                        //action on answer
                        //self.textInputView.emojiTextField.becomeFirstResponder()
                } else if MemCached.shared.isSelf(id: self.viewModel.detail.value?.currentPlayerTurn)
                    && self.viewModel.detail.value?.turnType == .question {
                        //reset hide/show
                        self.questionView?.isHidden = false
                }
            }
        }).disposed(by: disposeBag)
        
        timesUpView.didSkip.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.dismissViewPopup(popup: self.timesUpView) {
                if self.viewModel.detail.value?.turnType == .question {
                    self.presentAlert(title: "emojiGo.round.skip".localized,
                                      message: "emojiGo.round.skip.question.error".localized)
                    self.timer.invalidate()
                    self.resetTimer()
                    return
                } else {
                    self.viewModel.skipTurn()
                }
            }
        }).disposed(by: disposeBag)
        
        timesUpView.didSetting.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.dismissViewPopup(popup: self.timesUpView) {
                self.settingsView.isFromTimesUp.accept(true)
                self.presentViewPopup(popup: self.settingsView)
            }
        }).disposed(by: disposeBag)
        
        settingsView.didBack.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.dismissViewPopup(popup: self.settingsView) {
                if self.settingsView.isFromTimesUp.value {
                    self.presentViewPopup(popup: self.timesUpView)
                } else {
                    self.resetTimer()
                }
            }
        }).disposed(by: disposeBag)
        
        settingsView.didViewTutorial.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.dismissViewPopup(popup: self.settingsView) {
                self.show(EmojiGoTutorialIntroViewController(), sender: nil)
            }
        }).disposed(by: disposeBag)
        
        settingsView.didBlockUser.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.dismissViewPopup(popup: self.settingsView) {
                self.presentAlert(title: "emojiGo.settings.menu.button.blockUser".localized,
                                   message: "emojiGo.settings.menu.button.blockUser.message".localized) {
                    self.viewModel.blockUser()
                }
            }
        }).disposed(by: disposeBag)
        
        settingsView.didChangeGame.subscribe(onNext: {
            let vc = MenuTabBarViewController([.navigateSparkFlirtInvite])
            vc.selectedIndex = MenuTabBarViewController.MenuIndex.sparkFlirt.rawValue
            let landingNav = UINavigationController(rootViewController: vc)
            Util.setRootViewController(landingNav)
        }).disposed(by: disposeBag)
        
        settingsView.didEndGame.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.dismissViewPopup(popup: self.settingsView) {
                self.presentAlert(title: "emojiGo.settings.menu.button.endGame".localized,
                                   message: "emojiGo.settings.menu.button.endGame.message".localized) {
                    self.viewModel.endGame()
                }
            }
        }).disposed(by: disposeBag)
        
        skipView.didClose.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.dismissViewPopup(popup: self.skipView) {
                let vc = MenuTabBarViewController([.navigateSparkFlirtInvite])
                vc.selectedIndex = MenuTabBarViewController.MenuIndex.sparkFlirt.rawValue
                let landingNav = UINavigationController(rootViewController: vc)
                Util.setRootViewController(landingNav)
            }
        }).disposed(by: disposeBag)
        
        backButton.rx.tap.bind { [weak self] in
            if let nav = self?.navigationController {
                let controller = nav.viewControllers[nav.viewControllers.count - 3]
                self?.navigationController?.setNavigationBarHidden(false, animated: true)
                self?.navigationController?.popToViewController(controller, animated: true)
            }
        }.disposed(by: disposeBag)
        
        goButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            
            guard let detail = self.viewModel.detail.value,
                  MemCached.shared.isSelf(id: self.viewModel.detail.value?.currentPlayerTurn)
            else {
                self.presentAlert(title: "emojiGo.select.question.title".localized,
                                   message: "emojiGo.select.question.message".localized)
                return
            }
            
            if detail.turnType == .question,
               let question = self.questionView?.selectedQuestion.value {
                if question.id == nil || question.id == 0 {
                    //keyboard question
                    UIView.animate(withDuration: 0.4) {
                        self.questionView?.alpha = 0
                    } completion: { _ in
                        self.questionView?.alpha = 1
                        self.questionView?.isHidden = true
                        self.textInputView.normalTextField.becomeFirstResponder()
                    }
                } else {
                    //normal question
                    self.viewModel.sendQuestion(questionID: question.id, question: nil)
                }
            } else if detail.turnType == .answer {
                self.textInputView.emojiTextField.becomeFirstResponder()
            }
        }.disposed(by: disposeBag)
        
        passButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.viewModel.skipTurn()
        }.disposed(by: disposeBag)
        
        textInputView.didSendText.subscribe(onNext: { [weak self] text in
            guard let self = self,
                  MemCached.shared.isSelf(id: self.viewModel.detail.value?.currentPlayerTurn),
                  !text.isEmpty
            else {
                return
            }
            
            self.viewModel.sendQuestion(questionID: nil, question: text)
        }).disposed(by: disposeBag)
        
        textInputView.didSendEmoji.subscribe(onNext: { [weak self] emoji in
            guard let self = self,
                  MemCached.shared.isSelf(id: self.viewModel.detail.value?.currentPlayerTurn),
                  !emoji.isEmpty
            else {
                return
            }
            
            self.viewModel.sendAnswer(emoji)
        }).disposed(by: disposeBag)
        
    }
    
    func bindEvents() {
        
        viewModel.currentTime.subscribe(onNext: { [weak self] time in
            guard let self = self else { return }
            self.timerLabel.text = "\(time)"
        }).disposed(by: disposeBag)
    
        viewModel.successBlockUser.subscribe(onNext: {
            let vc = MenuTabBarViewController([.navigateSparkFlirtInvite])
            vc.selectedIndex = MenuTabBarViewController.MenuIndex.sparkFlirt.rawValue
            let landingNav = UINavigationController(rootViewController: vc)
            Util.setRootViewController(landingNav)
        }).disposed(by: disposeBag)
        
        viewModel.successEndEmojiGo.subscribe(onNext: {
            let vc = MenuTabBarViewController([.navigateSparkFlirtInvite])
            vc.selectedIndex = MenuTabBarViewController.MenuIndex.sparkFlirt.rawValue
            let landingNav = UINavigationController(rootViewController: vc)
            Util.setRootViewController(landingNav)
        }).disposed(by: disposeBag)
        
        viewModel.turnSkipped.subscribe({ [weak self] _ in
            //turn skipped keyboard round popup
            guard let self = self,
                  let detail = self.viewModel.detail.value
            else { return }
            let popup = EmojiGoRoundView(detail, turnSkipped: true, keyboardEarned: true)
            popup.applyGradient()
            self.presentViewPopup(popup: popup)
        }).disposed(by: disposeBag)
        
        viewModel.turnDenied.subscribe({ [weak self] _ in
            guard let self = self else { return }
            self.resetTimer()
        }).disposed(by: disposeBag)
        
        viewModel.timesUpEmojiGo.subscribe(onNext: { [weak self] time in
            guard let self = self else { return }
            self.timerLabel.text = "\(time)"
            self.timer.invalidate()
            self.resignKeyboard()
            self.view.endEditing(true)
            self.presentViewPopup(popup: self.timesUpView)
        }).disposed(by: disposeBag)

        viewModel.detail.subscribe(onNext: { [weak self] detail in
            guard let self = self,
                  let detail = detail,
                  let turn = detail.currentPlayerTurn
            else {
                return
            }
                        
            if detail.gameStatus == .completed {
                //Game Completed Screen
                self.show(EmojiGoGameCompletedViewController(detail), sender: nil)
                return
            }
            
            //manage keyboard type
            if detail.turnType == .answer {
                self.textInputView.emojiLimit.accept(detail.round)
                self.textInputView.inputType.accept(.emoji)
            } else if detail.turnType == .question {
                self.textInputView.emojiLimit.accept(nil)
                self.textInputView.inputType.accept(.text)
            }
            
            //manage timer, keyboard
            if MemCached.shared.isSelf(id: turn) {
                self.timerLabel.isHidden = false
                self.circleOuter.isHidden = false
                self.circleInner.isHidden = false
                self.buttonStackView.isHidden = false
                self.turnLabel.isHidden = true
                
                if detail.turnType == .answer {
                    self.passButton.isHidden = false
                    let popup = EmojiGoRoundView(detail, turnSkipped: false, keyboardEarned: false)
                    self.emojiCountBubble.label.text = "emojiGo.emoji.limit".localizedFormat("\(detail.round)")
                    self.presentViewPopup(popup: popup)
                    popup.applyGradient()
                    popup.didDismiss.subscribe(onNext: { [weak self] in
                        guard let self = self else { return }
                        self.resetTimer()
                    }).disposed(by: popup.disposeBag)
                } else if detail.turnType == .question {
                    self.passButton.isHidden = true
                    if !self.viewModel.earnedPopupKeyboardShowed && detail.isKeyboard {
                        //earned keyboard question round popup
                        let popup = EmojiGoRoundView(detail, turnSkipped: false, keyboardEarned: true)
                        self.presentViewPopup(popup: popup)
                        popup.applyGradient()
                        popup.didDismiss.subscribe(onNext: { [weak self] in
                            guard let self = self else { return }
                            self.resetTimer()
                            self.viewModel.earnedPopupKeyboardShowed = true
                        }).disposed(by: popup.disposeBag)
                    } else {
                        //normal question round popup
                        let popup = EmojiGoRoundView(detail, turnSkipped: false, keyboardEarned: false)
                        popup.applyGradient()
                        self.presentViewPopup(popup: popup)
                        popup.didDismiss.subscribe(onNext: { [weak self] in
                            guard let self = self else { return }
                            self.resetTimer()
                        }).disposed(by: popup.disposeBag)
                    }
                }
                
            } else {
                self.timerLabel.isHidden = true
                self.circleOuter.isHidden = true
                self.circleInner.isHidden = true
                self.buttonStackView.isHidden = true
                self.turnLabel.isHidden = false
                
                if MemCached.shared.isSelf(id: detail.invitee?.id) {
                    self.turnLabel.text = "emojiGo.turn".localizedFormat("\(detail.inviter?.firstName ?? "")")
                } else {
                    self.turnLabel.text = "emojiGo.turn".localizedFormat("\(detail.invitee?.firstName ?? "")")
                }
                self.timer.invalidate()
                self.resignKeyboard()
                self.view.endEditing(true)
                
                //hide questions view
                self.viewModel.questions.accept([])
            }
            
            let otherPlayerImage = MemCached.shared.isSelf(id: detail.inviter?.id)
                ? detail.invitee?.avatar?.image
                : detail.inviter?.avatar?.image
            self.chatTableView.otherPlayerImage.accept(otherPlayerImage)
            self.chatTableView.data.accept(detail)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                self.chatTableView.scrollToBottom()
            })
        }).disposed(by: disposeBag)
        
        viewModel.questions.subscribe(onNext: { [weak self] questions in
            guard let self = self else { return }
                  
            guard let detail = self.viewModel.detail.value,
                  let turn = self.viewModel.detail.value?.currentPlayerTurn,
                  detail.turnType == .question,
                  MemCached.shared.isSelf(id: turn),
                  questions.count > 2
            else {
                if let questionView = self.questionView {
                    questionView.removeFromSuperview()
                }
                self.questionView = nil
                self.questionView?.isHidden = true
                self.questionView?.removeFromSuperview()
                return
            }
            
            self.questionView?.isHidden = false
            if let questionView = self.questionView {
                questionView.removeFromSuperview()
            }
                        
            self.questionView = EmojiQuestionView(questions, isKeyboard: detail.isKeyboard)
            
            UIView.animate(withDuration: 0.4, animations: {
                self.view.addSubview(self.questionView!)
                self.questionView!.snp.makeConstraints { make in
                    make.bottom.left.right.equalTo(self.chatTableView)
                }
            }, completion: { _ in
                self.questionView!.layoutSubviews()
                self.questionView!.layoutIfNeeded()
            })
        }).disposed(by: disposeBag)
        
        textInputView.didLimit.subscribe(onNext: { [weak self] limit in
            self?.emojiCountBubble.isHidden = !limit
        }).disposed(by: disposeBag)
        
    }
    
    internal func resignKeyboard() {
        self.textInputView.normalTextField.resignFirstResponder()
        self.textInputView.emojiTextField.resignFirstResponder()
    }
    
}
