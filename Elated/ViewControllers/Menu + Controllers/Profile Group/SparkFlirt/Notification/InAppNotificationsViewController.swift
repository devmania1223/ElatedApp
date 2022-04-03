//
//  InAppNotificationsViewController.swift
//  Elated
//
//  Created by Rey Felipe on 11/15/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class InAppNotificationsViewController: BaseViewController {
    
    let viewModel = InAppNotificationsViewModel()
    let sparkFlirtViewModel = SparkFlirtCommonViewModel()

    let tableView = InAppNotificationsTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "inapp.notification.title".localized
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.setupNavigationBar(.white,
                                font: .futuraMedium(20),
                                tintColor: .white,
                                backgroundImage: #imageLiteral(resourceName: "background-header"),
                                additionalBarHeight: true,
                                addBackButton: true)
        
        viewModel.getNotifications(1)
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
    }
    
    override func bind() {
        super.bind()

        // View bindings
        viewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)
        
        viewModel.notifs.bind(to: tableView.data).disposed(by: disposeBag)
//        
//        viewModel.presentAlert.subscribe( onNext: { [weak self] args in
//            let (title, message) = args
//            self?.presentAlert(title: title, message: message)
//        }).disposed(by: disposeBag)
        
        tableView.didSelect.subscribe(onNext: { [weak self] index in
            guard let self = self else { return }
            let notif = self.viewModel.notifs.value[index]
            guard let notificationId = notif.id else { return }
            self.viewModel.selectedIndex.accept(index)
            // Call markasread endpoint if needed
            if !notif.isRead {
                self.viewModel.notificationMarkAsRead(notificationId, index: index)
            }
            // TODO: load the correct notification action, clean up later, move this to a separate function
            switch notif.type {
            case .gameCanceledEmojiGo, .gameCompletedEmojiGo, .gameTurnEmojiGo:
                guard let gameId = notif.actionId, gameId > 0 else { return }
                // Delete notification
                self.viewModel.deleteNotification(notificationId, index: index)
                // Load and Show the Game
                let vc = EmojiGoLoadingViewController(gameId, fallbackViewController: InAppNotificationsViewController.self)
                self.show(vc, sender: nil)
            case .sparkFlirtInvite:
                guard let sparkFlirtId = notif.actionId,
                      sparkFlirtId > 0
                else { return }
                // Check the status of the sparkflirt invite ID first before showing SparkFlirtInviteReceivedViewController
                self.sparkFlirtViewModel.getSparkFlirtDetail(sparkFlirtId)
            case .sparkFlirtInviteAccepted:
                guard let user = notif.sender else { return }
                // Delete notification
                self.viewModel.deleteNotification(notificationId, index: index)
                // Show Invite Accepted screen
                let vc = UINavigationController(rootViewController: SparkFlirtInviteAcceptedViewController(invitee: user))
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
                
            default: break
            }
        }).disposed(by: disposeBag)
        
        tableView.didDelete.subscribe(onNext: { [weak self] index in
            guard let self = self else { return }
            let notif = self.viewModel.notifs.value[index]
            guard let notificationId = notif.id else { return }
            print(notificationId)
            // TODO: call delete notif endpoint
            self.viewModel.deleteNotification(notificationId, index: index)
        }).disposed(by: disposeBag)
        
//        
//        tableView.getMoreResults.subscribe(onNext: { [weak self] index in
//            guard let self = self else { return }
//            self.viewModel.getSparkFlirtPurchaseHistory()
//        }).disposed(by: disposeBag)
        
        // State Bindings
        sparkFlirtViewModel.receivedSparkFlirtDetails.subscribe(onNext: { [weak self] details in
            guard let self = self else { return }
            let notif = self.viewModel.notifs.value[self.viewModel.selectedIndex.value]
            guard let sender = notif.sender,
                  let sparkFlirtID = notif.actionId,
                  sparkFlirtID > 0,
                  let status = details?.status
            else { return }
            switch status {
            case .active, .cancelled, .completed:
                self.presentAlert(title: "inapp.notification.alert.sparkflirt.invite.title".localized,
                                  message: "inapp.notification.alert.sparkflirt.invite.accepted.message".localizedFormat(sender.getDisplayName()))
                // Delete notification
                guard let notificationId = notif.id else { return }
                self.viewModel.deleteNotification(notificationId, index: self.viewModel.selectedIndex.value)
                break
            case .expired:
                self.presentAlert(title: "inapp.notification.alert.sparkflirt.invite.title".localized,
                                  message: "inapp.notification.alert.sparkflirt.invite.expired.message".localizedFormat(sender.getDisplayName()))
                // Delete notification
                guard let notificationId = notif.id else { return }
                self.viewModel.deleteNotification(notificationId, index: self.viewModel.selectedIndex.value)
            case .rejected:
                self.presentAlert(title: "inapp.notification.alert.sparkflirt.invite.title".localized,
                                  message: "inapp.notification.alert.sparkflirt.invite.declined.message".localizedFormat(sender.getDisplayName()))
                // Delete notification
                guard let notificationId = notif.id else { return }
                self.viewModel.deleteNotification(notificationId, index: self.viewModel.selectedIndex.value)
            case .sent:
                let vc = SparkFlirtInviteReceivedViewController(sender: sender, sparkFlirtId: sparkFlirtID)
                vc.acceptHandler = {
                    // Show Game Option Screen
                    let user = MatchWith(userInfoShort: sender)
                    let vc = GameOptionsViewController(sparkFlirtID, playWith: user)
                    self.show(vc, sender: nil)
                    
                    // Delete notification
                    guard let notificationId = notif.id else { return }
                    self.viewModel.deleteNotification(notificationId, index: self.viewModel.selectedIndex.value)
                }
                vc.declineHandler = {
                    // Delete notification
                    guard let notificationId = notif.id else { return }
                    self.viewModel.deleteNotification(notificationId, index: self.viewModel.selectedIndex.value)
                }
                self.show(vc, sender: nil)
            case .none:
                break
            }
            
            
        }).disposed(by: disposeBag)
        
    }

}
