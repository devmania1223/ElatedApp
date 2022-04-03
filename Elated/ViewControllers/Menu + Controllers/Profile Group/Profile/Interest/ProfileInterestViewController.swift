//
//  ProfileInterestViewController.swift
//  Elated
//
//  Created by Marlon on 2021/3/5.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class ProfileInterestViewController: ScrollViewController {

    let viewModel = ProfileInterestViewModel()
    
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
    
    private lazy var likesStack = createTitleStack("profile.interests.likes", icon: #imageLiteral(resourceName: "icon-like-sub"))
    internal lazy var likesCollectionView = CommonCollectionView(isEdit: false)

    private lazy var dislikesStack = createTitleStack("profile.interests.dislikes", icon: #imageLiteral(resourceName: "icon-dislike"))
    internal lazy var dislikesCollectionView = CommonCollectionView(isEdit: false)
    
    
    internal lazy var booksStack = createTitleStack("profile.interests.favoriteBooks", icon: #imageLiteral(resourceName: "icon-books"))
    internal lazy var booksCollectionView = BookCollectionView(shouldHideDeleteButton: true)
    
    internal lazy var addBookView: AddDeleteTableViewCell = {
        let view = AddDeleteTableViewCell()
        view.setData(#imageLiteral(resourceName: "icon-books-bg"), imageURL: nil, title: "profile.interests.addMoreBooks".localized, type: .add)
        view.button.isUserInteractionEnabled = false
        return view
    }()

    internal lazy var spotifyStack = createTitleStack("profile.interests.favoriteArtistsSpotify", icon: #imageLiteral(resourceName: "icon-music"))
    internal lazy var spotifyTableView: AddDeleteTableView = {
        let tableView = AddDeleteTableView()
        return tableView
    }()
    
    internal lazy var addMusicView: AddDeleteTableViewCell = {
        let view = AddDeleteTableViewCell()
        view.isHidden = true
        
        view.setData(#imageLiteral(resourceName: "icon-spotify"),
                     imageURL: nil,
                     title: "profile.interests.addSpotify".localized,
                     type: .add)
        view.button.isUserInteractionEnabled = false
        return view
    }()

    private let bottomBackground = UIImageView(image: #imageLiteral(resourceName: "Assets_Graphics_Bottom_Curve"))
    
    internal let nextButton = UIButton.createCommonBottomButton("signup.createAccount")
    
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
        viewModel.getBooks(initialPage: true)
        viewModel.getMusic()
        viewModel.getArtist()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        //to layout
        likesCollectionView.reloadData()
        dislikesCollectionView.reloadData()
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
        
        contentView.addSubview(likesStack)
        likesStack.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(24)
            make.left.equalTo(profileImageView).inset(16)
        }
        
        contentView.addSubview(likesCollectionView)
        likesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(likesStack.snp.bottom).offset(16)
            make.left.right.equalTo(profileImageView).inset(16)
        }
        
        contentView.addSubview(dislikesStack)
        dislikesStack.snp.makeConstraints { make in
            make.top.equalTo(likesCollectionView.snp.bottom).offset(33)
            make.left.equalTo(likesCollectionView)
        }
        
        contentView.addSubview(dislikesCollectionView)
        dislikesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(dislikesStack.snp.bottom).offset(16)
            make.left.right.equalTo(likesCollectionView)
        }
        
        contentView.addSubview(booksStack)
        booksStack.snp.makeConstraints { make in
            make.top.equalTo(dislikesCollectionView.snp.bottom).offset(33)
            make.left.equalTo(dislikesCollectionView)
        }
        
        contentView.addSubview(booksCollectionView)
        booksCollectionView.snp.makeConstraints { make in
            make.top.equalTo(booksStack.snp.bottom).offset(16)
            make.left.right.equalTo(dislikesCollectionView)
            make.height.equalTo(booksCollectionView.requiredHeight)
        }
        
        contentView.addSubview(addBookView)
        addBookView.snp.makeConstraints { make in
            make.top.equalTo(booksCollectionView.snp.bottom).offset(22)
            make.left.right.equalToSuperview().inset(15.5)
        }
        
        contentView.addSubview(spotifyStack)
        spotifyStack.snp.makeConstraints { make in
            make.top.equalTo(addBookView.snp.bottom).offset(24)
            make.left.equalTo(booksStack)
        }
        
        contentView.addSubview(spotifyTableView)
        spotifyTableView.snp.makeConstraints { make in
            make.top.equalTo(spotifyStack.snp.bottom).offset(14)
            make.left.right.equalTo(addBookView)
            make.height.equalTo(spotifyTableView.data.value.count * 70)
        }
        
        contentView.addSubview(addMusicView)
        addMusicView.snp.makeConstraints { make in
            make.top.equalTo(spotifyStack.snp.bottom).offset(22)
            make.left.right.equalToSuperview().inset(15.5)
            make.bottom.equalToSuperview().offset(-28)
        }
        
    }
    
    func setupViewAsPreview() {
        
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
    
    private func createTitleStack(_ title: String, icon: UIImage) -> UIStackView {
        let image = UIImageView(image: icon)
        let label = UILabel()
        label.font = .futuraMedium(12)
        label.text = title.localized
        let stackView = UIStackView(arrangedSubviews: [image, label])
        stackView.spacing = 6.5
        return stackView
    }
    
    override func bind() {
        super.bind()
        bindViews()
        bindEvents()
    }

}
