//
//  SignupConfirmationViewController.swift
//  Elated
//
//  Created by John Lester Celis on 3/20/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import Lottie
import RxSwift
import RxCocoa

class SignupConfirmationViewController: ScrollViewController {
    
    var displayLink: CADisplayLink?
    internal let viewModel = SignupConfirmationViewModel()
    internal let backButton = UIBarButtonItem.createBackButton()
    internal let bottomBackground = UIImageView(image: #imageLiteral(resourceName: "lower_background"))
    internal let joinButton = UIButton.createCommonBottomButton("signup.confirmation.code.join.elated")
    
    var timer: Timer?

    private let dotAnimationView: AnimationView = {
        let animation = AnimationView()
        animation.animation = Animation.named("bubble_animation")
        animation.contentMode = .scaleAspectFit
        animation.backgroundBehavior = .pauseAndRestore
        animation.loopMode = .loop
        animation.play()
        return animation
    }()
    
    private let mailAnimationView: AnimationView = {
        let animation = AnimationView()
        animation.animation = Animation.named("confirmation_code")
        animation.contentMode = .scaleAspectFit
        animation.backgroundBehavior = .pauseAndRestore
        animation.loopMode = .loop
        animation.play()
        return animation
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .eerieBlack
        label.font = .futuraMedium(22)
        label.text = "signup.confirmation.code.title".localized
        label.textAlignment = .center
        return label
    }()
    
    private let body1Label: UILabel = {
        let label = UILabel()
        label.textColor = .eerieBlack
        label.font = .futuraMedium(16)
        label.text = "signup.confirmation.code.body1".localized
        label.textAlignment = .center
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .elatedPrimaryPurple
        label.font = .futuraMedium(16)
        label.textAlignment = .center
        return label
    }()
    
    private let body2Label: UILabel = {
        let label = UILabel()
        label.textColor = .eerieBlack
        label.font = .futuraMedium(16)
        label.text = "signup.confirmation.code.body2".localized
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    internal lazy var textField1 = createTextField()
    internal lazy var textField2 = createTextField()
    internal lazy var textField3 = createTextField()
    internal lazy var textField4 = createTextField()
    internal lazy var textField5 = createTextField()
    internal lazy var textField6 = createTextField()
    
    internal let incorrectConfirmationCodeBubble: AlertBubble = {
        let view = AlertBubble(.topCenter,
                               text: "signup.validation.confirmation.code.msg".localized,
                               color: .danger)
        return view
    }()

    private let countLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grayColor
        label.font = .futuraMedium(16)
        label.text = "signup.confirmation.code.count".localizedFormat("300")
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let resendLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grayColor
        label.font = .futuraMedium(16)
        label.text = "signup.confirmation.code.resend".localized
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let resendButton: UIButton = {
        let button = UIButton()
        button.setTitle("signup.confirmation.code.resend.tappable".localized, for: .normal)
        button.titleLabel?.font = .futuraMedium(16)
        button.setTitleColor(.elatedPrimaryPurple, for: .normal)
        return button
    }()

    private func createTextField() -> UITextField {
        let textField = UITextField()
        textField.backgroundColor = .alabasterSolid
        textField.font = .futuraBook(14)
        textField.layer.cornerRadius = 10
        textField.textAlignment = .center
        textField.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        textField.keyboardType = .numberPad
        textField.borderWidth = 0.25
        textField.borderColor = .sonicSilver
        return textField
    }
    
    init(_ email: String, resend: Bool = false) {
        super.init(nibName: nil, bundle: nil)
        viewModel.email.accept(email)
        emailLabel.text = email
        if resend {
            viewModel.resendOTPEmail()
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
        self.navigationItem.leftBarButtonItem = backButton
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    override func initSubviews() {
        super.initSubviews()
        view.backgroundColor = .white
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.left.right.equalToSuperview().inset(33)
        }
        
        contentView.addSubview(body1Label)
        body1Label.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.left.right.equalTo(titleLabel)
        }
        
        contentView.addSubview(emailLabel)
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(body1Label.snp.bottom).offset(5)
            make.left.right.equalTo(body1Label)
        }
        
        contentView.addSubview(body2Label)
        body2Label.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.left.right.equalTo(emailLabel)
        }
        
        contentView.addSubview(dotAnimationView)
        dotAnimationView.snp.makeConstraints { make in
            make.height.equalTo(242)
            make.width.equalTo(320)
            make.centerX.equalToSuperview()
            make.top.equalTo(body2Label.snp.bottom).offset(56)
        }
        
        contentView.addSubview(mailAnimationView)
        mailAnimationView.snp.makeConstraints { make in
            make.bottom.left.right.equalTo(dotAnimationView)
            make.height.equalTo(200)
        }
        
        let stackView = UIStackView(arrangedSubviews: [textField1, textField2, textField3, textField4, textField5, textField6])
        stackView.axis = .horizontal
        stackView.spacing = 7
        stackView.distribution = .fillEqually
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(dotAnimationView.snp.bottom).offset(12)
            make.width.equalTo(280)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
        }
        
