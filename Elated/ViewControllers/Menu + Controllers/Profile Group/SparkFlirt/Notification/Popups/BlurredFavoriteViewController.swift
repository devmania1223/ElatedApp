//
//  BlurredFavoriteViewController.swift
//  Elated
//
//  Created by Rey Felipe on 12/2/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class BlurredFavoriteViewController: ScrollViewController {
    
    private let bottomBackground = UIImageView(image: #imageLiteral(resourceName: "lower_background"))
    private let unlockButton = UIButton.createCommonBottomButton("favorites.button.unlock")
    private let laterButton: UIButton = {
        let button = UIButton.createButtonWithShadow("common.maybe.later", with: true)
        button.borderWidth = 0.25
        button.borderColor = .silver
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .eerieBlack
        label.text = "favorites.favored.someone".localized
        label.font = .futuraMedium(22)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let profileImageView: UIImageView = {
        //let imageView = UIImageView(image: #imageLiteral(resourceName: "profile-placeholder"))
        let imageView = UIImageView(image: #imageLiteral(resourceName: "h3"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 60
        imageView.layer.borderWidth = 0
        imageView.applyBlurEffect()
        //TODO: blur effect should be applied based on favorite status
        //TODO: update profile image
        return imageView
    }()

    private let favedImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "icon-notification-favorite"))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.layer.borderWidth = 5
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grayColor
        label.font = .futuraMedium(14)
        label.text = "favorites.favored.unlock".localized
        label.numberOfLines = 0
        label.textAlignment = .center
        //TODO: should show localized price on lebel text
        return label
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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
        
        contentView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(120)
        }
        
        contentView.addSubview(favedImageView)
        favedImageView.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(profileImageView)
            make.height.width.equalTo(40)
        }
        
        contentView.addSubview(bodyLabel)
        bodyLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.left.right.equalTo(titleLabel)
        }
        
        contentView.addSubview(unlockButton)
        unlockButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(200)
            make.top.equalTo(bodyLabel.snp.bottom).offset(40)
        }
        
        contentView.addSubview(laterButton)
        laterButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(200)
            make.top.equalTo(unlockButton.snp.bottom).offset(20)
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
        
        unlockButton.rx.tap.bind { [weak self] in
            //TODO: Add in-App purchase implementation here
        }.disposed(by: disposeBag)
        
        laterButton.rx.tap.bind { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)
    }
    
}
