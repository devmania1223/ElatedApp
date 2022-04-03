//
//  BashoGameViewModel.swift
//  Elated
//
//  Created by Marlon on 4/17/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import RxCocoa
import RxSwift
import SwiftyJSON
import Moya
import SwiftSyllables

//make public for all basho screens
enum HaikuLine: Int {
    case top = 1
    case middle = 2
    case bottom = 3
    
    func getSyllableCount() -> Int {
        switch self {
        case .top, .bottom:
            return 5
        case .middle:
            return 7
        }
    }
}

class BashoGameViewModel: BaseViewModel {
    
    enum BashoWordOption {
        case alphabetical
        case tree
    }
    
    var tipShowed = BehaviorRelay<Bool>(value: false)
    var showDefinition = PublishRelay<BashoWordDefinition>()
    var successBlockUser = PublishRelay<Void>()
    let successEndBasho = PublishRelay<Void>()
    let successBasho = PublishRelay<BashoGameDetail>()
    let timesUpBasho = PublishRelay<Void>()
    let turnSkipped = PublishRelay<Void>()
    let currentTime = BehaviorRelay<Int>(value: 15)
    let detail = BehaviorRelay<BashoGameDetail?>(value: nil)
    let haikuLine = BehaviorRelay<HaikuLine>(value: .top)
    let suggestions = BehaviorRelay<[WordSuggestion]>(value: CommonWords().getBashoSuggestion(word: ""))
    let alphabeticalSuggestions = BehaviorRelay<[String: [WordSuggestion]]>(value: CommonWords().getCommonBashoDictionary())
    let alphabeticalSuggestionsArrayKeys = BehaviorRelay<[String]>(value: [])
    let bashoWords = BehaviorRelay<[WordSuggestion]>(value: [])
    let didAddBasho = PublishRelay<WordSuggestion>()
    let syllableCount = BehaviorRelay<Int>(value: 0)
    let selectedSuggestionItem = PublishRelay<WordSuggestion>()
    let forceRefreshDragDropViews = PublishRelay<Void>()
    let visibleWordOption = BehaviorRelay<BashoWordOption?>(value: nil)
    let textFieldText = BehaviorRelay<String?>(value: nil)
    
    override init() {
        super.init()
        
        alphabeticalSuggestions.subscribe(onNext: { [weak self] dictionary in
            let sortedKeys = dictionary.keys.sorted(by: <)
            self?.alphabeticalSuggestionsArrayKeys.accept(sortedKeys)
        }).disposed(by: disposeBag)
        
        currentTime.subscribe(onNext: { [weak self] time in
            guard let self = self else { return }
            if self.detail.value != nil,
               self.syllableCount.value == self.haikuLine.value.getSyllableCount(),
               time == 0 {
                self.sendBasho()
            } else if time == 0 {
                self.timesUpBasho.accept(())
            }
        }).disposed(by: disposeBag)
        
        textFieldText.subscribe(onNext: { [weak self] text in
            guard let text = text else { return }
            self?.suggestions.accept(CommonWords().getBashoSuggestion(word: text))
        }).disposed(by: disposeBag)
        
        bashoWords.subscribe(onNext: { [weak self] words in
            guard let self = self else { return }
            var count = 0
            //make sure to not include invalid words
            let filtered = words.filter { $0.syllables != nil && $0.syllables != 0 }
            for word in filtered {
                count += (word.syllables ?? 0)
            }
            self.syllableCount.accept(count)
        }).disposed(by: disposeBag)
        
        didAddBasho.subscribe(onNext: { [weak self] suggestion in
            if suggestion.syllables == nil || suggestion.syllables == 0 {
                self?.getSyllable(suggestion: suggestion)
            }
        }).disposed(by: disposeBag)
        
        selectedSuggestionItem.subscribe(onNext: { [weak self] suggestion in
            self?.getDefinition(suggestion)
        }).disposed(by: disposeBag)
        
        syllableCount.subscribe(onNext: { [weak self] count in
            guard let self = self else { return }
            if count == self.haikuLine.value.getSyllableCount() {
                self.sendBasho()
            }
        }).disposed(by: disposeBag)
        
    }
    
