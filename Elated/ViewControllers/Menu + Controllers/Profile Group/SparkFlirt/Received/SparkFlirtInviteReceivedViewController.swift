//
//  SparkFlirtInviteReceivedViewController.swift
//  Elated
//
//  Created by Rey Felipe on 10/22/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import Lottie

class SparkFlirtInviteReceivedViewController: ScrollViewController {

    let viewModel = SparkFlirtInvitesViewModel()
    
    private let bottomBackground = UIImageView(image: #imageLiteral(resourceName: "lower_background"))
    private let acceptButton = UIButton.createCommonBottomButton("common.accept")
    private let declineButton: UIButton = {
        let button = UIButton.createButtonWithShadow("common.decline", with: true)
        button.borderWidth = 0.25
        button.borderColor = .silver
        return button
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [acceptButton, declineButton])
        stackView.axis = .horizontal
        stackView.spacing = 12
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .eerieBlack
        label.font = .futuraMedium(22)
        label.text = "sparkFlirt.first.invite.received.title".localizedFormat("")
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let subLabel: UILabel = {
        let label = UILabel()
        label.textColor = .sonicSilver
        label.font = .futuraBook(14)
        label.textAlignment = .center
        label.text = "sparkFlirt.invite.received.note".localized
        label.numberOfLines = 0
        return label
    }()
    
    private let animationView: AnimationView = {
        let animation = AnimationView(name: "spark-and-bubble")
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .loop
        animation.backgroundBehavior = .pauseAndRestore
        animation.animationSpeed = 1.5
        animation.play()
        return animation
    }()
    
    private let senderImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "profile-placeholder"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 60
        imageView.layer.borderWidth = 0
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    private let sfImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "buttons-sparkflirtyellow-circle"))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.layer.borderWidth = 5
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    private let introView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let introTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .eerieBlack
        label.font = .futuraMedium(22)
        label.text = "sparkFlirt.first.invite.received.title".localizedFormat("")
        label.textAlignment = .center
        label.numberOfLines = 0
        label.layer.opacity = 0
        return label
    }()
    
    private let introSubLabel: UILabel = {
        let label = UILabel()
        label.textColor = .sonicSilver
        label.font = .futuraBook(14)
        label.textAlignment = .center
        label.text = "sparkFlirt.invite.received.note".localized
        label.numberOfLines = 0
        label.layer.opacity = 0
        return label
    }()
    
    private let introAnimationView: AnimationView = {
        let animation = AnimationView(name: "sparkflirt-invitation-received")
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .playOnce
        animation.backgroundBehavior = .pauseAndRestore
        animation.animationSpeed = 1.0
        return animation
    }()
    
    public var acceptHandler: (() -> Void)?
    public var declineHandler: (() -> Void)?
    private var inviteId: Int = 0
    private var sender: UserInfoShort?
    
    init(sender: UserInfoShort, sparkFlirtId: Int) {
        super.init(nibName: nil, bundle: nil)
        
        guard let me = MemCached.shared.userInfo else { return }
        
        self.inviteId = sparkFlirtId
        self.sender = sender
        
        if !me.firstSparkFlirtReceived {
            MemCached.shared.userInfo?.firstSparkFlirtReceived = true
            titleLabel.text = "sparkFlirt.first.invite.received.title".localizedFormat(sender.getDisplayName())
            introTitleLabel.text = "sparkFlirt.first.invite.received.title".localizedFormat(sender.getDisplayName())
        } else {
            titleLabel.text = "sparkFlirt.invite.received.title".localizedFormat(sender.getDisplayName())
            introTitleLabel.text = "sparkFlirt.invite.received.title".localizedFormat(sender.getDisplayName())
        }
        
        senderImageView.kf.setImage(with: URL(string: sender.avatar?.image ?? ""),
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
        navigationController?.setNavigationBarHidden(false, animated: true)
        setupNavigationBar(.elatedPrimaryPurple,
                           font: .futuraMedium(20),
                           tintColor: .elatedPrimaryPurple,
                           backgroundColor: .white,
                           backgroundImage: nil,
                           addBackButton: true)

        playIntroAnimation()
    }
    
    override func initSubviews() {
        super.initSubviews()
        view.backgroundColor = .white
        
        contentView.addSubview(introTitleLabel)
        introTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(30)
        }
        
        contentView.addSubview(introAnimationView)
        introAnimationView.snp.makeConstraints{ make in
            make.top.equalTo(introTitleLabel.snp.bottom)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(45)
            make.height.equalTo(300)
        }
        
        contentView.addSubview(introSubLabel)
        introSubLabel.snp.makeConstraints { make in
            make.top.equalTo(introAnimationView.snp.bottom)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(40)
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
        
        centerContentViewIfNeeded(offset: Util.heigherThanIphone6 ? 133 : 35)
    }
    
    override func bind() {
        super.bind()
        
        acceptButton.rx.tap.bind { [weak self] in
            guard let self = self,
                  self.inviteId > 0
            else { return }
            // Accept Invitation
            self.viewModel.acceptDeclineInvitation(self.inviteId, accept: true)
        }.disposed(by: disposeBag)
        
        declineButton.rx.tap.bind { [weak self] in
            guard let self = self,
                  self.inviteId > 0
            else { return }
            // Decline Invitation
            self.viewModel.acceptDeclineInvitation(self.inviteId, accept: false)
        }.disposed(by: disposeBag)
        
        viewModel.success.subscribe( onNext: { [weak self] inviteResponse in
            guard let self = self else { return }
            
            switch inviteResponse {
            case .accept:
                // Back to previous screen
                self.navigationController?.popViewController(animated: false)
                self.acceptHandler?()
            case .decline:
                // Back to previous screen
                self.navigationController?.popViewController(animated: true)
                self.declineHandler?()
            }
        }).disposed(by: disposeBag)
        
    }

    @objc func didTapSenderProfileImage() {
        guard let userId = sender?.id else { return }
        
        let vc = ProfilePageViewController("profile.view.main".localized, viewUserID: userId)

        self.show(vc, sender: nil)
    }
}

