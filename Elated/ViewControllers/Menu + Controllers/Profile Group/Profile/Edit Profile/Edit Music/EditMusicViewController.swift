//
//  EditMusicViewController.swift
//  Elated
//
//  Created by Marlon on 6/13/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import SafariServices
import SpotifyLogin

class EditMusicViewController: BaseViewController {

    let viewModel = EditMusicViewModel()
    private let skipButton = UIBarButtonItem.creatTextButton("common.skip".localized)
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "profile.editProfile.musicTitle".localized
        label.font = .futuraMedium(22)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private let subLabel: UILabel = {
        let label = UILabel()
        label.text = "profile.editProfile.musicSubTitle".localized
        label.font = .futuraBook(18)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .sonicSilver
        return label
    }()
        
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "profile.interests.spotify.noArtists.followed".localized
        label.font = .futuraBook(18)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .sonicSilver
        label.isHidden = true
        return label
    }()
    
    internal lazy var spotifyStack = createTitleStack("profile.interests.favoriteArtistsSpotify", icon: #imageLiteral(resourceName: "icon-music"))
    internal lazy var spotifyTableView: AddDeleteTableView = {
        let tableView = AddDeleteTableView()
        return tableView
    }()
    
    internal lazy var addMusicView: AddDeleteTableViewCell = {
        let view = AddDeleteTableViewCell()
        view.setData(#imageLiteral(resourceName: "icon-spotify"), imageURL: nil, title: "profile.interests.addSpotify".localized, type: .add)
        return view
    }()
    
    private let bottomBackground = UIImageView(image: #imageLiteral(resourceName: "lower_background"))
    
    private let nextButton = UIButton.createCommonBottomButton("common.next")
    
    init(_ type: EditInfoControllerType) {
        super.init(nibName: nil, bundle: nil)
        viewModel.editType.accept(type)
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
        let type = viewModel.editType.value
        self.navigationItem.rightBarButtonItem = type == .onboarding ? skipButton : nil
        self.setupNavigationBar(type == .onboarding ? .elatedPrimaryPurple : .white,
                                font: .futuraMedium(20),
                                tintColor: type == .onboarding ? .elatedPrimaryPurple : .white,
                                backgroundImage: type == .onboarding ? nil : #imageLiteral(resourceName: "background-header"),
                                addBackButton: type != .onboarding)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.findProfile()
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(viewModel.titleLabelTopSpace.value)
            make.left.right.equalToSuperview().inset(50)
        }
        
        view.addSubview(subLabel)
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.equalTo(titleLabel)
        }
        
        view.addSubview(spotifyStack)
        spotifyStack.snp.makeConstraints { make in
            make.top.equalTo(subLabel.snp.bottom).offset(50)
            make.left.equalToSuperview().inset(33)
        }
        
        view.addSubview(spotifyTableView)
        spotifyTableView.snp.makeConstraints { make in
            make.top.equalTo(spotifyStack.snp.bottom).offset(14)
            make.left.right.equalToSuperview().inset(15.5)
            make.bottom.equalToSuperview().inset(viewModel.editType.value == .onboarding ? 138 : 45)
        }
        
        view.addSubview(addMusicView)
        addMusicView.snp.makeConstraints { make in
            make.top.equalTo(spotifyStack.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(15.5)
        }
        
        view.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(spotifyStack.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(33)
        }
        
    }
    
    override func bind() {
        super.bind()
        
        viewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)
        
        viewModel.presentAlert.subscribe( onNext: { [weak self] args in
            let (title, message) = args
            self?.presentAlert(title: title, message: message)
        }).disposed(by: disposeBag)
                
        viewModel.artists.subscribe(onNext: { [weak self] artists in
            guard let self = self, let artists = artists else { return }
            let data = artists.map { (#imageLiteral(resourceName: "icon-spotify"), $0.images.first?.url, $0.name ?? "", AddDeleteTableViewCell.ButtonType.display) }
            self.spotifyTableView.data.accept(data)
            let shouldHide = artists.count == 0 && !self.viewModel.spotifyAccountFound.value
            
            let artistsText = artists.count == 0 ? "profile.interests.spotify.noArtists".localized : ""
            let spotifyLabel = self.spotifyStack.viewWithTag(1001) as? UILabel
            spotifyLabel?.text = "profile.interests.favoriteArtistsSpotify.count".localizedFormat(artistsText)
            
            self.messageLabel.isHidden = artists.count > 0
            
            self.addMusicView.isHidden = !shouldHide
        }).disposed(by: disposeBag)
        
        viewModel.editType.subscribe(onNext: { [weak self] type in
            guard let self = self else { return }
            self.title = type == .edit ? "profile.editProfile.title".localized : ""
            if type == .onboarding {
                self.view.addSubview(self.bottomBackground)
                self.bottomBackground.snp.makeConstraints { make in
                    make.height.equalTo(135) //including offset 2
                    make.left.equalToSuperview().offset(-2)
                    make.right.bottom.equalToSuperview().offset(2)
                }
                
                self.view.addSubview(self.nextButton)
                self.nextButton.snp.makeConstraints { make in
                    make.centerY.equalTo(self.bottomBackground)
                    make.left.right.equalToSuperview().inset(33)
                    make.height.equalTo(50)
                }
                self.skipButton.tintColor = .elatedPrimaryPurple
            }
        }).disposed(by: disposeBag)
        
        skipButton.rx.tap.bind { [weak self] in
            self?.viewModel.sendRequest(.bio)
        }.disposed(by: disposeBag)
        
        nextButton.rx.tap.bind { [weak self] in
            self?.viewModel.success.accept(())
        }.disposed(by: disposeBag)
        
        skipButton.rx.tap.bind { [weak self] in
            self?.viewModel.success.accept(())
        }.disposed(by: disposeBag)
        
        addMusicView.didTap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            SpotifyLoginPresenter.login(from: self, scopes: [.playlistReadPrivate,
                                                             .userFollowRead,
                                                             .playlistModifyPublic,
                                                             .playlistModifyPrivate,
                                                             .userFollowRead])
        }).disposed(by: disposeBag)
        
        viewModel.spotifyAccountFound.subscribe(onNext: { [weak self] found in
            guard let self = self, found else { return }
            self.viewModel.getArtist()
        }).disposed(by: disposeBag)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loginSuccessful),
                                               name: .SpotifyLoginSuccessful,
                                               object: nil)

    }
    
    @objc private func loginSuccessful() {
        SpotifyLogin.shared.getAccessToken { [weak self] token, error in
            guard let self = self, let accessToken = token else { return }
            self.viewModel.loginUser(accessToken: accessToken)
        }
    }

    private func createTitleStack(_ title: String, icon: UIImage) -> UIStackView {
        let image = UIImageView(image: icon)
        let label = UILabel()
        label.font = .futuraMedium(12)
        label.text = title.localized
        label.tag = 1001
        let stackView = UIStackView(arrangedSubviews: [image, label])
        stackView.spacing = 6.5
        return stackView
    }
    
}
