//
//  ToTViewModel.swift
//  Elated
//
//  Created by Rey Felipe on 8/14/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Moya
import RxCocoa
import RxSwift
import SwiftyJSON

class ToTViewModel: BaseViewModel {
    let totData = BehaviorRelay<[ToTQuestions]>(value: [])
    let totThreshold = BehaviorRelay<Bool>(value: false)
    let currentQIndex = BehaviorRelay<Int>(value: -1)
    var currentQ = BehaviorRelay<ToTQuestions?>(value: nil)
    var currentChoices = BehaviorRelay<[ToTChoices]>(value: [])
    
    override init() {
        super.init()
    }
    
    func getOnboardingQuestions(completion: ((Bool) -> Void)? = nil) {
        self.manageActivityIndicator.accept(true)
        ApiProvider.shared.request(ThisOrThatService.getOnboardingQuestions).subscribe(onSuccess: { [weak self] res in
            print(JSON(res))
            guard let tot_threshold = list.tot_threshold else{
                return;
            }
            self?.manageActivityIndicator.accept(false)
            let list = ThisOrThatResponse(JSON(res))
            self?.totData.accept(list.thisorthat)
            self?.totThreshold.accept(tot_threshold)
            self?.currentQIndex.accept(list.thisorthat.count > 0 ? 0 : -1)
            self?.firstQuestion()
            completion?(true)
            
        }, onError: { [weak self] err in
            self?.manageActivityIndicator.accept(false)
            let json = JSON((err as? MoyaError)?.response?.data as Any)
            #if DEBUG
            print(err)
            #endif
            if let code = BasicResponse(json).code {
                let message = LanguageManager.shared.errorMessage(for: code)
                //present alert triggers binding on the view controller, make sure its handled
                self?.presentAlert.accept(("", message))
            }
            //TODO: the code below might not be needed, review this later
            self?.currentQIndex.accept(-1)
            self?.firstQuestion()
            completion?(false)
        }).disposed(by: self.disposeBag)
    }
    
    func sendAnswer(answer: String, trigger: Int, completion: ((Bool) -> Void)? = nil) {
        guard let id = currentQ.value?.id else {
            completion?(false)
            return
        }
        self.manageActivityIndicator.accept(true)
        ApiProvider.shared.request(ThisOrThatService.setAnswer(id: id, text: answer, trigger: trigger)).subscribe(onSuccess: { [weak self] res in
            print(JSON(res))
            self?.manageActivityIndicator.accept(false)
            
            completion?(true)
            
        }, onError: { [weak self] err in
            self?.manageActivityIndicator.accept(false)
            let json = JSON((err as? MoyaError)?.response?.data as Any)
            #if DEBUG
            print(err)
            #endif
            if let code = BasicResponse(json).code {
                let message = LanguageManager.shared.errorMessage(for: code)
                //present alert triggers binding on the view controller, make sure its handled
                self?.presentAlert.accept(("", message))
            }
            completion?(false)
        }).disposed(by: self.disposeBag)
    }
    
    private func firstQuestion() {
        guard currentQIndex.value >= 0,
              currentQIndex.value <= totData.value.count - 1
        else { return }
        currentQ.accept(totData.value[currentQIndex.value])
        currentChoices.accept(currentQ.value?.choices ?? [])
    }
    
    func nextQuestion() {
        guard currentQIndex.value >= 0,
              currentQIndex.value + 1 < totData.value.count
        else { return }
        
        currentQIndex.accept(currentQIndex.value + 1)
        currentQ.accept(totData.value[currentQIndex.value])
        currentChoices.accept(currentQ.value?.choices ?? [])
    }
    
    func isAtLastQuestion() -> Bool {
        guard currentQIndex.value >= 0,
              currentQIndex.value + 1 < totData.value.count
        else { return true }
        return false
    }

     func isWithinTotThreshold() -> Bool {
        return totThreshold.value;
    }
    
    func hasSubset(id: Int) -> Bool {
        guard let choices = currentChoices.value.first( where: { $0.id == id } ),
              !choices.subset.isEmpty
        else { return false }
        // set subset of choices
        currentChoices.accept(choices.subset)
        return true
    }
}
