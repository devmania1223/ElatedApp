//
//  SigninViewController.swift
//  Elated
//
//  Created by Louise Nicolas Namoc on 3/8/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

import NSObject_Rx
import RxSwift

class SigninViewController: BaseViewController {
  @IBOutlet var emailTextField: UITextField!
  @IBOutlet var passwordTextField: UITextField!
  @IBOutlet var signInButton: UIButton!
  @IBOutlet var forgotPasswordButton: UIButton!

  let viewModel = SignInViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: true)
    
    self.viewModel.loginRetries.accept(0)
    forgotPasswordButton.titleLabel?.font = .futuraBook(14)
  }

  override func bind() {
    super.bind()
    bindView()
    bindEvents()
  }

  func bindView() {
    viewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)

    viewModel.presentAlert.subscribe(onNext: { [weak self] args in
      let (title, message) = args
      self?.presentAlert(title: title, message: message)
    }).disposed(by: disposeBag)

    emailTextField.rx.text.orEmpty.asDriver()
      .drive(viewModel.emailText)
      .disposed(by: disposeBag)

    passwordTextField.rx.text.orEmpty.asDriver()
      .drive(viewModel.passwordText)
      .disposed(by: disposeBag)

    viewModel.isFieldsComplete.map { $0 ? 1 : 0.6 }
      .bind(to: signInButton.rx.alpha)
      .disposed(by: disposeBag)

    viewModel.isFieldsComplete.bind(to:
      signInButton.rx.isUserInteractionEnabled
    ).disposed(by: disposeBag)
    
  }

  func bindEvents() {
    
    viewModel.onEmailValueChanged
      .subscribe(onNext: { [weak self] isEmpty in
        guard let self = self else { return }
        self.emailTextField.customizeTextField(
          false,
          leftImage: #imageLiteral(resourceName: "icon-email"),
          rightImage: nil,
          placeholder: "signin.email.placeholder".localized,
          colorTheme: isEmpty ? .silver : .elatedPrimaryPurple,
          borderWidth: isEmpty ? 0.25 : 1.5,
          cornerRadius: 30
        )
      }).disposed(by: disposeBag)

    viewModel.onPasswordValueChanged
      .subscribe(onNext: { [weak self] isEmpty in
        guard let self = self else { return }
        self.passwordTextField.customizeTextField(
          true,
          leftImage: #imageLiteral(resourceName: "icon-password"),
          rightImage: nil,
          placeholder: "signin.password.placeholder".localized,
          colorTheme: isEmpty ? .silver : .elatedPrimaryPurple,
          borderWidth: isEmpty ? 0.25 : 1.5,
          cornerRadius: 30
        )
      }).disposed(by: disposeBag)

    signInButton.rx.tap.bind { [weak self] in
      self?.viewModel.signIn()
    }.disposed(by: disposeBag)

    viewModel.success.subscribe(onNext: { [weak self] in
        guard let self = self,
              let user = MemCached.shared.userInfo else { return }
        
        //keep track of my online status
        if let id = user.id {
            FirebaseChat.shared.updateMyOnlineStatus(id: id, isOnline: false)
        }
        
        //register notif
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .badge]) { granted, error in
            if granted {
                #if DEBUG
                print("Success Granted Notification")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                #endif
            } else {
                #if DEBUG
                print("Error Register Notification \(error?.localizedDescription ?? "")")
                #endif
            }
        }

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

    forgotPasswordButton.rx.tap.bind { [weak self] in
      self?.show(ForgotPasswordViewController.xib(), sender: nil)
    }.disposed(by: disposeBag)
    
    viewModel.loginRetries.subscribe(onNext: { [weak self] tries in
        if tries >= 3 {
            self?.presentAlert(title: "signin.forgot.password.title".localized,
                               message: "signin.forgot.password.message".localized,
                               buttonTitles: ["common.cancel".localized,
                                              "signin.forgot.password".localized],
                               highlightedButtonIndex: 1) { index in
                                    if index == 1 {
                                        self?.show(ForgotPasswordViewController(), sender: nil)
                                    }
                               }
            self?.forgotPasswordButton.titleLabel?.font = .futuraBold(14)
        }
    }).disposed(by: disposeBag)
    
  }
    
    private func goToOTP() {
        let otpNav = UINavigationController(rootViewController: MobileOTPViewController())
        otpNav.modalPresentationStyle = .fullScreen
        self.present(otpNav, animated: true, completion: nil)
    }

    private func goToEmailVerification(email: String) {
        let landingNav = UINavigationController(rootViewController: SignupConfirmationViewController(email, resend: true))
        landingNav.modalPresentationStyle = .fullScreen
        self.present(landingNav, animated: true, completion: nil)
    }

    private func gotoOnboarding() {
        let landingNav = UINavigationController(rootViewController: CreateProfilePageViewController(addBooks: viewModel.addBooks.value, addMusic: true))
        landingNav.modalPresentationStyle = .fullScreen
        self.present(landingNav, animated: true, completion: nil)
    }

    private func gotoMenu() {
        let landingNav = UINavigationController(rootViewController: MenuTabBarViewController())
        landingNav.modalPresentationStyle = .fullScreen
        self.present(landingNav, animated: true, completion: nil)
    }
    
}
