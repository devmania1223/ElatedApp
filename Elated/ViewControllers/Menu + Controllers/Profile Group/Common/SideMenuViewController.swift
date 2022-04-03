//
//  SideViewController.swift
//  Elated
//
//  Created by Marlon on 2021/3/2.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import SideMenu

class SideMenuViewController: BaseViewController {

    static let shared = SideMenuViewController()

    private let viewModel = SideMenuViewModel()
    
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        view.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        view.separatorStyle = .none
        view.backgroundColor = .clear
        view.delegate = self
        view.dataSource = self
        view.register(CommonTableViewTextCell.self,
                      forCellReuseIdentifier: CommonTableViewTextCell.identifier)
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 30
        view.contentMode = .scaleAspectFit
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.borderColor = .white
        view.borderWidth = 2
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let nameAgeLabel: UILabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = .futuraMedium(16)
        view.text = "Elated User, 19"
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let profileButton: UIButton = {
        let view = UIButton()
        view.titleLabel?.textColor = UIColor.white.withAlphaComponent(0.5)
        view.titleLabel?.font = .futuraBook(14)
        view.setTitle("menu.button.profile".localized, for: .normal)
        return view
    }()
    
    private let logoutButton: UIButton = {
        let view = UIButton()
        view.titleLabel?.textColor = .white
        view.titleLabel?.font = .futuraBook(16)
        view.setTitle("menu.button.logout".localized, for: .normal)
        return view
    }()
    
    private let lineTop: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let lineBottom: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var versionLabel: UILabel = {
        let label = UILabel()
        label.font = .futuraBook(12)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.text = "version \(Environment.appVersion)(\(Environment.appBuild))\(Environment.appEnv)"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getProfile()
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        view.gradientBackground(from: .lavanderFloral,
                                to: .darkOrchid,
                                direction: .topToBottom)
        
        view.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(57)
            make.left.equalTo(16)
            make.height.width.equalTo(60)
        }
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnProfileSection)))
        
        let stackView = UIStackView(arrangedSubviews: [nameAgeLabel, profileButton])
        stackView.axis = .vertical
        stackView.spacing = 1
        stackView.alignment = .leading
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.left.equalTo(profileImageView.snp.right).offset(13)
            make.right.equalToSuperview().inset(16)
        }
        
        nameAgeLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnProfileSection)))
        
        view.addSubview(lineTop)
        lineTop.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(28)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(lineTop.snp.bottom)
            make.left.right.equalToSuperview()
        }
        
        view.addSubview(lineBottom)
        lineBottom.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        view.addSubview(logoutButton)
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(lineBottom.snp.bottom).offset(28)
            make.left.equalTo(16)
            make.height.equalTo(50)
        }
        
        view.addSubview(versionLabel)
        versionLabel.snp.makeConstraints { make in
            make.top.equalTo(logoutButton.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(25)
        }
        
    }
    
    override func bind() {
        super.bind()
        
        viewModel.nameAge.bind(to: nameAgeLabel.rx.text).disposed(by: disposeBag)
        
        viewModel.images.subscribe(onNext: { [weak self] args in
            self?.profileImageView.kf.setImage(with: URL(string: args.first?.image ?? ""), placeholder: #imageLiteral(resourceName: "profile-placeholder"))
        }).disposed(by: disposeBag)
        
        profileButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            if self.viewModel.activeScreen.value != .profile {
                self.viewModel.activeScreen.accept(.profile)
                self.navigationController?.pushViewController(MenuTabBarViewController(), animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }.disposed(by: disposeBag)
        
        logoutButton.rx.tap.bind {
            self.presentAlert(title: "logout.alert.title".localized,
                              message: "logout.alert.message".localized,
                              buttonTitles: ["common.cancel".localized, "logout.alert.title".localized],
                              highlightedButtonIndex: 0) { index in
                if index == 1 {
                    NotificationCenter.default.post(Notification(name: .userLogout))
                }
            }
        }.disposed(by: disposeBag)

        NotificationCenter.default.rx.notification(.userLogout)
            .subscribe(onNext: { [weak self] _ in
                UserDefaults.standard.clearUserData()
                Util.setRootViewController(UINavigationController(rootViewController: LandingViewController()))
                self?.viewModel.unregisterNotification()
            }).disposed(by: rx.disposeBag)
        
    }
    
    @objc func didTapOnProfileSection() {
        if self.viewModel.activeScreen.value != .profile {
            self.viewModel.activeScreen.accept(.profile)
            self.navigationController?.pushViewController(MenuTabBarViewController(), animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }

}

extension SideMenuViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommonTableViewTextCell.identifier)
            as? CommonTableViewTextCell ?? CommonTableViewTextCell()
        cell.set(viewModel.titles[indexPath.row].localized)
        return cell
    }
    
}

extension SideMenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let title = viewModel.titles[indexPath.row]
        let option = SideMenuViewModel.MenuOption(rawValue: title) ?? .profile
        let activeScreen = viewModel.activeScreen.value
        let nav = self.navigationController
        
        switch (option, activeScreen != option) {
        case (.sparkFlirt, true):
            viewModel.activeScreen.accept(.sparkFlirt)
            nav?.pushViewController(SparkFlirtPageSettingsViewController(), animated: true)
        case (.settings, true):
            viewModel.activeScreen.accept(.settings)
            nav?.pushViewController(SettingsViewController.instantiate(), animated: true)
        case (.inviteFriends, true):
            viewModel.activeScreen.accept(.inviteFriends)
            nav?.pushViewController(InviteFriendsViewController(), animated: true)
        case (.howToUse, true):
            viewModel.activeScreen.accept(.howToUse)
            nav?.pushViewController(HowToUseViewController(), animated: true)
        case (.contactUs, true):
            viewModel.activeScreen.accept(.contactUs)
            nav?.pushViewController(ContactUsViewController(), animated: true)
        case (.legal, true):
            viewModel.activeScreen.accept(.legal)
            nav?.pushViewController(LegalViewController(), animated: true)
        default:
            dismiss(animated: true, completion: nil)
        }
        
    }
    
}
