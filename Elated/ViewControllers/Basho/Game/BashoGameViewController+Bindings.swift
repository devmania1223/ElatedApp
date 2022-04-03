//
//  BashoGameViewController+Bindings.swift
//  Elated
//
//  Created by Marlon on 4/18/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

extension BashoGameViewController {
    
    func bindView() {
        
        viewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)

        viewModel.presentAlert.subscribe( onNext: { [weak self] args in
            let (title, message) = args
            self?.presentAlert(title: title, message: message)
        }).disposed(by: disposeBag)
        
        textInputView.textField.rx.controlEvent(.editingDidEnd).subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            if let text = self.textInputView.textField.text,
               let firstText = text.components(separatedBy: " ").first,
               firstText.count > 0
                && self.viewModel.visibleWordOption.value == nil {
                self.textInputView.textField.text = ""
                self.textInputView.textField.becomeFirstResponder()
                var data = self.viewModel.bashoWords.value
                if !data.contains(where: { $0.word == text }) {
                    let new = WordSuggestion(id: 0, word: text)
                    data.append(new)
                    self.viewModel.bashoWords.accept(data)
                    self.viewModel.didAddBasho.accept(new)
                }
            }
        }).disposed(by: disposeBag)
                
        textInputView.textField.rx.text.orEmpty.bind(to: viewModel.textFieldText).disposed(by: disposeBag)

        //send
        textInputView.sendButton.rx.tap.bind { [weak self] in
            self?.send()
        }.disposed(by: disposeBag)
    
        //syllables
        textInputView.manageSyllable.subscribe { [weak self] show in
            self?.viewModel.visibleWordOption.accept(show ? .tree : nil)
        }.disposed(by: disposeBag)
        
        //search
        textInputView.manageSearch.subscribe { [weak self] show in
            self?.viewModel.visibleWordOption.accept(show ? .alphabetical : nil)
        }.disposed(by: disposeBag)
        
        bashoCollectionView.didRemoveItemObject.subscribe(onNext: { [weak self] item in
            guard let self = self else { return }
            let words = self.viewModel.bashoWords.value.filter { $0.word != item.title }
            self.viewModel.bashoWords.accept(words)
        }).disposed(by: disposeBag)
    
        dictionaryView.didHide.subscribe(onNext: { [weak self] in
            self?.manageDictionary(false, definition: nil)
        }).disposed(by: disposeBag)
        
        viewModel.haikuLine.map { "basho.sylables".localizedFormat("0", "\($0.getSyllableCount())") }
            .bind(to: syllablesLabel.rx.text)
            .disposed(by: disposeBag)
        
        settingsButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.timer.invalidate()
            self.textInputView.textField.resignFirstResponder()
            self.view.endEditing(true)
            self.presentViewPopup(popup: self.settingsView)
            self.settingsView.isFromTimesUp.accept(false)
        }.disposed(by: disposeBag)
        
        //Popups
        timesUpView.didReset.subscribe(onNext: { [weak self] option in
            guard let self = self else { return }
            self.dismissViewPopup(popup: self.timesUpView) {
                self.viewModel.currentTime.accept(15)
                self.timer = Timer.scheduledTimer(timeInterval: 1,
                                                  target: self,
                                                  selector: #selector(self.countDown),
                                                  userInfo: nil,
                                                  repeats: true)
                self.viewModel.resetTimer()
            }
        }).disposed(by: disposeBag)
        
        timesUpView.didSkip.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.dismissViewPopup(popup: self.timesUpView) {
                self.viewModel.skipTurn()
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
                    self.timer = Timer.scheduledTimer(timeInterval: 1,
                                                      target: self,
                                                      selector: #selector(self.countDown),
                                                      userInfo: nil,
                                                      repeats: true)
                    self.timer.fire()
                }
            }
        }).disposed(by: disposeBag)
        
        settingsView.didViewTutorial.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.dismissViewPopup(popup: self.settingsView) {
                self.show(BashoTutorialIntroViewController(), sender: nil)
            }
        }).disposed(by: disposeBag)
        
        settingsView.didBlockUser.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.dismissViewPopup(popup: self.settingsView) {
                self.presentAlert(title: "basho.settings.menu.button.blockUser".localized,
                                   message: "basho.settings.menu.button.blockUser.message".localized) {
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
                self.presentAlert(title: "basho.settings.menu.button.endGame".localized,
                                   message: "basho.settings.menu.button.endGame.message".localized) {
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
        
        syllableView.currentSelected.subscribe(onNext: { [weak self] syllable in
            guard let self = self else { return }
            self.textInputView.textField.placeholder = "basho.texfield.placeholder.syllable".localizedFormat("\(self.syllableView.currentSelected.value)")
            
            //TODO: Refresh Tree view according to syllables
        }).disposed(by: disposeBag)
        
        //MARK: SparkFlirt Reviewer
        
        reviewer.lockImage.bind(to: lockImageView.rx.image).disposed(by: disposeBag)

    }
    
    func bindEvents() {
        
        viewModel.currentTime.subscribe(onNext: { [weak self] time in
            guard let self = self else { return }
            self.timerLabel.text = "\(time)"
        }).disposed(by: disposeBag)
        
        viewModel.successBasho.subscribe(onNext: { [weak self] detail in
            if detail.basho.filter({ !$0.line.isEmpty }).count == 3 {
                guard let self = self else { return }
                if self.reviewer.hasSuccessfulSparkFlirt.value {
                    //normal completion
                    self.show(BashoGameCompletedViewController(detail), sender: nil)
                } else {
                    //sparkFlirt Animation
                    let vc = SparkFlirtIceBrokenViewController(gameDetail: detail)
                    self.show(vc, sender: nil)
                }
            } else {
                self?.show(BashoLinesViewController(detail), sender: nil)
            }
        }).disposed(by: disposeBag)
        
        viewModel.tipShowed.subscribe(onNext: { [weak self] showed in
            self?.alertBubble.isHidden = showed
        }).disposed(by: disposeBag)
        
        viewModel.successBlockUser.subscribe(onNext: {
            let vc = MenuTabBarViewController([.navigateSparkFlirtInvite])
            vc.selectedIndex = MenuTabBarViewController.MenuIndex.sparkFlirt.rawValue
            let landingNav = UINavigationController(rootViewController: vc)
            Util.setRootViewController(landingNav)
        }).disposed(by: disposeBag)
        
        viewModel.successEndBasho.subscribe(onNext: {
            let vc = MenuTabBarViewController([.navigateSparkFlirtInvite])
            vc.selectedIndex = MenuTabBarViewController.MenuIndex.sparkFlirt.rawValue
            let landingNav = UINavigationController(rootViewController: vc)
            Util.setRootViewController(landingNav)
        }).disposed(by: disposeBag)
        
        viewModel.turnSkipped.subscribe({ [weak self] _ in
            guard let self = self else { return }
            self.presentViewPopup(popup: self.skipView)
        }).disposed(by: disposeBag)
        
        viewModel.timesUpBasho.subscribe(onNext: { [weak self] time in
            guard let self = self else { return }
            self.timerLabel.text = "\(time)"
            self.timer.invalidate()
            self.textInputView.textField.resignFirstResponder()
            self.view.endEditing(true)
            self.presentViewPopup(popup: self.timesUpView)
        }).disposed(by: disposeBag)
        
        viewModel.showDefinition.subscribe(onNext: { [weak self] definition in
            guard let self = self else { return }
            self.manageDictionary(true, definition: definition)
        }).disposed(by: disposeBag)
        
        viewModel.suggestions.subscribe(onNext: { [weak self] word in
            guard let self = self else { return }
            self.alertBubble.isHidden = self.viewModel.tipShowed.value || word.count == 0
            self.suggestionCollectionView.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel.bashoWords.subscribe(onNext: { [weak self] words in
            guard let self = self else { return }
            let data: [CommonDataModel] = words.map {
                let invalid = $0.syllables == nil || $0.syllables == 0 || $0.syllablesOutOfBounce
                return CommonDataModel(nil, title: $0.word, background: invalid ? UIColor.red.withAlphaComponent(0.9) : nil)
            }
            self.bashoCollectionView.data.accept(data)
            self.treeView.bashoWords.accept(words)
            
            let sugestions = self.viewModel.suggestions.value
            var filtered = [WordSuggestion]()
            for word in sugestions {
                if !words.contains(where: { $0.word == word.word }) {
                    filtered.append(word)
                }
            }
            self.viewModel.suggestions.accept(filtered)
            self.initDragableDropable()
            self.bashoCollectionView.flashScrollIndicators()
        }).disposed(by: disposeBag)
        
        viewModel.syllableCount.subscribe (onNext: { [weak self] count in
            guard let self = self else { return }
            self.syllablesLabel.text = "basho.sylables".localizedFormat("\(count)", "\(self.viewModel.haikuLine.value.getSyllableCount())")
            let limit = self.viewModel.haikuLine.value.getSyllableCount()
            let syllableCountToShow = (limit - count) < 1 ? 1 : (limit - count)
            self.syllableView.syllableLimit.accept(syllableCountToShow)
        }).disposed(by: disposeBag)
        
        viewModel.forceRefreshDragDropViews.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            let basho = self.viewModel.bashoWords.value
            self.treeView.bashoWords.accept(basho)
            
            let sugestions = self.viewModel.suggestions.value
            var filtered = [WordSuggestion]()
            for word in sugestions {
                if !basho.contains(where: { $0.word == word.word }) {
                    filtered.append(word)
                }
            }
            self.viewModel.suggestions.accept(filtered)
            self.initDragableDropable()
        }).disposed(by: disposeBag)
        
        viewModel.visibleWordOption.subscribe(onNext: { [weak self] option in
            guard let self = self else { return }
            self.alphabeticalCollectionView.isHidden = option != .alphabetical
            self.treeView.isHidden = option != .tree
            self.syllableView.isHidden = option != .tree
            
            self.alphabeticalCollectionView.isUserInteractionEnabled = option == .alphabetical
            self.treeView.isUserInteractionEnabled = option == .tree
            self.syllableView.isUserInteractionEnabled = option == .tree
            
            self.suggestionCollectionView.isUserInteractionEnabled = option == nil
            
            self.alphabeticalCollectionView.reloadData()
            self.textInputView.searchButton.isSelected = option == .alphabetical
            self.textInputView.sylableButton.isSelected = option == .tree
            if option != nil {
                self.textInputView.textField.resignFirstResponder()
                self.view.endEditing(true)
            }
            
            let placeHolder = option == .alphabetical
                ? "basho.texfield.placeholder.alphabet".localized
                : option == .tree
                    ? "basho.texfield.placeholder.syllable".localizedFormat("\(self.syllableView.currentSelected.value)")
                    : "basho.texfield.placeholder".localized
            
            self.textInputView.textField.placeholder = placeHolder
        }).disposed(by: disposeBag)
        
    }
    
    private func send() {
        if let text = self.textInputView.textField.text,
           let firstText = text.components(separatedBy: " ").first,
           firstText.count > 0 {
            textInputView.textField.text = ""
            var data = self.viewModel.bashoWords.value
            if !data.contains(where: { $0.word == firstText }) {
                let new = WordSuggestion(id: 0, word: firstText)
                data.append(new)
                self.viewModel.bashoWords.accept(data)
                self.viewModel.didAddBasho.accept(new)
            }
        }
    }
    
    
}
