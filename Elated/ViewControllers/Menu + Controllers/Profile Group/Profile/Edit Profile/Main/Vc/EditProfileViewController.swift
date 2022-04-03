//
//  EditProfileViewController.swift
//  Elated
//
//  Created by Marlon on 3/24/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class EditProfileViewController: ScrollViewController {

    internal let viewModel = EditProfileViewModel()
    internal let imageCollectionView = GalleryCollectionView(.edit)
    
    internal let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .futuraMedium(20)
        label.textColor = .eerieBlack
        label.textAlignment = .center
        label.text = "Alexandra J., 24"
        return label
    }()
    
    private let aboutMeStack: UIStackView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "icon-aboutme"))
        let label = UILabel()
        label.font = .futuraMedium(12)
        label.text = "profile.about.aboutMe".localized
        let stackView = UIStackView(arrangedSubviews: [image, label])
        stackView.spacing = 6.5
        return stackView
    }()
    
    internal let textView: UITextView = {
        let textView = UITextView()
        textView.font = .futuraBook(14)
        textView.textColor = .sonicSilver
        textView.backgroundColor = .alabasterSolid
        textView.layer.borderWidth = 0.25
        textView.layer.borderColor = UIColor.silver.cgColor
        textView.layer.cornerRadius = 6
        textView.text = "sample.profile".localized
        textView.textContainerInset = UIEdgeInsets(top: 21, left: 16, bottom: 21, right: 16)
        return textView
    }()

    private lazy var quickFactsStack = createTitleStack("profile.about.quickFacts", icon: #imageLiteral(resourceName: "Icon-info"))

    internal let quickFactsTableView = QuickFactsDetailTableView()
        
    private lazy var likesStack = createTitleStack("profile.interests.likes", icon: #imageLiteral(resourceName: "icon-like-sub"))

    internal lazy var likesCollectionView = CommonCollectionView([],
                                                                 isEdit: true)
    private lazy var dislikesStack = createTitleStack("profile.interests.dislikes", icon: #imageLiteral(resourceName: "icon-dislike"))
    
    internal lazy var dislikesCollectionView = CommonCollectionView([],
                                                                    isEdit: true)
    
    internal lazy var booksStack = createTitleStack("profile.interests.favoriteBooks", icon: #imageLiteral(resourceName: "icon-books"))
    internal lazy var booksCollectionView = BookCollectionView(shouldHideDeleteButton: false)
    
    
    internal lazy var addBookView: AddDeleteTableViewCell = {
        let view = AddDeleteTableViewCell()
        view.setData(#imageLiteral(resourceName: "icon-books"),
                     imageURL: nil,
                     title: "profile.interests.addMoreBooks".localized, type: .add)
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
    
    internal let mediaOptionPopup = MediaOptionPopupView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
         self.setupNavigationBar(.white,
                        font: .futuraMedium(20),
                        tintColor: .white,
                        backgroundImage: #imageLiteral(resourceName: "background-header"),
                        additionalBarHeight: true,
                        addBackButton: true)
        self.title = "profile.editProfile.title".localized
        viewModel.getProfile()
        viewModel.getBooks(initialPage: true)
        viewModel.getMusic()
        viewModel.getArtist()
    }

    override func initSubviews() {
        super.initSubviews()
        
        contentView.addSubview(imageCollectionView)
        imageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(37)
            make.left.right.equalToSuperview().inset(15)
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageCollectionView.snp.bottom).offset(37)
            make.left.right.equalToSuperview()
        }
        
        contentView.addSubview(aboutMeStack)
        aboutMeStack.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(22)
            make.left.equalTo(32)
        }
        
        contentView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.equalTo(aboutMeStack.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(32)
            make.height.equalTo(150)
        }
        
        contentView.addSubview(quickFactsStack)
        quickFactsStack.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(22)
            make.left.equalTo(32)
        }
        
        contentView.addSubview(quickFactsTableView)
        quickFactsTableView.snp.makeConstraints { make in
            make.top.equalTo(quickFactsStack.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(32)
            make.height.equalTo(100)
        }
        
        contentView.addSubview(likesStack)
        likesStack.snp.makeConstraints { make in
            make.top.equalTo(quickFactsTableView.snp.bottom).offset(24)
            make.left.equalTo(32)
        }
        
        contentView.addSubview(likesCollectionView)
        likesCollectionView.snp.makeConstraints { make in
            make.top.equalTo(likesStack.snp.bottom).offset(16)
            make.left.right.equalTo(quickFactsTableView)
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
            make.height.equalTo(70)
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
            //make.height.equalTo(spotifyTableView.data.value.count * 70)
        }
        
        contentView.addSubview(addMusicView)
        addMusicView.snp.makeConstraints { make in
            make.top.equalTo(spotifyStack.snp.bottom).offset(22)
            make.left.right.equalToSuperview().inset(15.5)
            make.bottom.equalToSuperview().offset(-28)
        }
        
    }

    override func bind() {
        super.bind()
        bindView()
        bindEvent()
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
    
    internal func updateQuickFactsTableViewConstraints() {
        quickFactsTableView.snp.updateConstraints { make in
            make.height.equalTo(viewModel.quickFacts.value.count * 60 + 20/*offset*/)
        }
    }
    
}
