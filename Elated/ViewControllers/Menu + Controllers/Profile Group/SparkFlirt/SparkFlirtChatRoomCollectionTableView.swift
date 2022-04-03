//
//  SparkFlirtChatRoomCollectionTableView.swift
//  Elated
//
//  Created by Marlon on 10/29/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SparkFlirtChatRoomCollectionTableView: UITableView {
    
    private let disposeBag = DisposeBag()
    
    let rooms = BehaviorRelay<[FirebaseChatRoom]>(value: [])
    let userDetails = BehaviorRelay<[UserInfoShort]>(value: [])
    let userStatus = BehaviorRelay<[String: Bool]?>(value: nil)
    let viewImage = PublishRelay<UIImage>()
    let didSelectRoom = PublishRelay<FirebaseChatRoom>()

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        self.backgroundColor = .white
        self.register(SparkFlirtChatRoomCollectionTableViewCell.self,
                      forCellReuseIdentifier: SparkFlirtChatRoomCollectionTableViewCell.identifier)
        self.separatorColor = .lightGray
        self.separatorInset = .zero
        self.estimatedRowHeight = 70
        self.rowHeight = UITableView.automaticDimension
        self.tableFooterView = UIView()
        self.dataSource = self
        self.delegate = self
        self.bind()
    }
    
    private func bind() {
        Observable.combineLatest(rooms, userDetails, userStatus)
            .subscribe(onNext: { [weak self] _ in
            self?.reloadData()
        }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension SparkFlirtChatRoomCollectionTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SparkFlirtChatRoomCollectionTableViewCell.identifier)
            as? SparkFlirtChatRoomCollectionTableViewCell ?? SparkFlirtChatRoomCollectionTableViewCell()
       
        let room = rooms.value[indexPath.row]
        if let user = userDetails.value.first(where: { $0.id == room.invitee || $0.id == room.inviter }) {
            
            var online = false
            if let userStatus = self.userStatus.value,
               let id = user.id,
               let status = userStatus["\(id)"] {
                    online = status
            }
            
            let lastChat = room.lastChat.isEmpty
                ? "chat.first.message".localizedFormat(user.getDisplayName())
                : room.lastChat
            cell.set(name: user.getDisplayName(),
                     avatar: URL(string: user.avatar?.image ?? ""),
                     preview: lastChat,
                     time: room.updated,
                     online: online)
        }
        return cell
    }
    
}

extension SparkFlirtChatRoomCollectionTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRoom.accept(rooms.value[indexPath.item])
    }
    
}

