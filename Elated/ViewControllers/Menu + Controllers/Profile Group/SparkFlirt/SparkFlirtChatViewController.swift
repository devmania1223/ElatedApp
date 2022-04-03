//
//  SparkFlirtChatViewController.swift
//  Elated
//
//  Created by Marlon on 2021/3/5.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import FirebaseStorage
import FirebaseDatabase
import SwiftyJSON

class SparkFlirtChatViewController: BaseViewController {

    internal let viewModel = SparkFlirtChatViewModel()
    
    internal let db = FirebaseChat.shared.reference
    
    internal let tableView: SparkFlirtChatTableView = {
        let tableView = SparkFlirtChatTableView()
        return tableView
    }()
    
    internal let keyboardView: ChatKeyboardView = {
        let view = ChatKeyboardView()
        return view
    }()
    
    internal let profileImageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.cornerRadius = 16.5
        return view
    }()
    
    internal let profileNameLabel: UILabel = {
        let view = UILabel()
        view.font = .futuraMedium(20)
        view.textColor = .white
        view.textAlignment = .center
        return view
    }()
    
    internal let dateLabel: UILabel = {
        let view = UILabel()
        view.font = .futuraBook(12)
        view.textColor = .silver
        view.textAlignment = .center
        view.text = Date().dateToMonthDay()
        return view
    }()
    
    internal let messageLabel: UILabel = {
        let view = UILabel()
        view.font = .futuraBook(12)
        view.textColor = .sonicSilver
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    internal lazy var customtitleView: UIView = {
        let view = UIView()
        
        view.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.width.equalTo(33)
        }
        
        view.addSubview(profileNameLabel)
        profileNameLabel.snp.makeConstraints { make in
            make.left.equalTo(profileImageView.snp.right).offset(16)
            make.right.equalToSuperview()
            make.centerY.equalTo(profileImageView)
        }
        
        return view
    }()
    
    init(roomID: String, otherUser: UserInfoShort) {
        super.init(nibName: nil, bundle: nil)
        viewModel.roomID = roomID
        viewModel.otherUserDetail.accept(otherUser)
        tableView.otherUserDetail.accept(otherUser)
        messageLabel.text = "chat.first.message".localizedFormat(otherUser.getDisplayName())
        self.navigationItem.titleView = customtitleView
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
        //TODO: Add navbar title view
        self.setupNavigationBar(.white,
                                font: .futuraMedium(20),
                                tintColor: .white,
                                backgroundImage: #imageLiteral(resourceName: "background-header"),
                                addBackButton: true)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        (UIApplication.shared.delegate as? AppDelegate)?.updateFloatingChatButtonState(hide: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        (UIApplication.shared.delegate as? AppDelegate)?.updateFloatingChatButtonState(hide: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        keyboardView.addShadowLayer()
        keyboardView.textView.becomeFirstResponder()
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        view.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(18)
            make.left.right.equalToSuperview().inset(10)
        }
        
        view.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(18)
            make.left.right.equalToSuperview().inset(10)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(2)
            make.left.right.equalToSuperview().inset(10)
        }
        
        view.addSubview(keyboardView)
        keyboardView.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.height.lessThanOrEqualTo(200)
        }
        
    }
    
    override func bind() {
        super.bind()
        
        keyboardView.send.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            //firebase
            self.send(message: text)
        }).disposed(by: disposeBag)

        let imagePicker = ImagePicker()
        keyboardView.camera.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            imagePicker.showOptions(self.keyboardView.cameraButton) { image in
                if let image = image {
                    self.sendImage(image: image)
                }
            }
        }).disposed(by: disposeBag)
        
        tableView.viewImage.subscribe(onNext: { [weak self] image in
            let vc = ImageViewerViewController(nil, url: image)
            vc.modalPresentationStyle = .fullScreen
            self?.present(vc,
                          animated: true,
                          completion: nil)
        }).disposed(by: disposeBag)
        
        tableView.data.subscribe(onNext: { [weak self] data in
            self?.tableView.alpha = data.count == 0 ? 0 : 1
            self?.dateLabel.alpha = data.count == 0 ? 1 : 0
            self?.messageLabel.alpha = data.count == 0 ? 1 : 0
        }).disposed(by: disposeBag)
        
        viewModel.otherUserDetail.subscribe(onNext: { [weak self] user in
            self?.profileImageView.kf.setImage(with: URL(string: user?.avatar?.image ?? ""), placeholder: #imageLiteral(resourceName: "profile-placeholder"))
            self?.profileNameLabel.text = user?.getDisplayName()
        }).disposed(by: disposeBag)
                
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleTableLongPress(sender:)))
        tableView.addGestureRecognizer(longPress)
        
    }
    
    @objc private func handleTableLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                let data = tableView.data.value[indexPath.row].id
                showOptions(key: data)
            }
        }
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            tableView.contentInset = UIEdgeInsets(top: keyboardHeight/1.8, left: 0, bottom: 0, right: 0)
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        tableView.contentInset = .zero
    }
    
    internal func showOptions(key: String) {
    
        let alert = UIAlertController(title: "chat.options".localized,
                                      message: "chat.select.options".localized,
                                      preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "chat.option.button.delete".localized,
                                      style: .default,
                                      handler: { [weak self] action in
                                        guard let self = self else { return }
                                        FirebaseChat.shared.deleteMessage(chatRoom: self.viewModel.roomID!, key: key)
        }))
        
        alert.addAction(UIAlertAction(title: "common.cancel".localized,
                                      style: .cancel,
                                      handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alert.popoverPresentationController?.sourceView = self.tableView
            alert.popoverPresentationController?.sourceRect = tableView.bounds
            alert.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    
    }
    
    private func send(message: String) {
        guard let roomID = viewModel.roomID else { return }
        
        FirebaseChat.shared.sendText(chatRoom: roomID, message: message)
    }

    private func sendImage(image: UIImage) {
        guard let chatRoom = viewModel.roomID else { return }
        FirebaseChat.shared.sendImage(chatRoom: chatRoom) { key in
            let storageRef = Storage.storage().reference().child(FirebaseNodeType.storagePhoto.rawValue)
            //actual upload
            storageRef.putData(image.compressToData(), metadata: nil) { metadata, error in
                if metadata != nil {
                    storageRef.downloadURL() { url, error in
                        if let url = url {
                            FirebaseChat.shared.updateImageURL(chatRoom: chatRoom,
                                                               key: key ?? "",
                                                               image: url.absoluteString)
                        } else {
                            #if DEBUG
                            print("Error Upload \(error?.localizedDescription ?? "")")
                            #endif
                        }
                    }
                } else {
                    #if DEBUG
                    print("Error Upload \(error?.localizedDescription ?? "")")
                    #endif
                }
            }
        }
    }
    
    private func observeData() {
        guard let roomID = viewModel.roomID else { return }
        
        db.child(FirebaseNodeType.chatMessage.rawValue).child(roomID).observe(.value) { snapShot in
            guard let value = snapShot.value as? [String: Any] else {
                print(snapShot.value ?? "")
                return
            }
            
            let previousCount = self.tableView.data.value.count
            var messages = value.map { FirebaseChatMessage(JSON($0.value)) }
            messages = messages.sorted(by: { $0.created < $1.created })
            
            if previousCount < messages.count {
                self.tableView.data.accept(messages)
                self.tableView.scrollToBottom(animated: true)
            } else {
                self.tableView.data.accept(messages)
            }

        }
        
    }
        
}
