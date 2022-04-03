//
//  LegalViewController.swift
//  Elated
//
//  Created by Marlon on 2021/3/9.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import SideMenu

class LegalViewController: BaseViewController {

    private lazy var menu = self.createMenu(SideMenuViewController.shared)
    private let menuButton = UIBarButtonItem.createMenuButton()
    
    private let privacyButton = UIButton()
    private let termsButton = UIButton()

    private lazy var privacySection = createSection("legal.privacy".localized, image: #imageLiteral(resourceName: "icon-privacypolicy"))
    private lazy var termsSection = createSection("legal.terms".localized, image: #imageLiteral(resourceName: "icon-mobilephone"))

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "menu.item.legal".localized
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
        
        view.addSubview(privacySection)
        privacySection.snp.makeConstraints { make in
            make.top.equalTo(21)
            make.left.equalTo(32)
        }
        
        let arrow1 = UIImageView(image: #imageLiteral(resourceName: "icon-forward"))
        view.addSubview(arrow1)
        arrow1.snp.makeConstraints { make in
            make.centerY.equalTo(privacySection)
            make.right.equalToSuperview().inset(32)
            make.width.height.equalTo(24)
        }
        
        view.addSubview(termsSection)
        termsSection.snp.makeConstraints { make in
            make.top.equalTo(privacySection.snp.bottom).offset(40)
            make.left.equalTo(privacySection)
        }
        
        let arrow2 = UIImageView(image: #imageLiteral(resourceName: "icon-forward"))
        view.addSubview(arrow2)
        arrow2.snp.makeConstraints { make in
            make.centerY.equalTo(termsSection)
            make.right.equalToSuperview().inset(32)
            make.width.height.equalTo(24)
        }
        
        view.addSubview(privacyButton)
        privacyButton.snp.makeConstraints { make in
            make.top.bottom.left.equalTo(privacySection)
            make.right.equalTo(arrow1)
        }

        view.addSubview(termsButton)
        termsButton.snp.makeConstraints { make in
            make.top.bottom.left.equalTo(termsSection)
            make.right.equalTo(arrow2)
        }
        
    }
    
    override func bind() {
        super.bind()
        
        menuButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.present(self.menu, animated: true, completion: nil)
        }.disposed(by: disposeBag)
        
        privacyButton.rx.tap.bind { [weak self] in
            self?.show(TermsViewController(.policy, shouldHideAccept: true), sender: nil)
        }.disposed(by: disposeBag)
        
        termsButton.rx.tap.bind { [weak self] in
            self?.show(TermsViewController(.terms, shouldHideAccept: true), sender: nil)
        }.disposed(by: disposeBag)
        
    }
    
    private func createSection(_ text: String, image: UIImage) -> UIStackView {
        let label = UILabel()
        label.textAlignment = .left
        label.text = text
        label.font = .futuraBook(16)
        
        let icon = UIImageView(image: image)
        icon.contentMode = .scaleAspectFit
        
        let stackView = UIStackView(arrangedSubviews: [icon, label])
        stackView.spacing = 14
        stackView.distribution = .fillProportionally
        stackView.contentMode = .left
        return stackView
    }

}
