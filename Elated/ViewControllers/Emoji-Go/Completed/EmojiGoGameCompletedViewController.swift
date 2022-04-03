//
//  EmojiGoGameCompletedViewController.swift
//  Elated
//
//  Created by Marlon on 5/17/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EmojiGoGameCompletedViewController: ScrollViewController {

    private let detail = BehaviorRelay<EmojiGoGameDetail?>(value: nil)
    
    private let bgImage: UIImageView = UIImageView(image: #imageLiteral(resourceName: "bg-pulse"))
    
    private let titleImageView = UIImageView(image: #imageLiteral(resourceName: "icon_emoji_text"))
    
    private let settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icon-gear-white"), for: .normal)
        //Setting button has no use atm
        button.isHidden = true
        return button
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icon-back").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let goButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .goGradient_FFAE2E
        button.setTitle("emojiGo.completed.button".localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.cornerRadius = 25
        button.titleLabel?.font = .comfortaaBold(14)
        return button
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .comfortaaBold(30)
        label.textAlignment = .center
        label.text = "emojiGo.completed.title".localized
        label.numberOfLines = 0
        return label
    }()
    
    private let itemsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private let containerView: UIView =  {
        let view = UIView()
        view.backgroundColor = .appLightSkyBlue
        view.cornerRadius = 15
        return view
    }()
    
    private let inviteeImageView: UIImageView = {
        let view = UIImageView()
        view.cornerRadius = 20
        view.contentMode = .scaleToFill
        view.clipsToBounds = true
        view.image = #imageLiteral(resourceName: "profile-placeholder")
        return view
    }()
    
    private let inviterImageView: UIImageView = {
        let view = UIImageView()
        view.cornerRadius = 20
        view.contentMode = .scaleToFill
        view.clipsToBounds = true
        view.image = #imageLiteral(resourceName: "profile-placeholder")
        return view
    }()
    
    private lazy var imageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6
        
        inviteeImageView.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }
        
        inviterImageView.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }
        
        stackView.addArrangedSubview(inviteeImageView)
        stackView.addArrangedSubview(inviterImageView)

        return stackView
    }()
    
    private let shareLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkOrchid
        label.font = .comfortaaBold(12)
        label.textAlignment = .center
        label.text = "common.share".localized
        return label
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        let image = #imageLiteral(resourceName: "icon-share-grey")
        button.setImage(image, for: .normal)
        return button
    }()
    
    private var fallbackViewController: AnyClass? = nil
    
    init(_ detail: EmojiGoGameDetail, fallbackViewController: AnyClass? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.fallbackViewController = fallbackViewController
        self.detail.accept(detail)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        view.addSubview(bgImage)
        view.sendSubviewToBack(bgImage)
        bgImage.snp.makeConstraints { make in
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
        
        contentView.addSubview(titleImageView)
        titleImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(17)
            make.centerX.equalToSuperview()
        }
        
        contentView.addSubview(settingsButton)
        settingsButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleImageView)
            make.right.equalTo(-19)
            make.width.height.equalTo(24)
        }
        
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleImageView.snp.bottom).offset(42)
            make.left.right.equalToSuperview().inset(25)
        }
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(25)
        }
        
        containerView.addSubview(imageStackView)
        imageStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(19)
            make.centerX.equalToSuperview()
        }
        
        containerView.addSubview(itemsStackView)
        itemsStackView.snp.makeConstraints { make in
            make.top.equalTo(imageStackView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(38)
        }
        
        containerView.addSubview(shareLabel)
        shareLabel.snp.makeConstraints { make in
            make.top.equalTo(itemsStackView.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
        }
        
        containerView.addSubview(shareButton)
        shareButton.snp.makeConstraints { make in
            make.top.equalTo(shareLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(25)
            make.height.width.equalTo(50)
        }
        
        contentView.addSubview(goButton)
        goButton.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom).offset(29)
            make.left.right.equalToSuperview().inset(49)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().inset(19)
        }
        
        self.manageItems()
    }
   
    override func bind() {
        super.bind()
        
        goButton.rx.tap.bind {
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
        
        
        shareButton.rx.tap.bind { [weak self] in
            //TODO: Change Palyoad
            let samplePayload = "https://www.elated.io"
            
            // set up activity view controller
            let textToShare = [ samplePayload ]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            
            // so that iPads won't crash
            activityViewController.popoverPresentationController?.sourceView = self?.view
            
            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop,
                                                             UIActivity.ActivityType.addToReadingList,
                                                             UIActivity.ActivityType.assignToContact]
            self?.present(activityViewController, animated: true, completion: nil)
        }.disposed(by: rx.disposeBag)
        
    }
    
    private func manageItems() {
        if let detail = detail.value {
    
            inviteeImageView.kf.setImage(with: URL(string: detail.invitee?.avatar?.image ?? ""), placeholder: #imageLiteral(resourceName: "profile-placeholder"))
            inviterImageView.kf.setImage(with: URL(string: detail.inviter?.avatar?.image ?? ""), placeholder: #imageLiteral(resourceName: "profile-placeholder"))

            //stack
            for emojiGo in detail.emojigo {
                let stack = generateStackItem(emojiGo)
                itemsStackView.addArrangedSubview(stack)
            }
        }
    }
    
    private func generateStackItem(_ item: EmojiGo) -> UIStackView {
        
        let textLabel = UILabel()
        textLabel.font = .comfortaaBold(12)
        textLabel.textColor = item.round % 2 == 0 ? .lavanderFloral : .tuftsBlue
        textLabel.numberOfLines = 0
        textLabel.text = item.question?.question ?? ""
        
        let emojiLabel = UILabel()
        emojiLabel.text = item.answer?.answer ?? ""
        
        let stackView = UIStackView(arrangedSubviews: [textLabel, emojiLabel])
        stackView.axis = .vertical
        stackView.spacing = 3
        
        return stackView

    }

}
