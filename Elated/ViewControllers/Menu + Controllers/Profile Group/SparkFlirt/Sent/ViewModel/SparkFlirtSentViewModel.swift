//
//  SparkFlirtSentViewModel.swift
//  Elated
//
//  Created by Rey Felipe on 7/6/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Moya
import RxCocoa
import RxSwift
import SwiftyJSON

class SparkFlirtSentViewModel: SparkFlirtCommonViewModel {
    
    let sparkFlirts = BehaviorRelay<[SparkFlirtInfo]>(value: [])
    
    func getSparkFlirtOutgoingInvites(_ page: Int) {
        
        self.manageActivityIndicator.accept(true)
        
        ApiProvider.shared.request(SparkFlirtService.getSentSparkFlirt(page: page))
            .subscribe(onSuccess: { [weak self] res in
                
                self?.manageActivityIndicator.accept(false)
                let response = SparkFlirtResponse(JSON(res))
                self?.sparkFlirts.accept(response.data)
                
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
        }).disposed(by: self.disposeBag)
    }
    
    func revokeInvitation(atIndex index: Int) {
        let invitation = sparkFlirts.value[index]
        guard let id = invitation.id else { return }
        
        print("SparkFlirt - Revoke Invitation - id - \(id)")
        self.manageActivityIndicator.accept(true)
        
        ApiProvider.shared.request(SparkFlirtService.revokeSparkFlirtInvite(id: id))
            .subscribe(onSuccess: { [weak self] res in
                
                self?.sparkFlirts.remove(at: index)
                self?.manageActivityIndicator.accept(false)
                
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
            
        }).disposed(by: self.disposeBag)
    }

}