//MARK: - Private Methods
extension SparkFlirtInviteReceivedViewController {
    
    private func transitionToMainView() {
        
        UIView.animate(withDuration: 1.0, animations: { [weak self] () in
            self?.introView.layer.opacity = 0
        }, completion: { [weak self] _ in
            self?.introView.removeFromSuperview()
            self?.showMainView()
        })
    }
    
    private func showMainView() {
        // Remove the intro animation views
        introTitleLabel.removeFromSuperview()
        introAnimationView.removeFromSuperview()
        introSubLabel.removeFromSuperview()
        
        senderImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapSenderProfileImage)))
        
        scrollView.fadeTransition(0.5)
        
        scrollView.snp.updateConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
        // Main Content View
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(30)
        }
        
        contentView.addSubview(animationView)
        animationView.snp.makeConstraints{ make in
            make.top.equalTo(titleLabel.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(45)
            make.height.equalTo(200)
        }
        
        animationView.addSubview(senderImageView)
        senderImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(120)
        }
        
        animationView.addSubview(sfImageView)
        sfImageView.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(senderImageView)
            make.height.width.equalTo(40)
        }
        
        contentView.addSubview(subLabel)
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(animationView.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(40)
        }
        
        contentView.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(subLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-25)
        }
        
        acceptButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(Util.heigherThanIphone6 ? 150 : 130)
        }
        
        declineButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(Util.heigherThanIphone6 ? 150 : 130)
        }
        
        view.bringSubviewToFront(scrollView)
    }
    
    func playIntroAnimation() {

        introAnimationView.play() { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.transitionToMainView()
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            UIView.animate(withDuration: 2.5, animations: { [weak self] () in
                guard let self = self else { return }
                self.introTitleLabel.layer.opacity = 1
                self.introSubLabel.layer.opacity = 1
            }, completion: nil)
        }
    }
}
