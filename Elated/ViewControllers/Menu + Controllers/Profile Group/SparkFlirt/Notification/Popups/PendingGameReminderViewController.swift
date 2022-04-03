//
//  PendingGameReminderViewController.swift
//  Elated
//
//  Created by Rey Felipe on 12/3/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class PendingGameReminderViewController: ScrollViewController {
    
    enum ReminderType {
        case inviter
        case invitee
    }
    
    private let bottomBackground = UIImageView(image: #imageLiteral(resourceName: "lower_background"))
    private let option1Button = UIButton.createCommonBottomButton("sparkFlirt.select.game")
    private let option2Button: UIButton = {
        let button = UIButton.createButtonWithShadow("common.remind.later", with: true)
        button.borderWidth = 0.25
        button.borderColor = .silver
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .eerieBlack
        label.text = "sparkFlirt.game.pending.title".localizedFormat("<name here>")
        label.font = .futuraMedium(22)
        label.textAlignment = .center
        label.numberOfLines = 0
        //TODO: should show sender's name on lebel text
        return label
    }()
    
    private let inviterImageView: UIImageView = {
        //let imageView = UIImageView(image: #imageLiteral(resourceName: "profile-placeholder"))
        let imageView = UIImageView(image: #imageLiteral(resourceName: "h3"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 60
        imageView.layer.borderWidth = 0
        //TODO: update profile image
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
        //let imageView = UIImageView(image: #imageLiteral(resourceName: "profile-placeholder"))
        let imageView = UIImageView(image: #imageLiteral(resourceName: "demo_me"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 60
        imageView.layer.borderWidth = 0
        //TODO: update profile image
        return imageView
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grayColor
        label.font = .futuraMedium(14)
        label.text = "sparkFlirt.game.pending.message".localizedFormat("<name here>")
        label.numberOfLines = 0
        label.textAlignment = .center
        //TODO: should show sender's name on lebel text
        return label
    }()
    
    private var reminderType: ReminderType = .invitee
    
    init(_ reminderType: ReminderType) {
        super.init(nibName: nil, bundle: nil)
        self.reminderType = reminderType
        if reminderType == .inviter {
            //TODO: update the labels and buttons
            option1Button.setTitle("sparkFlirt.remind.button".localizedFormat("<name here>"), for: .normal)
            option2Button.setTitle("common.come.back.later".localized, for: .normal)
            titleLabel.text = "sparkFlirt.inviter.reminder.select.game.title".localizedFormat("<name here>")
            bodyLabel.text = "sparkFlirt.inviter.reminder.select.game.message".localizedFormat("<name here>")
        } else if reminderType == .invitee {
            titleLabel.text = "sparkFlirt.game.pending.title".localizedFormat("<name here>")
            bodyLabel.text = "sparkFlirt.game.pending.message".localizedFormat("<name here>")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
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
        
        playersView.addSubview(inviteeImageView)
        inviteeImageView.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
            make.height.width.equalTo(120)
        }
        
        playersView.addSubview(sfLogoImageView)
        sfLogoImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(60)
        }
        
        contentView.addSubview(bodyLabel)
        bodyLabel.snp.makeConstraints { make in
            make.top.equalTo(playersView.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.left.right.equalTo(titleLabel)
        }
        
        contentView.addSubview(option1Button)
        option1Button.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(200)
            make.top.equalTo(bodyLabel.snp.bottom).offset(40)
        }
        
        contentView.addSubview(option2Button)
        option2Button.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(200)
            make.top.equalTo(option1Button.snp.bottom).offset(20)
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
        
        option1Button.rx.tap.bind { [weak self] in
            if self?.reminderType == .invitee {
                //TODO: Show Game Selection Screen
            } else if self?.reminderType == .inviter {
                //TODO: Send a nudge pending game reminder
                //TODO: show ReminderSentViewController
            }
        }.disposed(by: disposeBag)
        
        option2Button.rx.tap.bind { [weak self] in
            if self?.reminderType == .invitee {
                //TODO: Add a local notification to remind user with in 24 hours or based in notificatioin frequency settinig
            }
            self?.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)
    }
    
}
