//
//  ForgotPasswordViewController.swift
//  Elated
//
//  Created by Yiel Miranda on 3/18/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: BaseViewController {
    
    //MARK: - Properties
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = "forgotpassword.title".localized
        }
    }
    
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.text = "forgotpassword.description".localized
        }
    }
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var forgotPasswordButton: UIButton!
    
    internal let forgotPasswordErrorBubble: AlertBubble = {
        let view = AlertBubble(.topCenter,
                               text: "forgotpassword.email.error.message".localized,
                               color: .danger)
        return view
    }()
    
    let viewModel = ForgotPasswordViewModel()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
          
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        forgotPasswordButton.layer.applySketchShadow( alpha: 0.1, blur: 20, spread: 0)
        
        self.view.addSubview(forgotPasswordErrorBubble)
        forgotPasswordErrorBubble.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(1)
            make.left.right.equalTo(emailTextField)
        }
    }
    
    override func bind() {
        super.bind()
        
        bindViews()
        bindEvents()
    }
    
    //MARK: - Custom
    
    func bindEvents() {
        viewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)
        
        viewModel.presentAlert.subscribe( onNext: { [weak self] args in
            let (title, message) = args
            self?.presentAlert(title: title, message: message)
        }).disposed(by: disposeBag)
        
        emailTextField.rx.text.orEmpty
          .bind(to: viewModel.emailText)
          .disposed(by: disposeBag)
        
        forgotPasswordButton.rx.tap.bind { [weak self] in
            self?.viewModel.forgotPassword()
        }.disposed(by: disposeBag)
        
        viewModel.hideErrorBubble
            .bind(to: forgotPasswordErrorBubble.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.success.subscribe(onNext:  { [weak self] in
            self?.presentAlert(title: "common.success".localized,
                               message: "forgotpassword.success.message".localized,
                               callback: {
                                self?.navigationController?.popViewController(animated: true)
                               })
        }).disposed(by: disposeBag)
    }

    func bindViews() {
        viewModel.onEmailValueChanged.map { $0 ? 1 : 0.6 }
          .bind(to: forgotPasswordButton.rx.alpha)
          .disposed(by: disposeBag)
        
        viewModel.onEmailValueChanged.bind(to:
            forgotPasswordButton.rx.isUserInteractionEnabled
        ).disposed(by: disposeBag)
        
        emailTextField.rx.text.orEmpty.asDriver()
          .drive(viewModel.emailText)
          .disposed(by: disposeBag)
        
        viewModel.onEmailValueChanged
          .subscribe(onNext: { [weak self] isValid in
            guard let self = self else { return }
            
            self.emailTextField.customizeTextField(
              false,
              leftImage: #imageLiteral(resourceName: "icon-email"),
              rightImage: nil,
              placeholder: "forgotpassword.email.placeholder".localized,
              colorTheme: isValid ? .elatedPrimaryPurple : .silver,
              borderWidth: isValid ? 1.5 : 0.25,
              cornerRadius: 30
            )
            
            self.emailTextField.textColor = isValid ? .elatedPrimaryPurple : .silver
            self.forgotPasswordErrorBubble.isHidden = true
          }).disposed(by: disposeBag)
    }
}
