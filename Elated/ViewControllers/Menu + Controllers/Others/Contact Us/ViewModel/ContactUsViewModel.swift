//
//  ContactUsViewModel.swift
//  Elated
//
//  Created by Marlon on 2021/3/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import RxCocoa
import RxSwift
import Moya
import SwiftyJSON

class ContactUsViewModel: BaseViewModel {

    enum Concern {
        case suggestion
        case question
        case reportTechnical
        case reportBilling
        
        func getTitle() -> String {
            switch self {
            case .suggestion:
                return "contactUs.suggest".localized
            case .question:
                return "contactUs.question".localized
            case .reportTechnical:
                return "contactUs.reportTechnical".localized
            case .reportBilling:
                return "contactUs.reportBilling".localized
            }
        }
    }
    
    let selected = BehaviorRelay<Concern>(value: .question)
    var email = BehaviorRelay<String>(value: .empty)
    var message = BehaviorRelay<String>(value: .empty)
    var emailValid = BehaviorRelay<Bool>(value: false)
    var messageValid = BehaviorRelay<Bool>(value: false)
    var allowSend = BehaviorRelay<Bool>(value: false)
    
    let success = PublishRelay<Void>()
    
    override init() {
        super.init()
        
        email.map { $0.count != 0 && $0.isEmail }
            .bind(to: emailValid)
            .disposed(by: disposeBag)
        
        message.map { $0.count != 0 && $0 != "contactUs.message.placeholder".localized }
            .bind(to: messageValid)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(emailValid, messageValid)
            .map { $0 && $1 }
            .bind(to: allowSend)
            .disposed(by: disposeBag)
        
    }
    
    func sendMessage() {
        self.manageActivityIndicator.accept(true)
        ApiProvider.shared.request(BaseService.inquiry(subject: selected.value.getTitle(), email: email.value, body: message.value))
            .subscribe(onSuccess: { [weak self] res in
                self?.manageActivityIndicator.accept(false)
                self?.presentAlert.accept(("common.success".localized, "contact.us.sucess".localized))
        }, onError: { [weak self]  err in
            self?.manageActivityIndicator.accept(false)
            #if DEBUG
            print(err)
            #endif
            let json = JSON((err as? MoyaError)?.response?.data as Any)
            if let code = BasicResponse(json).code {
                let message = LanguageManager.shared.errorMessage(for: code)
                //present alert triggers binding on the view controller, make sure its handled
                self?.presentAlert.accept(("", message))
            }
        }).disposed(by: self.disposeBag)
    }
    
}
