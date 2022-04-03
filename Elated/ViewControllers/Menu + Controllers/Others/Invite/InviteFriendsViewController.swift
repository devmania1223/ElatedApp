//
//  InviteFriendsViewController.swift
//  Elated
//
//  Created by Marlon on 2021/3/9.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import SideMenu
import MessageUI

class InviteFriendsViewController: BaseViewController, UINavigationControllerDelegate {

    enum InviteType: Int {
        case sms
        case email
        case whatsApp
        case weChat
        case other
        
        func getName() -> String {
            switch self {
            case .sms:
                return "invite.main.sms".localized
            case .email:
                return "invite.main.email".localized
            case .whatsApp:
                return "invite.main.whatsApp".localized
            case .weChat:
                return "invite.main.weChat".localized
            case .other:
                return "invite.main.other".localized
            }
        }
        
        func getImage() -> UIImage {
            switch self {
                case .sms:
                    return #imageLiteral(resourceName: "icon-mobilephone")
                case .email:
                    return #imageLiteral(resourceName: "icon-email-purple")
                case .whatsApp:
                    return #imageLiteral(resourceName: "icon-whatsapp")
                case .weChat:
                    return #imageLiteral(resourceName: "icon-wechat")
                case .other:
                    return #imageLiteral(resourceName: "icon-share")
            }
        }
        
    }
    
    internal lazy var menu = self.createMenu(SideMenuViewController.shared)
    internal let menuButton = UIBarButtonItem.createMenuButton()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "invite.main.title".localized
        label.textColor = .jet
        label.font = .futuraMedium(16)
        return label
    }()
    
    private lazy var tableview: UITableView = {
        let view = UITableView()
        view.backgroundColor = .white
        view.register(MenuItemTableViewCell.self,
                      forCellReuseIdentifier: MenuItemTableViewCell.identifier)
        view.separatorStyle = .none
        view.separatorColor = .clear
        view.estimatedRowHeight = 70
        view.rowHeight = UITableView.automaticDimension
        view.tableFooterView = UIView()
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "menu.item.inviteFriends".localized
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.leftBarButtonItem = menuButton
        menuButton.tintColor = .white
        self.setupNavigationBar(.white,
                                font: .futuraMedium(20),
                                tintColor: .white,
                                backgroundImage: #imageLiteral(resourceName: "background-header"))
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview().inset(34)
        }
        
        view.addSubview(tableview)
        tableview.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(14)
            make.bottom.left.right.equalToSuperview()
        }
        
    }
    
    override func bind() {
        super.bind()
        
        menuButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.present(self.menu, animated: true, completion: nil)
        }.disposed(by: disposeBag)
    }

    private func shareSMS() {
        let composeVC = MFMessageComposeViewController()
        composeVC.body = "invite.main.share.link".localized
        composeVC.messageComposeDelegate = self
        
        // Present the view controller modally.
        if MFMessageComposeViewController.canSendText() {
            self.present(composeVC, animated: true, completion: nil)
        } else {
            self.presentAlert(title: "common.error".localized, message: "invite.main.sms.error".localized)
        }
    }
    
    private func shareEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setMessageBody("<p>\("invite.main.share.link".localized)</p>", isHTML: true)
            mail.mailComposeDelegate = self
            
            present(mail, animated: true)
        } else {
            self.presentAlert(title: "common.error".localized, message: "invite.main.mail.error".localized)
        }
    }
    
    private func shareWhatsApp() {
        let urlWhats = "whatsapp://send?text=\("invite.main.share.link".localized)"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
              if let whatsappURL = NSURL(string: urlString) {
                    if UIApplication.shared.canOpenURL(whatsappURL as URL) {
                        UIApplication.shared.open(whatsappURL as URL)
                    } else {
                        self.presentAlert(title: "common.error".localized, message: "invite.main.whatsapp.error".localized)
                    }
              }
        }
    }
    
    private func shareWeChat() {
        let urlWhats = "weChat://send?text=\("invite.main.share.link".localized)"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
              if let whatsappURL = NSURL(string: urlString) {
                    if UIApplication.shared.canOpenURL(whatsappURL as URL) {
                        UIApplication.shared.open(whatsappURL as URL)
                    } else {
                        self.presentAlert(title: "common.error".localized, message: "invite.main.wechat.error".localized)
                    }
              }
        }
    }
    
    private func shareOthers() {
        let text = "https://www.elated.io"
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop,
                                                         UIActivity.ActivityType.addToReadingList,
                                                         UIActivity.ActivityType.assignToContact]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}

extension InviteFriendsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5 //constant
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuItemTableViewCell.identifier)
            as? MenuItemTableViewCell ?? MenuItemTableViewCell()
        if let type = InviteType(rawValue: indexPath.row) {
            cell.set(image: type.getImage(), name: type.getName())
        }
        return cell
    }
}

extension InviteFriendsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let type = InviteType(rawValue: indexPath.row) {
            switch type {
                case .sms:
                    shareSMS()
                    return
                case .email:
                    shareEmail()
                    return
                case .whatsApp:
                    shareWhatsApp()
                    return
                case .weChat:
                    shareWeChat()
                    return
                case .other:
                    shareOthers()
                    return
            }
        }
    }
    
}

extension InviteFriendsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
        controller.dismiss(animated: true)
    }
}

extension InviteFriendsViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                      didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true)
    }
}
