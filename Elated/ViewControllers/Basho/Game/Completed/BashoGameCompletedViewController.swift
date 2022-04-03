//
//  BashoGameCompletedViewController.swift
//  Elated
//
//  Created by Marlon on 8/14/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import SwiftyJSON

class BashoGameCompletedViewController: BaseViewController {
    
    internal let viewModel = BashoGameCompletedViewModel()
    
    internal var reviewer: ReviewerSparkFlirtHistory

    internal let lockImageView = UIImageView(image: #imageLiteral(resourceName: "icon-chat-unlock-1"))
    
    internal let backButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icon-back").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        return button
    }()

    internal let topLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .futuraMedium(24)
        label.textAlignment = .center
        return label
    }()
    
    internal let profileImageView1: UIImageView = {
        let view = UIImageView(image: #imageLiteral(resourceName: "h8"))
        view.layer.cornerRadius = 21
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    internal let profileImageView2: UIImageView = {
        let view = UIImageView(image: #imageLiteral(resourceName: "h6"))
        view.layer.cornerRadius = 21
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    internal let poemLabel: UILabel = {
        let label = UILabel()
        label.textColor = .elatedPrimaryPurple
        label.font = .futuraBold(20)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    internal let bashoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .jet
        label.font = .futuraBold(14)
        label.textAlignment = .center
        label.text = "basho.by".localized
        return label
    }()
    
    internal lazy var wordsBgView: UIView = {
        let view = UIView()
        view.backgroundColor = .palePurplePantone
        view.layer.cornerRadius = 10
    
        view.addSubview(poemLabel)
        poemLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.left.right.equalToSuperview().inset(22)
        }
        
        view.addSubview(bashoLabel)
        bashoLabel.snp.makeConstraints { make in
            make.left.equalTo(poemLabel)
        }
        
        view.addSubview(profileImageView1)
        profileImageView1.snp.makeConstraints { make in
            make.top.equalTo(poemLabel.snp.bottom).offset(22)
            make.left.equalTo(bashoLabel.snp.right).offset(8)
            make.centerY.equalTo(bashoLabel)
            make.width.height.equalTo(42)
        }
        
        view.addSubview(profileImageView2)
        profileImageView2.snp.makeConstraints { make in
            make.left.equalTo(profileImageView1.snp.right).offset(8)
            make.top.equalTo(profileImageView1)
            make.width.height.equalTo(42)
            make.bottom.equalToSuperview().inset(24)
        }
        
        return view
    }()
    
    private lazy var anotherGameButton = UIButton.createCommonBottomButton("basho.try.another")

    private lazy var completeButton = UIButton.createCommonBottomButton("basho.complete.sparkFlirt")
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    private var fallbackViewController: AnyClass? = nil
    
    init(_ detail: BashoGameDetail,
         fallbackViewController: AnyClass? = nil) {
        
        //initiate reviewer
        let otherUser = MemCached.shared.isSelf(id: detail.invitee?.id)
                  ? detail.invitee?.id
                  : detail.inviter?.id
        reviewer = ReviewerSparkFlirtHistory(otherUserID: otherUser!)
        
        super.init(nibName: nil, bundle: nil)
        
        viewModel.detail.accept(detail)
        backButton.isHidden = fallbackViewController != nil
        topLabel.text = "basho.complete.congrats".localized
        poemLabel.text = detail.basho.map { $0.line }.joined(separator: " ")
        self.fallbackViewController = fallbackViewController
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.hideNavBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //IQKeyboardManager.shared.enable = true
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func initSubviews() {
        super.initSubviews()

        let bg = UIImageView(image: #imageLiteral(resourceName: "Basho BG"))
        view.addSubview(bg)
        bg.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(-2)
            make.right.equalToSuperview().offset(2)
        }
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(8)
            make.width.height.equalTo(40)
        }
        backButton.isHidden = fallbackViewController == nil ? true : false
    
        view.addSubview(lockImageView)
        lockImageView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(22)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(75)
        }
        
        view.addSubview(topLabel)
        topLabel.snp.makeConstraints { make in
            make.top.equalTo(lockImageView.snp.bottom).offset(26)
            make.left.right.equalToSuperview().inset(23)
        }
        
        view.addSubview(wordsBgView)
        wordsBgView.snp.makeConstraints { make in
            make.top.equalTo(topLabel.snp.bottom).offset(44)
            make.left.right.equalToSuperview().inset(23)
        }
        
        view.addSubview(anotherGameButton)
        anotherGameButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(50)
            make.height.equalTo(50)
        }
        
        view.addSubview(completeButton)
        completeButton.snp.makeConstraints { make in
            make.top.equalTo(anotherGameButton.snp.bottom).offset(18)
            make.left.right.bottom.equalToSuperview().inset(50)
            make.height.equalTo(50)
        }
        completeButton.backgroundColor = .white
        completeButton.setTitleColor(.elatedPrimaryPurple, for: .normal)
        
    }
    
    override func bind() {
        super.bind()
        
        anotherGameButton.rx.tap.bind {
            let vc = MenuTabBarViewController([.navigateSparkFlirtInvite])
            vc.selectedIndex = MenuTabBarViewController.MenuIndex.sparkFlirt.rawValue
            let landingNav = UINavigationController(rootViewController: vc)
            Util.setRootViewController(landingNav)
        }.disposed(by: disposeBag)
        
        completeButton.rx.tap.bind { _ in
            let vc = MenuTabBarViewController([.navigateSparkFlirtInvite])
            vc.selectedIndex = MenuTabBarViewController.MenuIndex.sparkFlirt.rawValue
            let landingNav = UINavigationController(rootViewController: vc)
            Util.setRootViewController(landingNav)
        }.disposed(by: disposeBag)
        
        backButton.rx.tap.bind { [weak self] in
            guard let fallbackViewController = self?.fallbackViewController else {
                return
            }
            self?.goBack(to: fallbackViewController)
        }.disposed(by: rx.disposeBag)
        
    }
            
}
