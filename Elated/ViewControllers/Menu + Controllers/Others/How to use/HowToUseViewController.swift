//
//  HowToUseViewController.swift
//  Elated
//
//  Created by Marlon on 2021/3/9.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import SideMenu

class HowToUseViewController: BaseViewController {

    private let  viewModel = HowToUseViewModel()
    private lazy var menu = self.createMenu(SideMenuViewController.shared)
    private let menuButton = UIBarButtonItem.createMenuButton()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(HowToUseTableViewCell.self,
                      forCellReuseIdentifier: HowToUseTableViewCell.identifier)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .elatedPrimaryPurple
        button.setTitle("howToUse.share.all".localized, for: .normal)
        button.layer.cornerRadius = 25
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "menu.item.howToUse".localized
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
        tableView.reloadData()
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(12)
            make.left.right.equalToSuperview()
        }
        
        view.addSubview(shareButton)
        shareButton.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(32)
            make.bottom.equalToSuperview().inset(50)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(32)
        }
        
    }
    
    override func bind() {
        super.bind()
        
        menuButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.present(self.menu, animated: true, completion: nil)
        }.disposed(by: disposeBag)
        
        shareButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }

        }.disposed(by: rx.disposeBag)
    }
    
}

extension HowToUseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HowToUseTableViewCell.identifier)
            as? HowToUseTableViewCell ?? HowToUseTableViewCell()
        let tutorial = HowToUseViewModel.Tutorial(rawValue: indexPath.row) ?? .thisOrThat
        cell.set(tutorial.getTitle(), icon: tutorial.getIcon())
        return cell
    }

}

extension HowToUseViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let tutorial = HowToUseViewModel.Tutorial(rawValue: indexPath.row) {
            switch tutorial {
            case .thisOrThat:
                self.show(ThisOrThatTutorialIntroViewController(), sender: nil)
                break
            case .sparkFlirt:
                self.show(SparkFlirtTutorialIntroViewController(), sender: nil)
                break
            case .basho:
                self.show(BashoTutorialIntroViewController(), sender: nil)
                break
            case .storyShare:
                self.show(StoryShareTutorialIntroViewController(), sender: nil)
                break
            case .emojiGo:
                self.show(EmojiGoTutorialIntroViewController(), sender: nil)
                break
            }
        }
    }
}
