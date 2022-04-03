//
//  SettingsAccountViewController.swift
//  Elated
//
//  Created by Yiel Miranda on 3/25/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import RxCocoa

class SettingsAccountViewController: BaseViewController {
    
    //MARK: - Properties
    
    var settingsAccountType = SettingsAccountType.Pause
    
    internal let viewModel = SettingsAccountViewModel()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icon-back").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let centerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.layer.borderWidth = 0.25
        view.layer.borderColor = UIColor.silver.cgColor
        view.layer.applySketchShadow(color: .black,
                                     alpha: 0.1,
                                     x: 0,
                                     y: 2,
                                     blur: 10,
                                     spread: 0)
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .eerieBlack
        label.font = .futuraMedium(20)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grayColor
        label.font = .futuraBook(16)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        return blurView
    }()
    
    internal lazy var cancelButton = createButton(title: "", id: 0)
    
    internal lazy var proceedButton = createButton(title: "", id: 1)
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.setSettingsAccountType(type: settingsAccountType)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        view.backgroundColor = .fadedPurpleBackgroundColor
        /*
        view.addSubview(blurEffectView)
        blurEffectView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
            make.top.equalTo(0)
            make.left.equalTo(0)
        }
        */
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(52)
            make.left.equalTo(6)
            make.height.equalTo(28)
            make.width.equalTo(28)
        }
        
        view.addSubview(centerView)
        centerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(34)
            make.height.equalTo(359)
        }
        
        centerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(39)
            make.left.right.equalToSuperview().inset(7)
            make.height.equalTo(67)
        }
        
        centerView.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.right.equalToSuperview().inset(29)
            make.height.equalTo(79)
        }
        
        centerView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(33)
            make.left.right.equalToSuperview().inset(22)
            make.height.equalTo(51)
        }
        
        centerView.addSubview(proceedButton)
        proceedButton.snp.makeConstraints { make in
            make.top.equalTo(cancelButton.snp.bottom).offset(12)
            make.left.right.equalTo(cancelButton)
            make.height.equalTo(cancelButton)
        }
    }
    
    override func bind() {
        super.bind()
        
        bindView()
        bindEvents()
    }
    
    //MARK: - Custom
    
    private func createButton(title: String, id: Int) -> UIButton {
        let button = UIButton(type: .custom)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.lightGray.cgColor
        
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .futuraBook(14)
        button.layer.cornerRadius = 25.5
        
        button.tag = id
        
        if id == 0 {
            button.backgroundColor = .elatedPrimaryPurple
            button.setTitleColor(.white, for: .normal)
        } else {
            button.backgroundColor = .white
            button.setTitleColor(.danger, for: .normal)
            
            button.layer.applySketchShadow(color: .black,
                                           alpha: 0.15,
                                           x: 0,
                                           y: 3,
                                           blur: 18,
                                           spread: 0)
        }
        
        return button
    }
    
    func proceedToSuccessPage() {
        let viewController = SuccessViewController()
        viewController.modalPresentationStyle = .overFullScreen
        
        let viewModel = SuccessViewModel()
        viewModel.messageText.accept(self.viewModel.successMessageText)
        viewModel.buttonText.accept(self.viewModel.successButtonText)
        viewController.viewModel = viewModel
        
        viewModel.success.subscribe(onNext: { [weak self] in
            //TODO: Remove this condition when api is available
            guard self?.viewModel.settingsAccountType.value != .Pause else { return }
            
            UserDefaults.standard.clearUserData()
            Util.setRootViewController(LandingViewController())
        }).disposed(by: disposeBag)
            
        self.present(viewController, animated: true, completion: nil)
    }
}
