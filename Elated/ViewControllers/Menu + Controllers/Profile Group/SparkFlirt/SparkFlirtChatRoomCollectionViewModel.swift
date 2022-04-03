//
//  SparkFlirtChatRoomCollectionViewModel.swift
//  Elated
//
//  Created by Marlon on 10/29/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import SwiftyJSON
import RxSwift
import RxCocoa

class SparkFlirtChatRoomCollectionViewModel: BaseViewModel {

    let roomUserDetails = BehaviorRelay<[UserInfoShort]>(value: [])
    let chatRooms = BehaviorRelay<[FirebaseChatRoom]>(value: [])
    let userStatus = BehaviorRelay<[String: Bool]?>(value: nil)

    override init() {
        super.init()
        
        chatRooms.subscribe(onNext: { [weak self] rooms in
            guard let self = self, rooms.count > 0 else { return }
            //self.getUserDetails(ids: rooms.map { MemCached.shared.isSelf(id: $0.invitee) ? $0.inviter : $0.invitee  } )
            self.getSuccessfulSparkFlirts()
        }).disposed(by: disposeBag)
        
    }
    
//    private func getUserDetails(ids: [Int]) {
//        //TODO: Add pagination
//        manageActivityIndicator.accept(true)
//        ApiProvider.shared.request(UserServices.getUserInfos(ids: ids))
//            .subscribe(onSuccess: { [weak self] res in
//            self?.manageActivityIndicator.accept(false)
//            let response = GetUsersInfoResponse(JSON(res))
//            self?.roomUserDetails.accept(response.users)
//        }, onError: { [weak self] err in
//            self?.manageActivityIndicator.accept(false)
//            #if DEBUG
//            print(err)
//            #endif
//        }).disposed(by: self.disposeBag)
//    }
    
    private func getSuccessfulSparkFlirts() {
        //TODO: Add pagination
        manageActivityIndicator.accept(true)
        ApiProvider.shared.request(SparkFlirtService.getSuccessfullSparkFlirts)
            .subscribe(onSuccess: { [weak self] res in
            self?.manageActivityIndicator.accept(false)
            let response = GetUsersInfoResponse(JSON(res))
            self?.roomUserDetails.accept(response.users)
        }, onError: { [weak self] err in
            self?.manageActivityIndicator.accept(false)
            #if DEBUG
            print(err)
            #endif
        }).disposed(by: self.disposeBag)
    }
    
}
