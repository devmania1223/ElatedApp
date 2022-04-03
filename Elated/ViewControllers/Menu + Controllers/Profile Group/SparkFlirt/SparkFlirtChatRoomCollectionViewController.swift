//
//  SparkFlirtChatRoomCollectionViewController.swift
//  Elated
//
//  Created by Marlon on 10/29/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SwiftyJSON

class SparkFlirtChatRoomCollectionViewController: BaseViewController {

    internal let viewModel = SparkFlirtChatRoomCollectionViewModel()
        
    internal let db = FirebaseChat.shared.reference
    
    private var showManualBack: Bool = false

    private let messagesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .jet
        label.font = .futuraMedium(16)
        label.text = "chat.messages".localized
        return label
    }()
    
    internal let collectionView: UserCollectionView = {
        let view = UserCollectionView()
        return view
    }()
    
    internal let tableView: SparkFlirtChatRoomCollectionTableView = {
        let view = SparkFlirtChatRoomCollectionTableView()
        return view
    }()
    
    init(showBackButton: Bool = false) {
        super.init(nibName: nil, bundle: nil)
        
        if showBackButton {
            //this will only work for floating chat vc parent
            self.setupNavigationBar(.white,
                                    font: .futuraMedium(20),
                                    tintColor: .white,
                                    backgroundImage: #imageLiteral(resourceName: "background-header"),
                                    addBackButton: false)
            
            self.title = "chat.messages".localized
            
            let backButton = UIBarButtonItem.createBackButton()
            backButton.tintColor = .white
            self.navigationItem.leftBarButtonItem = backButton
            
            backButton.rx.tap.bind { [weak self] in
                //attemp 1
                self?.navigationController?.popViewController(animated: true)

                //attemp 1
                self?.navigationController?.dismiss(animated: true)
            }.disposed(by: rx.disposeBag)
            
            showManualBack = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        observeData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (UIApplication.shared.delegate as? AppDelegate)?.updateFloatingChatButtonState(hide: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        (UIApplication.shared.delegate as? AppDelegate)?.updateFloatingChatButtonState(hide: false)
    }
    
    
    override func initSubviews() {
        super.initSubviews()
        
        view.addSubview(collectionView)
        let collectionViewHeight = viewModel.roomUserDetails.value.count > 0 ? 75 : 0
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(showManualBack ? 12 : 56)
            make.left.right.equalToSuperview()
            make.height.equalTo(collectionViewHeight)
        }
        
        view.addSubview(messagesLabel)
        messagesLabel.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(32)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(messagesLabel.snp.bottom).offset(13)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
    }
    
    override func bind() {
        super.bind()

        viewModel.roomUserDetails.subscribe(onNext: { [weak self] users in
            guard let self = self else { return }
            let collectionViewHeight = users.count > 0 ? 75 : 0
            self.collectionView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(56)
                make.left.right.equalToSuperview()
                make.height.equalTo(collectionViewHeight)
            }
            self.tableView.userDetails.accept(users)
            self.collectionView.data.accept(users)
        }).disposed(by: disposeBag)
        
        viewModel.chatRooms.bind(to: tableView.rooms).disposed(by: disposeBag)
        viewModel.userStatus.bind(to: tableView.userStatus).disposed(by: disposeBag)
        viewModel.userStatus.bind(to: collectionView.userStatus).disposed(by: disposeBag)

        tableView.didSelectRoom.subscribe(onNext: { [weak self] room in
            guard let self = self else { return }
            if let otherUser = self.viewModel.roomUserDetails.value.first(where: { $0.id == room.invitee || $0.id == room.inviter}) {
                let id = FirebaseChat.shared.createRoomId(invitee: room.invitee, inviter: room.inviter)
                let vc = SparkFlirtChatViewController(roomID: id, otherUser: otherUser)
                vc.hidesBottomBarWhenPushed = true
                self.show(vc, sender: nil)
            }
        }).disposed(by: disposeBag)
        
        viewModel.roomUserDetails.subscribe(onNext: { [weak self] users in
            guard let self = self else { return }
            
            //keep track of the user online status, 1 by 1
            for user in users {
                if let id = user.id {
                    self.db.child(FirebaseNodeType.user.rawValue)
                        .child("\(id)")
                        .observe(.value) { [weak self] snapShot in
                            guard let self = self,
                                  let value = snapShot.value as? [String: Any]
                            else {
                                return
                            }
                            var previous = self.viewModel.userStatus.value ?? [String: Bool]()
                            let object = FirebaseChatUserStatus(JSON(value))
                            previous["\(id)"] = object.online
                            self.viewModel.userStatus.accept(previous)
                    }
                }
            }
        }).disposed(by: disposeBag)
        
    }
    
    private func observeData() {
        
        db.child(FirebaseNodeType.chatRoom.rawValue)
            .observe(.value) { [weak self] snapShot in
                
            guard let value = snapShot.value as? [String: Any] else {
                return
            }
                
            var chatRooms = [FirebaseChatRoom]()
            if let me = MemCached.shared.userInfo?.id {
                for (key, object) in value {
                    if key.contains("\(me)") {
                        let object = FirebaseChatRoom(JSON(object))
                        chatRooms.append(object)
                    }
                }
                self?.viewModel.chatRooms.accept(chatRooms)
            }
                
        }
        
    }
    
}
