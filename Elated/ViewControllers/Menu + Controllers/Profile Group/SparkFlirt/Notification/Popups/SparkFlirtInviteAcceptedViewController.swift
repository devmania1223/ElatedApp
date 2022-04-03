//
//  SparkFlirtInviteAcceptedViewController.swift
//  Elated
//
//  Created by Rey Felipe on 12/3/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class SparkFlirtInviteAcceptedViewController: ScrollViewController {
    
    private let bottomBackground = UIImageView(image: #imageLiteral(resourceName: "lower_background"))
    private let continueButton = UIButton.createCommonBottomButton("common.continue")
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .eerieBlack
        label.text = ""
        label.font = .futuraMedium(22)
        label.textAlignment = .center
        label.numberOfLines = 0
        //TODO: should show sender's name on lebel text
        return label
    }()
    
    private let inviterImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "profile-placeholder"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 60
        imageView.layer.borderWidth = 0
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    private let sfLogoImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "button-sparkflirt"))
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 30
        imageView.layer.borderWidth = 7
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    private let inviteeImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "profile-placeholder"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 60
        imageView.layer.borderWidth = 0
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private var invitee: UserInfoShort?
    
    init(invitee: UserInfoShort) {
        super.init(nibName: nil, bundle: nil)
        
        guard let me = MemCached.shared.userInfo else { return }
        
        self.invitee = invitee
        
        titleLabel.text = "sparkFlirt.invite.accepted.title".localizedFormat(invitee.getDisplayName())
            
        inviteeImageView.kf.setImage(with: URL(string: invitee.avatar?.image ?? ""),
                                     placeholder: #imageLiteral(resourceName: "profile-placeholder"))
        inviterImageView.kf.setImage(with: URL(string: me.profileImages.first?.image ?? ""),
                                     placeholder: #imageLiteral(resourceName: "profile-placeholder"))

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.setupNavigationBar(.elatedPrimaryPurple,
                                font: .futuraMedium(20),
                                tintColor: .elatedPrimaryPurple,
                                backgroundColor: .white,
                                backgroundImage: nil,
                                addBackButton: false)
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        view.backgroundColor = .white
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(40)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(30)
        }
        
        let playersView = UIView()
        contentView.addSubview(playersView)
        playersView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.width.equalTo(270)
            make.height.equalTo(120)
        }
        
        playersView.addSubview(inviterImageView)
        inviterImageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.height.width.equalTo(120)
        }
        inviterImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapInviterProfileImage)))
        
        playersView.addSubview(inviteeImageView)
        inviteeImageView.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
            make.height.width.equalTo(120)
        }
        inviteeImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapInviteeProfileImage)))
        
        playersView.addSubview(sfLogoImageView)
        sfLogoImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(60)
        }
        
        contentView.addSubview(continueButton)
        continueButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(200)
            make.top.equalTo(playersView.snp.bottom).offset(60)
            make.bottom.equalToSuperview().offset(-25)
        }
        
        view.addSubview(bottomBackground)
        bottomBackground.snp.makeConstraints { make in
            make.height.equalTo(135)
            make.left.equalToSuperview().offset(-2)
            make.right.equalToSuperview().offset(2)
            make.bottom.equalToSuperview().offset(Util.heigherThanIphone6 ? 2 : 100)
        }
        view.bringSubviewToFront(scrollView)
        
        navigationController?.hideNavBar()
        centerContentViewIfNeeded(offset: Util.heigherThanIphone6 ? 133 : 35)
    }
    
    override func bind() {
        super.bind()
        
        continueButton.rx.tap.bind { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)
    }
    
    @objc func didTapInviteeProfileImage() {
        guard let userId = invitee?.id else { return }
    
        let vc = ProfilePageViewController("profile.view.main".localized, viewUserID: userId)
        self.show(vc, sender: nil)
    }
    
    @objc func didTapInviterProfileImage() {
        guard let me = MemCached.shared.userInfo,
              let userId = me.id
        else { return }
        
        let vc = ProfilePageViewController("profile.view.main".localized, viewUserID: userId)
        self.show(vc, sender: nil)
    }
}
