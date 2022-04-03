//
//  ProfilePhotoViewController.swift
//  Elated
//
//  Created by Marlon on 4/30/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift

class ProfilePhotoViewController: ScrollViewController {
    
    let viewModel = ProfilePhotoViewModel()
    
    internal let profileImageView: ZoomImageScrollView  = {
        let view = ZoomImageScrollView(nil)
        view.imageView.contentMode = .scaleAspectFill
        view.imageView.clipsToBounds = true
        return view
    }()
    
    internal let profileGradientView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.layer.masksToBounds = true
        view.isHidden = true
       return view
    }()
    
    internal let profileLogoView: UIImageView  = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    internal let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .eerieBlack
        label.font = .futuraBook(16)
        return label
    }()
    
    internal let commentButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icon-comment"), for: .normal)
        return button
    }()

    internal let optionButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icon-options"), for: .normal)
        return button
    }()
    
    internal let captionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .futuraBook(16)
        label.numberOfLines = 0
        return label
    }()
    
    internal let shadowView = UIView()
    
    internal let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icons-matches"), for: .normal)
        return button
    }()
    
    internal let likeLabel: UILabel = {
        let label = UILabel()
        label.text = "0 Likes and others like this photo"
        label.font = .futuraBook(16)
        label.textColor = .sonicSilver
        return label
    }()
    
    internal let textView: UITextView = {
        let textView = UITextView()
        textView.font = .futuraBook(14)
        textView.textColor = .sonicSilver
        textView.backgroundColor = .alabasterSolid
        textView.layer.borderWidth = 0.25
        textView.layer.borderColor = UIColor.silver.cgColor
        textView.layer.cornerRadius = 6
        textView.textContainerInset = UIEdgeInsets(top: 21, left: 16, bottom: 21, right: 16)
        textView.isHidden = true
        return textView
    }()
    
    internal let editView = EditPopupView()
    
    internal lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissEditView)))
        view.isHidden = true
        return view
    }()

    init(_ type: ProfilePhotoViewModel.ScreenType,
         profileImage: ProfileImage,
         mainImage: ProfileImage,
         name: String) {
        super.init(nibName: nil, bundle: nil)
        viewModel.type.accept(type)
        viewModel.profileImage.accept(profileImage)
        viewModel.mainImage.accept(mainImage)
        viewModel.name.accept(name)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupNavigationBar(.white,
                                font: .futuraMedium(20),
                                tintColor: .white,
                                backgroundImage: #imageLiteral(resourceName: "background-header"),
                                additionalBarHeight: true,
                                addBackButton: true)
        self.title = "profile.photo".localized
        shadowView.addShadowLayer()
        profileImageView.addShadowLayer()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        textView.isHidden = true
        likeButton.isHidden = false
        likeLabel.isHidden = false
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        view.addSubview(profileLogoView)
        profileLogoView.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.left.equalTo(16)
            make.height.width.equalTo(40)
        }
        
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileLogoView)
            make.left.equalTo(profileLogoView.snp.right).offset(12)
        }
        
        view.addSubview(optionButton)
        optionButton.snp.makeConstraints { make in
            make.centerY.equalTo(profileLogoView)
            make.left.equalTo(nameLabel.snp.right).offset(12)
            make.right.equalToSuperview().inset(16)
            make.height.width.equalTo(24)
        }
        
        view.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(profileLogoView.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.width)
        }
        
        view.addSubview(profileGradientView)
        profileGradientView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView)
            make.bottom.right.equalTo(profileImageView).offset(3)
            make.left.equalTo(profileImageView).offset(-3)
        }
        profileGradientView.addGradientLayer(height: self.view.frame.width)
        
        view.addSubview(shadowView)
        shadowView.snp.makeConstraints { make in
            make.bottom.left.right.equalTo(profileImageView)
            make.height.equalTo(UIScreen.main.bounds.width / 4)
        }
        
        view.addSubview(likeButton)
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(18)
            make.left.equalToSuperview().inset(16)
            make.width.equalTo(24)
            make.height.equalTo(20)
        }
        
        view.addSubview(likeLabel)
        likeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(likeButton)
            make.left.equalTo(likeButton.snp.right).offset(8)
            make.right.equalToSuperview().inset(16)
        }
        
        view.addSubview(captionLabel)
        captionLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.bottom.equalTo(profileImageView.snp.bottom).inset(16)
        }
        
        view.addSubview(commentButton)
        commentButton.snp.makeConstraints { make in
            make.left.equalTo(captionLabel.snp.right)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalTo(profileImageView).inset(12)
            make.height.width.equalTo(35)
        }
        
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(12)
            make.left.right.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().inset(12)
        }
        
        view.addSubview(editView)
        editView.isHidden = true
        editView.snp.makeConstraints { make in
            make.top.equalTo(optionButton.snp.bottom).offset(8)
            make.right.equalTo(optionButton).offset(5)
        }
        
        view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        view.bringSubviewToFront(editView)
        
    }

    override func bind() {
        super.bind()
        bindView()
        bindEvent()
    }
    
    @objc func dismissEditView() {
        likeButton.isHidden = false
        likeLabel.isHidden = false
        editView.isHidden = true
        bgView.isHidden = true
    }
    
}
