//
//  LandingViewController.swift
//  Elated
//
//  Created by Marlon on 2021/2/22.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import AuthenticationServices
import GoogleSignIn
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftyJSON

class LandingViewController: ScrollViewController {
    
    let viewModel = LandingViewModel()
    
    internal let logo = UIImageView(image: #imageLiteral(resourceName: "elated_logo"))
    internal let rotateView = UIView()
    
    private let tagLineLabel: UILabel = {
        let label = UILabel()
        label.text = "splash.title".localized
        label.font = .europaBold(24)
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    internal let signupButton: UIButton = {
        let button = UIButton()
        button.setTitle("splash.signupEmail".localized, for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = .futuraBook(14)
        button.layer.cornerRadius = 22
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    internal let alreadyHaveAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("splash.alreadyHaveAccount".localized, for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = .futuraMedium(14)
        return button
    }()
    
    internal let signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("splash.signin".localized, for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = .futuraBook(14)
        button.layer.cornerRadius = 22
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    private let lineLeft: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        return line
    }()
    
    
    private let orLabel: UILabel = {
        let label = UILabel()
        label.text = "splash.orMessage".localized
        label.textColor = UIColor.white.withAlphaComponent(0.5)
        label.font = .futuraBook(14)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let lineRight: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        return line
    }()
    
    internal let fbButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "facebook-circle"), for: .normal)
        button.layer.applySketchShadow( alpha: 0.3, blur: 6, spread: 0)
        return button
    }()
    
    internal let appleButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "apple-circle"), for: .normal)
        button.layer.applySketchShadow( alpha: 0.3, blur: 6, spread: 0)
        return button
    }()
    
    internal let gmailButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "google-circle"), for: .normal)
        button.layer.applySketchShadow( alpha: 0.3, blur: 6, spread: 0)
        return button
    }()
    
    private lazy var versionLabel: UILabel = {
        let label = UILabel()
        label.font = .futuraBook(12)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.text = "version \(Environment.appVersion)(\(Environment.appBuild))\(Environment.appEnv)"
        return label
    }()
    
    internal lazy var termsTextView: UITextView = {
        
        var defaultAttributes: [NSAttributedString.Key: Any] = [
          NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.futuraBook(14)
        ]

        // Privacy Policy and Terms and Conditions
        let attributedString = NSMutableAttributedString(
          string: "By signing up, I accept Elated’s\n",
          attributes: defaultAttributes
        )
        
        attributedString.append(NSAttributedString(
          string: "Terms of Service",
          attributes: {
            var attribute = defaultAttributes
            attribute[NSAttributedString.Key.link] = "http://elated.io/tou"
            attribute[NSAttributedString.Key.underlineStyle] = NSUnderlineStyle.single.rawValue
            return attribute
          }()
        ))
        
        attributedString.append(NSAttributedString(
          string: " and ",
          attributes: defaultAttributes
        ))
        
        attributedString.append(NSAttributedString(
          string: "Privacy Policy",
          attributes: {
            var attribute = defaultAttributes
            attribute[NSAttributedString.Key.link] = "http://elated.io/privacy"
            attribute[NSAttributedString.Key.underlineStyle] = NSUnderlineStyle.single.rawValue
            return attribute
          }()
        ))
        
        let textView = UITextView()
        textView.delegate = self
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.attributedText = attributedString
        textView.linkTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        textView.textColor = .white
        textView.textAlignment = .center
        textView.backgroundColor = .clear
        return textView
    }()
    
    
    //TODO: Cleanup. Use better logic
    internal var rotateView1: UIView!
    internal var rotateView2: UIView!
    internal var rotateView3: UIView!
    internal var circleViews = [UIView]()
    internal var cnt = 1
    internal var timer : Timer?
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        //old code
        //GIDSignIn.sharedInstance.delegate = self
       //GIDSignIn.sharedInstance.presentingViewController = self

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupAnimations()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(false)
        timer?.invalidate()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        view.gradientBackground(from: .lavanderFloral,
                                to: .darkOrchid,
                                direction: .topToBottom)
        
        contentView.addSubview(rotateView)
        rotateView.snp.makeConstraints { make in
            make.top.equalTo(55)
            make.height.width.equalTo(263)
            make.centerX.equalToSuperview()
        }
        
        rotateView.addSubview(logo)
        logo.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-10)
            make.height.equalTo(89)
            make.width.equalTo(89)
        }
        
        contentView.addSubview(tagLineLabel)
        tagLineLabel.snp.makeConstraints { make in
            make.top.equalTo(rotateView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        
        contentView.addSubview(signupButton)
        signupButton.snp.makeConstraints { make in
            make.top.equalTo(tagLineLabel.snp.bottom).offset(44)
            make.left.right.equalToSuperview().inset(34)
            make.height.equalTo(50)
        }
        
        contentView.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.snp.makeConstraints { make in
            make.top.equalTo(signupButton.snp.bottom).offset(15)
            make.left.right.equalTo(signupButton)
        }
        
        contentView.addSubview(signInButton)
        signInButton.snp.makeConstraints { make in
            make.top.equalTo(alreadyHaveAccountButton.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(34)
            make.height.equalTo(50)
        }
        
        contentView.addSubview(lineLeft)
        lineLeft.snp.makeConstraints { make in
            make.top.equalTo(signInButton.snp.bottom).offset(33)
            make.left.equalToSuperview().inset(34)
            make.height.equalTo(1)
        }
    
        contentView.addSubview(orLabel)
        orLabel.snp.makeConstraints { make in
            make.left.equalTo(lineLeft.snp.right).offset(30)
            make.centerY.equalTo(lineLeft)
            make.width.equalTo(lineLeft)
        }
        
        contentView.addSubview(lineRight)
        lineRight.snp.makeConstraints { make in
            make.left.equalTo(orLabel.snp.right).offset(30)
            make.right.equalToSuperview().inset(34)
            make.centerY.equalTo(orLabel)
            make.height.equalTo(1)
            make.width.equalTo(orLabel)
        }

        fbButton.snp.makeConstraints { make in
            make.width.height.equalTo(55)
        }
        
        appleButton.snp.makeConstraints { make in
            make.width.height.equalTo(55)
        }
        
        gmailButton.snp.makeConstraints { make in
            make.width.height.equalTo(55)
        }
        
        let buttonStack = UIStackView(arrangedSubviews: [fbButton, appleButton, gmailButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 30
        contentView.addSubview(buttonStack)
        buttonStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(lineLeft.snp.bottom).offset(33)
        }
        
        contentView.addSubview(termsTextView)
        termsTextView.snp.makeConstraints { make in
            make.top.equalTo(buttonStack.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(34)
        }
        
        contentView.addSubview(versionLabel)
        versionLabel.snp.makeConstraints { make in
            make.top.equalTo(termsTextView.snp.bottom).offset(24)
            make.left.right.equalTo(termsTextView)
            make.bottom.equalToSuperview().inset(42)
        }
        
    }
    
    override func bind() {
        super.bind()
        
        viewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)

        viewModel.presentAlert.subscribe( onNext: { [weak self] args in
            let (title, message) = args
            self?.presentAlert(title: title, message: message)
        }).disposed(by: disposeBag)
        
        signupButton.rx.tap.bind { [weak self] in
            if let nav = self?.navigationController {
                nav.pushViewController(SignupViewController(), animated: true)
            } else {
                self?.show(SignupViewController(), sender: nil)
            }
        }.disposed(by: disposeBag)
        
        signInButton.rx.tap.bind { [weak self] in
            if let nav = self?.navigationController {
                nav.pushViewController(SigninViewController(), animated: true)
            } else {
                self?.show(SigninViewController.xib(), sender: nil)
            }
        }.disposed(by: disposeBag)
        
        gmailButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            //old code
            //GIDSignIn.sharedInstance().signIn()
            
            //new code
            self.manageActivityIndicator.accept(true)
            let signInConfig = GIDConfiguration.init(clientID: FirebaseApp.app()?.options.clientID ?? "")
            GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { [weak self] user, error in
                guard let self = self else { return }
                if let error = error {
                    self.manageActivityIndicator.accept(false)
                    self.presentAlert(title: "", message: error.localizedDescription)
                   return
                }
                guard let authentication = user?.authentication,
                      let userID = user?.userID
                else { return }
                self.viewModel.signupGoogle(token: authentication.accessToken, id: userID)
            }
        }.disposed(by: disposeBag)
        
        appleButton.rx.tap.bind { [weak self] in
            self?.appleLogin()
        }.disposed(by: disposeBag)
        
        fbButton.rx.tap.bind { [weak self] in
            self?.signUpWithFacebook()
        }.disposed(by: disposeBag)
        
        viewModel.user.subscribe(onNext: { user in
            guard let user = user else { return }
            if user.isActive == false {
                self.goToEmailVerification(email: user.email ?? "")
            }
            else if user.profile?.profileComplete == false {
                self.gotoOnboarding()
            }
            else if user.profile?.phoneNoVerified == false {
                self.goToOTP()
            } else {
                self.gotoMenu()
            }
        }).disposed(by: disposeBag)
        
        viewModel.supplyEmail.subscribe(onNext: { type, id, token in
            let nav = UINavigationController(rootViewController: SignupEmailSupplyViewController(type: type,
                                                                                                 socialMediaID: id,
                                                                                                 token: token))
            Util.setRootViewController(nav)
        }).disposed(by: disposeBag)
        
    }
    
    private func goToOTP() {
        let nav = UINavigationController(rootViewController: MobileOTPViewController())
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }

    private func goToEmailVerification(email: String) {
        let nav = UINavigationController(rootViewController: SignupConfirmationViewController(email, resend: true))
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }

    private func gotoOnboarding() {
        let nav = UINavigationController(rootViewController: OnboardingViewController.instantiate())
        Util.setRootViewController(nav)
        self.present(nav, animated: true, completion: nil)
    }

    private func gotoMenu() {
        let nav = UINavigationController(rootViewController: MenuTabBarViewController())
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
}


// MARK: - TextViewDelegate
extension LandingViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        var link: TermsViewController.LinkType = .terms
        if URL.absoluteString == "http://elated.io/privacy" {
            link = .policy
        }
        let vc = TermsViewController(link)
        vc.modalPresentationStyle = .fullScreen
        self.show(vc, sender: nil)
        return false
    }
    
}