    private func getSyllable(suggestion: WordSuggestion) {
        //spell checker
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: suggestion.word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: suggestion.word,
                                                            range: range,
                                                            startingAt: 0,
                                                            wrap: false,
                                                            language: "en")
        if misspelledRange.location == NSNotFound {
            //syllable checker
            let syllables = SwiftSyllables.getSyllables(suggestion.word)
            var basho = self.bashoWords.value
            if let index = basho.firstIndex(where: { $0.word == suggestion.word }) {
                basho.remove(at: index)
                var new = WordSuggestion(id: 0, word: suggestion.word)
                new.syllables = syllables
                basho.insert(new, at: index)

                //TODO: red bg for last word if syllable is more than required
                var count = 0
                for word in basho {
                    count += (word.syllables ?? 0)
                }
                new.syllablesOutOfBounce = count > self.haikuLine.value.getSyllableCount()
                bashoWords.accept(basho)
            }
        }
        
//        guard let userID = MemCached.shared.userInfo?.id else { return }
//        ApiProvider.shared.request(BashoService.getWordSyllables(userId: userID,
//                                                                 word: suggestion.word))
//            .subscribe(onSuccess: { [weak self] res in
//                guard let self = self else { return }
//                let response = GetBashoSyllablesResponse(JSON(res))
//                var basho = self.bashoWords.value
//                if let index = basho.firstIndex(where: { $0.word == suggestion.word }) {
//                    basho.remove(at: index)
//                    var new = WordSuggestion(id: 0, word: suggestion.word)
//                    new.syllables = response.syllable?.syllables?.count ?? 0
//                    basho.insert(new, at: index)
//
//                    //TODO: red bg for last word if syllable is more than required
////                    var count = 0
////                    for word in basho {
////                        count += (word.syllables ?? 0)
////                    }
////                    new.syllablesOutOfBounce = count > self.haikuLine.value.getSyllableCount()
//
//                    self.bashoWords.accept(basho)
//                }
//        }, onError: { err in
//            #if DEBUG
//            print(err)
//            #endif
//        }).disposed(by: self.disposeBag)
    }
    
    private func getDefinition(_ word: WordSuggestion) {
        manageActivityIndicator.accept(true)
        guard let userID = MemCached.shared.userInfo?.id else { return }
        ApiProvider.shared.request(BashoService.getWordDefinition(userId: userID, word: word.word))
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
    
    func sendBasho() {
        manageActivityIndicator.accept(true)
        guard let detail = self.detail.value,
              let userID = MemCached.shared.userInfo?.id else { return }
        let line = bashoWords.value.map { $0.word }.joined(separator: " ")
        ApiProvider.shared.request(BashoService.sendBasho(id: detail.id!,
                                                          userId: userID,
                                                          line: line,
                                                          time: abs(currentTime.value - 15)))
            .subscribe(onSuccess: { [weak self] res in
                guard let self = self else { return }
                self.manageActivityIndicator.accept(false)
                let model = BashoGameDetail(JSON(res))
                
                //TODO: Remove condition when api is fixed EA-429
                if model.invitee?.id == nil || model.invitee?.id == 0 {
                    guard let oldModel = self.detail.value else { return }
                    var modifiedModel = BashoGameDetail(JSON(res))
                    var generatedLine = BashoLine(JSON(res))
                    generatedLine.line = line
                    generatedLine.time = self.currentTime.value
                    generatedLine.user = MemCached.shared.userInfo?.id ?? 0
                    
                    var oldLines = oldModel.basho
                    oldLines.append(generatedLine)
                    modifiedModel.basho = oldLines
                    modifiedModel.invitee = oldModel.invitee
                    modifiedModel.inviter = oldModel.inviter
                    self.successBasho.accept(modifiedModel)
                } else {
                    self.successBasho.accept(model)
                }
        }, onError: { [weak self] err in
            self?.manageActivityIndicator.accept(false)
            let json = JSON((err as? MoyaError)?.response?.data as Any)
            #if DEBUG
            print(err)
            #endif
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
    
    func resetTimer() {
        guard let id = self.detail.value?.id else { return }
        ApiProvider.shared.request(BashoService.resetTimer(id: id))
            .subscribe(onSuccess: { _ in
                #if DEBUG
                print("Reset success")
                #endif
        }).disposed(by: disposeBag)
    }
    
    func skipTurn() {
        manageActivityIndicator.accept(true)
        guard let id = self.detail.value?.id else { return }
        ApiProvider.shared.request(BashoService.skipTurn(id: id))
            .subscribe(onSuccess: { [weak self] res in
                let response = GetBashoResponse(JSON(res))
                if let detail = response.basho {
                    self?.detail.accept(detail)
                }
                self?.turnSkipped.accept(())
        }, onError: { [weak self] err in
            self?.manageActivityIndicator.accept(false)
            #if DEBUG
            print(err)
            #endif
        }).disposed(by: self.disposeBag)
    }
    
    func endGame() {
        manageActivityIndicator.accept(true)
        guard let detail = self.detail.value else { return }
        ApiProvider.shared.request(BashoService.cancel(id: detail.id!))
            .subscribe(onSuccess: { [weak self] res in
                self?.manageActivityIndicator.accept(false)
                self?.successEndBasho.accept(())
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
    
}
