//
//  SettingsNotificationViewController.swift
//  Elated
//
//  Created by Yiel Miranda on 3/25/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import RxCocoa

class SettingsNotificationViewController: BaseViewController {
    
    //MARK: - Properties
        
    internal let viewModel = SettingsCommonViewModel()
    
    internal let saveButton = UIBarButtonItem.creatTextButton("common.save".localized)
    
    internal lazy var hourButton = createButton(frequency: NotificationFrequency.forAnHour)
    
    internal lazy var eveningButton = createButton(frequency: NotificationFrequency.untilThisEvening)
    
    internal lazy var morningButton = createButton(frequency: NotificationFrequency.untilMorning)
    
    internal lazy var weekButton = createButton(frequency: NotificationFrequency.forAWeek)

    //MARK: - View Life Cycle
    
    init(frequency: NotificationFrequency?) {
        super.init(nibName: nil, bundle: nil)
        
        viewModel.notificationFrequency.accept(frequency)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "settings.notification.title".localized
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.rightBarButtonItem = saveButton
        
        self.setupNavigationBar(.white,
                                font: .futuraMedium(20),
                                tintColor: .white,
                                backgroundImage: #imageLiteral(resourceName: "background-header"),
                                additionalBarHeight: true,
                                addBackButton: true)
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        view.backgroundColor = .white
        
        view.addSubview(hourButton)
        hourButton.snp.makeConstraints { make in
            make.top.equalTo(165)
            make.height.equalTo(40)
            make.left.right.equalToSuperview().inset(34)
        }
        
        view.addSubview(eveningButton)
        eveningButton.snp.makeConstraints { make in
            make.top.equalTo(hourButton.snp.bottom).offset(27)
            make.height.equalTo(hourButton)
            make.left.right.equalTo(hourButton)
        }
        
        view.addSubview(morningButton)
        morningButton.snp.makeConstraints { make in
            make.top.equalTo(eveningButton.snp.bottom).offset(27)
            make.height.equalTo(eveningButton)
            make.left.right.equalTo(eveningButton)
        }
        
        view.addSubview(weekButton)
        weekButton.snp.makeConstraints { make in
            make.top.equalTo(morningButton.snp.bottom).offset(27)
            make.height.equalTo(morningButton)
            make.left.right.equalTo(morningButton)
        }
    }
    
    override func bind() {
        super.bind()
        
        bindView()
        bindEvents()
    }
    
    //MARK: - Custom
    
    private func createButton(frequency: NotificationFrequency) -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = .white
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.lightGray.cgColor
        
        button.setTitle(frequency.getName(), for: .normal)
        button.titleLabel?.font = .futuraBook(14)
        button.setTitleColor(.elatedPrimaryPurple, for: .normal)
        button.layer.cornerRadius = 20
        
        return button
    }
    
    func setSelected(frequency: NotificationFrequency) {
        let buttons = [hourButton,
                       eveningButton,
                       morningButton,
                       weekButton]
        
        for button in buttons {
            if button.titleLabel?.text == frequency.getName() {
                button.backgroundColor = .elatedPrimaryPurple
                button.layer.borderWidth = 0
                button.setTitleColor(.white, for: .normal)
            } else {
                button.backgroundColor = .white
                button.layer.borderWidth = 1.0
                button.layer.borderColor = UIColor.lightGray.cgColor
                button.setTitleColor(.elatedPrimaryPurple, for: .normal)
            }
        }
    }
}
    