        contentView.addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(52)
        }
        
        contentView.addSubview(resendLabel)
        resendLabel.snp.makeConstraints { make in
            make.top.equalTo(countLabel.snp.bottom).offset(2)
            make.left.equalToSuperview().inset(52)
            make.bottom.equalToSuperview().inset(52)
        }
        
        contentView.addSubview(resendButton)
        resendButton.snp.makeConstraints { make in
            make.left.equalTo(resendLabel.snp.right).offset(4)
            make.right.equalToSuperview().inset(52)
            make.bottom.equalTo(resendLabel.snp.bottom).offset(5)
        }
        
        view.addSubview(bottomBackground)
        bottomBackground.snp.makeConstraints { make in
            make.height.equalTo(135) //including offset 2
            make.left.equalToSuperview().offset(-2)
            make.right.bottom.equalToSuperview().offset(2)
        }
        
        view.addSubview(joinButton)
        joinButton.snp.makeConstraints { make in
            make.centerY.equalTo(bottomBackground)
            make.left.right.equalToSuperview().inset(33)
            make.height.equalTo(50)
        }
        
        contentView.addSubview(incorrectConfirmationCodeBubble)
        incorrectConfirmationCodeBubble.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(1)
            make.centerX.equalTo(stackView)
        }
        
        scrollView.snp.remakeConstraints({ make in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(bottomBackground.snp.top)
        })
        
    }
    
    override func bind() {
        super.bind()
         
        //base bindings
        viewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)
        
        viewModel.presentAlert.subscribe( onNext: { [weak self] args in
            let (title, message) = args
            self?.presentAlert(title: title, message: message)
        }).disposed(by: disposeBag)
        //end
        
        viewModel.code.subscribe(onNext: { [weak self] code in
            let allow = code != nil
            self?.joinButton.isUserInteractionEnabled = allow
            self?.joinButton.alpha = allow ? 1 : 0.6
        }).disposed(by: disposeBag)
        
        viewModel.confirmed.subscribe(onNext: { user in
            let nav = UINavigationController(rootViewController: OnboardingViewController.instantiate())
            Util.setRootViewController(nav)
        }).disposed(by: disposeBag)
        
        viewModel.resent.subscribe(onNext: { [weak self] in
            self?.textField1.text = ""
            self?.textField2.text = ""
            self?.textField3.text = ""
            self?.textField4.text = ""
            self?.textField5.text = ""
            self?.textField6.text = ""
            self?.viewModel.countDown = 300
        }).disposed(by: disposeBag)
        
        viewModel.hideConfirmationCodeBubble.bind(to: incorrectConfirmationCodeBubble.rx.isHidden)
            .disposed(by: disposeBag)
        
        backButton.rx.tap.bind { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }.disposed(by: disposeBag)
        
        resendButton.rx.tap.bind { [weak self] in
            self?.viewModel.resendOTPEmail()
        }.disposed(by: disposeBag)
        
        joinButton.rx.tap.bind { [weak self] in
            self?.viewModel.verifyEmail()
        }.disposed(by: disposeBag)
        
        Observable.combineLatest(textField1.rx.text.orEmpty,
                                 textField2.rx.text.orEmpty,
                                 textField3.rx.text.orEmpty,
                                 textField4.rx.text.orEmpty,
                                 textField5.rx.text.orEmpty,
                                 textField6.rx.text.orEmpty)
            .subscribe(onNext: { [weak self] t1, t2, t3, t4, t5, t6 in
                if !t1.isEmpty &&
                   !t2.isEmpty &&
                   !t3.isEmpty &&
                   !t4.isEmpty &&
                   !t5.isEmpty &&
                   !t6.isEmpty {
                    self?.viewModel.code.accept(t1 + t2 + t3 + t4 + t5 + t6)
                } else {
                    self?.viewModel.code.accept(nil)
                }
                self?.viewModel.hideConfirmationCodeBubble.accept(true)
            }).disposed(by: self.disposeBag)
        
    }
    
    @objc func fireTimer() {
        viewModel.countDown -= 1
        countLabel.text = "signup.confirmation.code.count".localizedFormat("\(viewModel.countDown < 1 ? 0 : viewModel.countDown)")
        if viewModel.countDown == 0 {
            self.presentAlert(title: "",
                              message: "signup.confirmation.code.expired".localized,
                              buttonTitles: ["common.cancel".localized, "common.ok".localized],
                              highlightedButtonIndex: 1) { [weak self] index in
                if index == 1 {
                    self?.viewModel.resendOTPEmail()
                }
            }
        }
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        let text = textField.text
        if  text?.count == 1 {
            switch textField {
            case textField1:
                textField2.becomeFirstResponder()
            case textField2:
                textField3.becomeFirstResponder()
            case textField3:
                textField4.becomeFirstResponder()
            case textField4:
                textField5.becomeFirstResponder()
            case textField5:
                textField6.becomeFirstResponder()
            case textField6:
                textField6.resignFirstResponder()
            default:
                break
            }
        }
        
        if  text?.count == 0 {
            switch textField {
            case textField1:
                textField1.becomeFirstResponder()
            case textField2:
                textField1.becomeFirstResponder()
            case textField3:
                textField2.becomeFirstResponder()
            case textField4:
                textField3.becomeFirstResponder()
            case textField5:
                textField4.becomeFirstResponder()
            case textField6:
                textField5.becomeFirstResponder()
            default:
                break
            }
        }
    }
}
