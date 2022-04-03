//
//  StoryShareGameCompletedViewController.swift
//  Elated
//
//  Created by Marlon on 10/23/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class StoryShareGameCompletedViewController: BaseViewController {

    internal let viewModel = StoryShareCompletedViewModel()
    
    private let backgroundImage = UIImageView(image: #imageLiteral(resourceName: "background-storyshare"))
    
    private let typeWriterImage: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "asset-storyshare-typewriter-menu"))
        imageView.contentMode = .top
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .chestnut
        label.font = .courierPrimeRegular(20)
        label.text = "storyshare.title".localized
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    internal let subLabel: UILabel = {
        let label = UILabel()
        label.textColor = .eerieBlack
        label.text = "storyshare.completed".localized
        label.font = .courierPrimeRegular(22)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    internal let storyTextView: UITextView = {
        let textView = UITextView()
        textView.font = .courierPrimeBold(12)
        textView.textAlignment = .left
        textView.isEditable = false
        textView.isSelectable = false
        textView.backgroundColor = .clear
        textView.spellCheckingType = .yes
        return textView
    }()
    
    internal let writtenByLabel: UILabel = {
        let label = UILabel()
        label.text = "storyshare.written.by".localized
        label.textColor = .umber
        label.font = .courierPrimeRegular(12)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let shareLabel: UILabel = {
        let label = UILabel()
        label.textColor = .umber
        label.font = .courierPrimeRegular(12)
        label.text = "common.share".localized
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let inviteeAvatar: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.cornerRadius = 19
        return view
    }()
    
    private let inviterAvatar: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.cornerRadius = 19
        return view
    }()
    
    internal let settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icon-gear-white").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .chestnut
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        let image = #imageLiteral(resourceName: "icon-share-grey")
        button.setImage(image, for: .normal)
        return button
    }()
    
    internal let keyWindow = UIApplication.shared.connectedScenes
                                .filter({$0.activationState == .foregroundActive})
                                .map({$0 as? UIWindowScene})
                                .compactMap({$0})
                                .first?.windows
                                .filter({$0.isKeyWindow}).first
    
    internal lazy var settingsView = EmojiGoStoryShareSettingsPopup(theme: .chestnut)
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    init(_ detail: StoryShareGameDetail) {
        super.init(nibName: nil, bundle: nil)
        viewModel.detail.accept(detail)
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func initSubviews() {
        super.initSubviews()
    
        view.addSubview(backgroundImage)
        backgroundImage.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(-2)
            make.right.equalToSuperview().offset(2)
        }
    
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(25)
        }
        
        view.addSubview(subLabel)
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(50)
            make.left.right.equalToSuperview().inset(33)
        }
        
        view.addSubview(settingsButton)
        settingsButton.snp.makeConstraints { make in
            make.right.equalTo(-16)
            make.centerY.equalTo(titleLabel)
            make.width.height.equalTo(24)
        }
        
        view.addSubview(typeWriterImage)
        typeWriterImage.snp.makeConstraints { make in
            make.top.equalTo(subLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30)
        }
        
        view.addSubview(storyTextView)
        storyTextView.snp.makeConstraints { make in
            make.top.equalTo(typeWriterImage).inset(20)
            make.left.right.equalTo(typeWriterImage).inset(UIScreen.main.bounds.width * 0.15)
            make.bottom.equalTo(typeWriterImage.snp.centerY).offset(-57)
        }
        
        view.addSubview(writtenByLabel)
        writtenByLabel.snp.makeConstraints { make in
            make.top.equalTo(storyTextView.snp.bottom).offset(22)
            make.left.equalTo(storyTextView)
        }
        
        view.addSubview(inviteeAvatar)
        inviteeAvatar.snp.makeConstraints { make in
            make.centerY.equalTo(writtenByLabel)
            make.left.equalTo(writtenByLabel.snp.right).offset(8)
            make.width.height.equalTo(38)
        }
        
        view.addSubview(inviterAvatar)
        inviterAvatar.snp.makeConstraints { make in
            make.centerY.equalTo(inviteeAvatar)
            make.left.equalTo(inviteeAvatar.snp.right).offset(2)
            make.width.height.equalTo(38)
        }
        
        view.addSubview(shareLabel)
        shareLabel.snp.makeConstraints { make in
            make.top.equalTo(inviterAvatar.snp.bottom).offset(22)
            make.centerX.equalTo(storyTextView)
        }
        
        view.addSubview(shareButton)
        shareButton.snp.makeConstraints { make in
            make.top.equalTo(shareLabel.snp.bottom).offset(8)
            make.centerX.equalTo(shareLabel)
        }
        
    }
    
    override func bind() {
        
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
        
        viewModel.detail.subscribe(onNext: { [weak self] detail in
            guard let detail = detail else { return }
            
            self?.inviteeAvatar.kf.setImage(with: URL(string: detail.invitee?.avatar?.image ?? ""), placeholder: #imageLiteral(resourceName: "profile-placeholder"))
            self?.inviterAvatar.kf.setImage(with: URL(string: detail.inviter?.avatar?.image ?? ""), placeholder: #imageLiteral(resourceName: "profile-placeholder"))

            //story label
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 12
            let story = detail.phrases.map { $0.phrase }.joined(separator: " ")
            let storyMutableString = NSMutableAttributedString(string: story,
                                                          attributes: [NSAttributedString.Key.font: UIFont.courierPrimeBold(12),
                                                                       NSAttributedString.Key.paragraphStyle: style])
            
            for phrase in detail.phrases {
                let color : StoryShareColor? = phrase.user == detail.inviter?.id
                    ? detail.inviterTextColor
                    : detail.inviteeTextColor
                if let substringRange = story.range(of: phrase.phrase) {
                    let nsRange = NSRange(substringRange, in: story)
                    storyMutableString.addAttribute(NSAttributedString.Key.foregroundColor,
                                                    value: color?.getColor() ?? .ssBlue,
                                                    range: nsRange)
                }
            }
        }).disposed(by: disposeBag)
        
    }
    
    
}


