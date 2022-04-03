//
//  StoryShareTutorialGameViewController+Bindings.swift
//  Elated
//
//  Created by Rey Felipe on 11/19/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import Foundation

extension StoryShareTutorialGameViewController {

    func bindView() {
        
        viewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)

        viewModel.presentAlert.subscribe( onNext: { [weak self] args in
            let (title, message) = args
            self?.presentAlert(title: title, message: message)
        }).disposed(by: disposeBag)
        
        dictionaryView.didHide.subscribe(onNext: { [weak self] in
            self?.manageDictionary(false, definition: nil)
        }).disposed(by: disposeBag)
        
        backButton.rx.tap.bind { [weak self] in
            if let self = self, let nav = self.navigationController {
                let controller = nav.viewControllers[nav.viewControllers.count - (self.viewModel.isFromLineView ? 4 : 3)]
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                self.navigationController?.popToViewController(controller, animated: true)
            }
        }.disposed(by: disposeBag)
        
        invisibleTextField.rx.text.orEmpty.bind(to: viewModel.currentInput).disposed(by: disposeBag)
        
        enterButton.rx.tap.bind { [weak self ] in
            self?.viewModel.sendPhrase()
        }.disposed(by: disposeBag)
        
        periodButton.rx.tap.bind { [weak self ] in
            self?.viewModel.periodGame()
        }.disposed(by: disposeBag)
        
        settingsButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.view.endEditing(true)
            self.settingsView.isFromTimesUp.accept(false)
            self.presentViewPopup(popup: self.settingsView)
        }.disposed(by: disposeBag)
        
        settingsView.didBack.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.dismissViewPopup(popup: self.settingsView) {}
        }).disposed(by: disposeBag)
        
        settingsView.didViewTutorial.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.dismissViewPopup(popup: self.settingsView) {
                self.show(StoryShareTutorialIntroViewController(), sender: nil)
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
        
    }
    
    func bindEvents() {
        
        viewModel.showDefinition.subscribe(onNext: { [weak self] definition in
            guard let self = self else { return }
            self.manageDictionary(true, definition: definition)
        }).disposed(by: disposeBag)
        
        viewModel.detail.subscribe(onNext: { [weak self] detail in
            guard let detail = detail else { return }
// REY: no need to display the keyboard in tutorial screens
//            if MemCached.shared.isSelf(id: detail.currentPlayerTurn) {
//                self?.invisibleTextField.becomeFirstResponder()
//                self?.invisibleTextField.isUserInteractionEnabled = true
//            } else {
//                self?.invisibleTextField.resignFirstResponder()
//                self?.invisibleTextField.isUserInteractionEnabled = false
//            }
            self?.updateColorAndStory(detail: detail)
        }).disposed(by: disposeBag)
        
        viewModel.currentInput.subscribe(onNext: { [weak self] input in
            guard let self = self,
                  let detail = self.viewModel.detail.value,
                  let _ = input,
                  let currentLine = self.invisibleTextField.text
            else { return }
            var story = detail.phrases.map { $0.phrase }.joined(separator: " ")
            
            //this is more updated
            
            if !currentLine.isEmpty {
                story.append(" \(currentLine)")
            }
            
            let storyMutableString = NSMutableAttributedString(string: story,
                                                          attributes: [NSAttributedString.Key.font: UIFont.courierPrimeBold(12)])
            
            for phrase in detail.phrases {
                let color : StoryShareColor? = phrase.user == detail.inviter?.id
                    ? detail.inviterTextColor
                    : detail.inviteeTextColor
                if let substringRange = story.range(of: phrase.phrase) {
                    let nsRange = NSRange(substringRange, in: story)
                    storyMutableString.addAttribute(NSAttributedString.Key.foregroundColor,
                                                    value: color?.getColor() ?? .ssBlue,
                                                    range: nsRange)
                }
            }
            
            //add the current line
            if !currentLine.isEmpty {
                let color : StoryShareColor? = MemCached.shared.isSelf(id: detail.inviter?.id)
                    ? detail.inviterTextColor
                    : detail.inviteeTextColor
                
                if let substringRange = story.range(of: currentLine) {
                    let nsRange = NSRange(substringRange, in: story)
                    storyMutableString.addAttribute(NSAttributedString.Key.foregroundColor,
                                                    value: color?.getColor() ?? .ssBlue,
                                                    range: nsRange)
                }
            }
            
            self.storyTextView.attributedText = storyMutableString
            
            //spell check
            var missSpellingFound = true
            let currentArray = currentLine.components(separatedBy: " ")
            for word in currentArray {
                let checker = UITextChecker()
                let range = NSRange(location: 0, length: word.utf16.count)
                let misspelledRange = checker.rangeOfMisspelledWord(in: word,
                                                                    range: range,
                                                                    startingAt: 0,
                                                                    wrap: false,
                                                                    language: "en")
                
                if misspelledRange.location != NSNotFound {
                    missSpellingFound = true
                    break
                } else {
                    missSpellingFound = false
                }
                
            }
            
            if missSpellingFound {
                //theres a misspelled word
                self.periodButton.isHidden = true
                self.enterButton.isHidden = true
            } else {
                //theres a misspelled word
                var oldWords = [String]()
                let oldSentence = detail.phrases.map { $0.phrase }
                for phrase in oldSentence {
                    oldWords.append(contentsOf: phrase.components(separatedBy: " ")
                                        .filter { !$0.isEmpty })
                }
                let filteredOld = oldWords.filter { !self.viewModel.staticWords.contains($0.lowercased()) }
                
                let currentLine = currentLine.components(separatedBy: " ")
                                        .filter { !$0.isEmpty }
                let filteredCurrent = currentLine.filter { !self.viewModel.staticWords.contains($0.lowercased()) }
                
                let totalCount = filteredOld.count + filteredCurrent.count
                self.periodButton.isHidden = totalCount < 9 || (totalCount > 9 && filteredCurrent.count < 2)
                self.enterButton.isHidden = filteredCurrent.count != 2
            }
            
        }).disposed(by: disposeBag)
        
    }
    
    private func updateColorAndStory(detail: StoryShareGameDetail) {
        
        if detail.gameStatus == .completed {
            navigationController?.show(StoryShareGameCompletedViewController(detail), sender: nil)
        }
        
        let userIsInviter = MemCached.shared.isSelf(id: detail.inviter?.id)
        let user: Invitee? = userIsInviter ? detail.inviter : detail.invitee
        let color: StoryShareColor? = userIsInviter ? detail.inviterTextColor : detail.inviteeTextColor
        
        //alert bubble
        if MemCached.shared.isSelf(id: detail.currentPlayerTurn) {
            self.alertBubble.updateAppearance(text: "storyshare.your.turn".localized,
                                              color: color?.getColor() ?? .ssBlue,
                                              avatar: URL(string: user?.avatar?.image ?? ""))
        } else {
            self.alertBubble.updateAppearance(text: "storyshare.other.turn".localizedFormat("\(user?.firstName ?? "")"),
                                              color: color?.getColor() ?? .ssRed,
                                              avatar: URL(string: user?.avatar?.image ?? ""))
        }
        
        //story label
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 12
        let story = detail.phrases.map { $0.phrase }.joined(separator: " ")
        let storyMutableString = NSMutableAttributedString(string: story,
                                                      attributes: [NSAttributedString.Key.font: UIFont.courierPrimeBold(12),
                                                                   NSAttributedString.Key.paragraphStyle: style])
        
        for phrase in detail.phrases {
            let color : StoryShareColor? = phrase.user == detail.inviter?.id
                ? detail.inviterTextColor
                : detail.inviteeTextColor
            if let substringRange = story.range(of: phrase.phrase) {
                let nsRange = NSRange(substringRange, in: story)
                storyMutableString.addAttribute(NSAttributedString.Key.foregroundColor,
                                                value: color?.getColor() ?? .ssBlue,
                                                range: nsRange)
            }
        }
        self.storyTextView.attributedText = storyMutableString
        
        //color label
        if detail.inviterTextColor == nil || detail.inviteeTextColor == nil {
            //only current user color was set
            let string = "storyshare.color.oneSet".localizedFormat("\(color?.getName() ?? "")")
            let mutableString = NSMutableAttributedString(string: string,
                                                          attributes: [NSAttributedString.Key.font: UIFont.courierPrimeRegular(12),
                                                                       NSAttributedString.Key.foregroundColor: UIColor.umber])

            if let substringRange = string.range(of: color?.getName() ?? "") {
                let nsRange = NSRange(substringRange, in: string)
                mutableString.addAttribute(NSAttributedString.Key.foregroundColor,
                                           value: color?.getColor() ?? .ssBlue,
                                           range: nsRange)
            }
            
            self.colorLabel.attributedText = mutableString
        } else {
            //both were set
            let otherColor = userIsInviter ? detail.inviteeTextColor : detail.inviterTextColor
            let string = "storyshare.color.allSet".localizedFormat("\(color?.getName() ?? "")",
                                                                   "\(userIsInviter ? (detail.invitee?.firstName ?? "") : (detail.inviter?.firstName ?? ""))",
                                                                   "\(otherColor?.getName() ?? "")")
            let mutableString = NSMutableAttributedString(string: string,
                                                          attributes: [NSAttributedString.Key.font: UIFont.courierPrimeRegular(12),
                                                                       NSAttributedString.Key.foregroundColor: UIColor.umber])
            
            if let substringRange = string.range(of: color?.getName() ?? "") {
                let nsRange = NSRange(substringRange, in: string)
                mutableString.addAttribute(NSAttributedString.Key.foregroundColor,
                                           value: color?.getColor() ?? .ssBlue,
                                           range: nsRange)
            }
            
            if let substringRange = string.range(of: otherColor?.getName() ?? "") {
                let nsRange = NSRange(substringRange, in: string)
                mutableString.addAttribute(NSAttributedString.Key.foregroundColor,
                                             value: otherColor?.getColor() ?? .ssRed,
                                             range: nsRange)
            }
            self.colorLabel.attributedText = mutableString
        }
    }
    
}
