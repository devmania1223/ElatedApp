//
//  ProfileGalleryViewController.swift
//  Elated
//
//  Created by Marlon on 2021/3/5.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class ProfileGalleryViewController: ScrollViewController {

    internal let viewModel = ProfileGalleryViewModel()
    
    internal let profileImageView: ZoomImageScrollView  = {
        let view = ZoomImageScrollView(#imageLiteral(resourceName: "odu4"))
        view.imageView.layer.cornerRadius = 6
        view.imageView.contentMode = .scaleAspectFill
        view.imageView.clipsToBounds = true
        return view
    }()
    
    internal let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .futuraMedium(20)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Alexandra J., 24"
        label.lineBreakMode = .byTruncatingMiddle
        return label
    }()
    
    internal let infoLabel: UILabel = {
        let label = UILabel()
        label.font = .futuraBook(14)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "5’4” | Makeup Artist | Los Angeles , CA"
        return label
    }()

    internal let tabView: LayoutTabView = {
        let view = LayoutTabView()
        view.backgroundColor = .white
        return view
    }()
    
    internal let photoLabel: UILabel = {
        let label = UILabel()
        label.font = .futuraMedium(12)
        label.text = "profile.about.photos".localizedFormat("0")
        return label
    }()
    
    private lazy var photosStack: UIStackView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "icon-photo"))
        let stackView = UIStackView(arrangedSubviews: [image, photoLabel])
        stackView.spacing = 6.5
        return stackView
    }()
    
    internal let collectionView = GalleryCollectionView(.view)
    internal let tableView = GalleryTableView()

    private let bottomBackground = UIImageView(image: #imageLiteral(resourceName: "Assets_Graphics_Bottom_Curve"))
    internal let nextButton = UIButton.createCommonBottomButton("signup.createAccount")
    
    internal let mediaOptionPopup = MediaOptionPopupView()
    
    private var isOnboarding: Bool = false // Profile Preview Mode after profile registration
        
    init(userId: Int? = nil, isOnboarding: Bool = false) {
        super.init(nibName: nil, bundle: nil)
        self.isOnboarding = isOnboarding
        //sending userId == viewing
        viewModel.userViewID.accept(userId)
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
        viewModel.getProfile()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabView.addShadowLayer()
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        if isOnboarding {
            scrollView.snp.makeConstraints { make in
                // -133 height of the bottomBackground image with next button
                make.bottom.equalToSuperview().offset(-133)
            }
        }
        
        contentView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(48)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(UIScreen.main.bounds.width - 32)
        }
        
        let gradientView = UIView()
        gradientView.isUserInteractionEnabled = false
        gradientView.layer.masksToBounds = true
        gradientView.layer.cornerRadius = 5
        contentView.addSubview(gradientView)
        gradientView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(profileImageView)
        }
        gradientView.addGradientLayer(height: 100)
            
        contentView.addSubview(infoLabel)
        infoLabel.snp.makeConstraints { make in
            make.left.right.equalTo(profileImageView).inset(24)
            make.bottom.equalTo(profileImageView.snp.bottom).inset(24)
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.right.equalTo(infoLabel)
            make.bottom.equalTo(infoLabel.snp.top).offset(-8)
        }
        
        contentView.addSubview(tabView)
        tabView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
        }

        contentView.addSubview(photosStack)
        photosStack.snp.makeConstraints { make in
            make.top.equalTo(tabView.snp.bottom).offset(16)
            make.left.equalTo(profileImageView)
        }
        
        setupGridView()
        
    }
    
    internal func setupTileView() {
        tableView.removeFromSuperview()
        contentView.addSubview(collectionView)
        photoLabel.text = "profile.about.photos".localizedFormat("\(collectionView.data.value.count)")
        collectionView.snp.remakeConstraints { make in
            make.top.equalTo(photosStack.snp.bottom).offset(16)
            make.left.right.equalTo(profileImageView)
            make.bottom.equalToSuperview().offset(-28)
        }
    }
    
    internal func setupGridView() {
        collectionView.removeFromSuperview()
        contentView.addSubview(tableView)
        photoLabel.text = "profile.about.photos".localizedFormat("\(tableView.data.value.count)")
        tableView.snp.remakeConstraints { make in
            make.top.equalTo(photosStack.snp.bottom).offset(16)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-28)
            make.height.equalTo(CGFloat(tableView.data.value.count) * UIScreen.main.bounds.width + (CGFloat(tableView.data.value.count) * 130/*extra spaces*/))
        }
    }
    
    private func setupViewAsPreview() {
        
        //call when the profile view is for preview
        view.addSubview(bottomBackground)
        bottomBackground.snp.makeConstraints { make in
            make.height.equalTo(135) //including offset 2
            make.left.equalToSuperview().offset(-2)
            make.right.bottom.equalToSuperview().offset(2)
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.centerY.equalTo(bottomBackground)
            make.left.right.equalToSuperview().inset(33)
            make.height.equalTo(50)
        }
        
        scrollView.snp.remakeConstraints({ make in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(bottomBackground.snp.top)
        })
        
    }
    
    override func bind() {
        super.bind()
        bindView()
        bindEvent()
    }

}

