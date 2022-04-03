//
//  SignUpViewController.swift
//  Elated
//
//  Created by keenan warouw on 18/09/20.
//  Copyright © 2020 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SimpleCheckbox
import Alamofire

class SignUpViewController: BaseViewController {
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var createElatedAccountLabel: UILabel!
    @IBOutlet weak var enterEmailView: UIView! {
        didSet {
            
        }
    }
    @IBOutlet weak var enterEmailTextField: UITextField!
    @IBOutlet weak var enterEmailImageView: UIImageView!
    @IBOutlet weak var confirmEmailView: UIView!
    @IBOutlet weak var confirmEmailImageView: UIImageView!
    @IBOutlet weak var confirmEmailTextField: UITextField!
    @IBOutlet weak var enterPasswordView: UIView!
    @IBOutlet weak var enterPasswordImageView: UIImageView!
    @IBOutlet weak var enterPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordView: UIView!
    @IBOutlet weak var confirmPasswordImage: UIImageView!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var updateCheckbox: Checkbox!
    @IBOutlet weak var checkBoxView: UIView!
    
    @IBOutlet weak var validationViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var validationPasswordHeightConstraints: NSLayoutConstraint!
    
    
    let enteredEmail: BehaviorRelay<String?> = BehaviorRelay<String?>(value: nil)
    let enteredConfirmEmail: BehaviorRelay<String?> = BehaviorRelay<String?>(value: nil)
    let enteredPassword: BehaviorRelay<String?> = BehaviorRelay<String?>(value: nil)
    let enteredConfirmedPassword: BehaviorRelay<String?> = BehaviorRelay<String?>(value: nil)
    
    var user: Me?
    
    static func instantiate(currentUser: Me) -> SignUpViewController {
        let storyboard: UIStoryboard = UIStoryboard(name: "SplashScreen", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController else {
            fatalError("Cannot instantiate PinCodeTakeOverViewController")
        }
        controller.user = currentUser
      return controller
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        let signInBarButton: UIBarButtonItem = UIBarButtonItem(title: "Sign in", style: .plain, target: self, action: #selector(toSignIn))
        navigationItem.rightBarButtonItem = signInBarButton
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createElatedAccountLabel.text = "Create your Elated\nAccount"
        setupEnterEmailElements()
        setupConfirmEmailElements()
        setupEnterPasswordElements()
        setupConfirmPasswordElements()
        setupSignUpButton()
        setupEmailTextFieldObservers()
        setupPasswordTextFieldObservers()
        setupCheckbox()
        addGestureForViews()
        view.backgroundColor = .white
        
    }
    
    @objc func toSignIn() {
        
        performSegue(withIdentifier: "signUpToSignIn", sender: self)
    }
    
    @objc func enableEnterEmailTF() {
        
        enterEmailTextField.becomeFirstResponder()
    }
    
    @objc func enableconfirmEmailTF() {
        
        confirmEmailTextField.becomeFirstResponder()
    }
    
    @objc func enableEnterPasswordTF() {
        
        enterPasswordTextField.becomeFirstResponder()
    }
    
    @objc func enableConfirmPasswordTF() {
        
        confirmPasswordTextField.becomeFirstResponder()
    }
    
    private func addGestureForViews() {
        
        let tap: UIGestureRecognizer = UIGestureRecognizer(target: self, action: #selector(enableEnterEmailTF))
        enterEmailView.addGestureRecognizer(tap)
        enterEmailView.isUserInteractionEnabled = true
        
        let tap2: UIGestureRecognizer = UIGestureRecognizer(target: self, action: #selector(enableconfirmEmailTF))
        confirmEmailView.addGestureRecognizer(tap2)
        confirmEmailView.isUserInteractionEnabled = true
        
        let tap3: UIGestureRecognizer = UIGestureRecognizer(target: self, action: #selector(enableEnterPasswordTF))
        enterPasswordView.addGestureRecognizer(tap3)
        enterPasswordView.isUserInteractionEnabled = true
        
        let tap4: UIGestureRecognizer = UIGestureRecognizer(target: self, action: #selector(enableConfirmPasswordTF))
        confirmPasswordView.addGestureRecognizer(tap4)
        confirmPasswordView.isUserInteractionEnabled = true
    }
    
    private func setupEmailTextFieldObservers() {
        
        let emailImage: UIImage = UIImage(named: "icon-email") ?? UIImage()
        
        /// Enter Email
        enterEmailTextField.rx.text.orEmpty
            .bind(to: enteredEmail).disposed(by: disposeBag)
        
        enteredEmail.asObservable()
            .subscribe(onNext: { [weak self] email in
                
                guard let self = self, let email = email else {
                    return
                }
                
                if !email.isEmpty {
                    
                    self.enterEmailView.layer.borderWidth = 1.5
                    self.enterEmailView.layer.borderColor = UIColor.purpleButtonColor.cgColor
                    
                    self.enterEmailImageView.image = emailImage.withTintColor(.purpleButtonColor)
                    
                } else {
                    
                    self.enterEmailView.layer.borderWidth = 0.25
                    self.enterEmailView.layer.borderColor = UIColor.inactiveBorderColor.cgColor
                    
                    self.enterEmailImageView.image = emailImage.withTintColor(.inactiveBorderColor)
                }
            })
            .disposed(by: disposeBag)
        
        ///Confirm Email
        confirmEmailTextField.rx.text.orEmpty
            .bind(to: enteredConfirmEmail).disposed(by: disposeBag)
        
        enteredConfirmEmail.asObservable()
            .throttle(0.3, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] email in
                
                guard let self = self, let email = email else {
                    return
                }
                
                if !email.isEmpty {
                    
                    if email.lowercased() == self.enteredEmail.value?.lowercased() {
                        
                        self.confirmEmailView.layer.borderWidth = 1.5
                        self.confirmEmailView.layer.borderColor = UIColor.purpleButtonColor.cgColor
                        self.checkImageView.isHidden = false
                        
                        self.confirmEmailImageView.image = emailImage.withTintColor(.purpleButtonColor)
                        
                    } else {
                        
                        self.confirmEmailView.layer.borderWidth = 1.5
                        self.confirmEmailView.layer.borderColor = UIColor.pinkWrongColor.cgColor
                        
                        
                        self.confirmEmailImageView.image = emailImage.withTintColor(.pinkWrongColor)
                    }
                    
                } else {
                    
                    self.confirmEmailView.layer.borderWidth = 0.25
                    self.confirmEmailView.layer.borderColor = UIColor.inactiveBorderColor.cgColor
                    
                    self.confirmEmailImageView.image = emailImage.withTintColor(.inactiveBorderColor)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupPasswordTextFieldObservers() {
        
        let lockImage: UIImage = UIImage(named: "icon-lock") ?? UIImage()

        /// Enter Password
        enterPasswordTextField.rx.text.orEmpty
            .bind(to: enteredPassword).disposed(by: disposeBag)
        
        enteredPassword.asObservable()
            .subscribe(onNext: { [weak self] password in
                
                guard let self = self, let password = password else {
                    return
                }
                if !password.isEmpty {
                    
                    if self.validatePassWord(password: password) {
                        self.enterPasswordView.layer.borderWidth = 1.5
                        self.enterPasswordView.layer.borderColor = UIColor.purpleButtonColor.cgColor
                        
                        self.enterPasswordImageView.image = lockImage.withTintColor(.purpleButtonColor)
                        self.validationViewHeightConstraints.constant = 0
                    } else {
                        self.enterPasswordView.layer.borderWidth = 1.5
                        self.enterPasswordView.layer.borderColor = UIColor.pinkWrongColor.cgColor
                        self.validationViewHeightConstraints.constant = 91
                    }
                    
                } else {
                    
                    self.enterPasswordView.layer.borderWidth = 0.25
                    self.enterPasswordView.layer.borderColor = UIColor.inactiveBorderColor.cgColor
                    
                    self.enterPasswordImageView.image = lockImage.withTintColor(.inactiveBorderColor)
                    self.validationViewHeightConstraints.constant = 0
                }
            })
            .disposed(by: disposeBag)
        
        ///Confirm Password
        confirmPasswordTextField.rx.text.orEmpty
            .bind(to: enteredConfirmedPassword).disposed(by: disposeBag)
        
        enteredConfirmedPassword.asObservable()
            .throttle(0.3, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] password in
                
                guard let self = self, let password = password else {
                    return
                }
                
                if !password.isEmpty {
                    
                    if password == self.enteredPassword.value {
                        
                        self.confirmPasswordView.layer.borderWidth = 1.5
                        self.confirmPasswordView.layer.borderColor = UIColor.purpleButtonColor.cgColor
                        
                        self.confirmPasswordImage.image = lockImage.withTintColor(.purpleButtonColor)
                        self.validationPasswordHeightConstraints.constant = 0

                    } else {
                        
                        self.confirmPasswordView.layer.borderWidth = 1.5
                        self.confirmPasswordView.layer.borderColor = UIColor.pinkWrongColor.cgColor
                        
                        self.confirmPasswordImage.image = lockImage.withTintColor(.pinkWrongColor)
                        self.validationPasswordHeightConstraints.constant = 50

                    }
                    
                } else {
                    
                    self.confirmPasswordView.layer.borderWidth = 0.25
                    self.confirmPasswordView.layer.borderColor = UIColor.inactiveBorderColor.cgColor
                    
                    self.confirmPasswordImage.image = lockImage.withTintColor(.inactiveBorderColor)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func validatePassWord(password: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{8,}$")
        return predicate.evaluate(with: password)
    }
    
    private func setupEnterEmailElements() {
        
        enterEmailView.layer.cornerRadius = 30
        enterEmailView.layer.borderWidth = 0.25
        enterEmailView.layer.borderColor = UIColor.inactiveBorderColor.cgColor
        enterEmailView.backgroundColor = UIColor.textFieldBackgroundColor
        
        let emailImage: UIImage = UIImage(named: "icon-email") ?? UIImage()
        enterEmailImageView.image = emailImage.withTintColor(.inactiveBorderColor)
        
        enterEmailTextField.backgroundColor = UIColor.textFieldBackgroundColor
        enterEmailTextField.textColor = .purpleButtonColor
        enterEmailTextField.keyboardType = .default
        enterEmailTextField.text = user?.email
        enterEmailTextField.attributedPlaceholder = NSAttributedString(string: "Enter your email address",
                                                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.inactiveBorderColor])
    }
    
    private func setupConfirmEmailElements() {
        
        confirmEmailView.layer.cornerRadius = 30
        confirmEmailView.layer.borderWidth = 0.25
        confirmEmailView.layer.borderColor = UIColor.inactiveBorderColor.cgColor
        confirmEmailView.backgroundColor = UIColor.textFieldBackgroundColor
        
        let emailImage: UIImage = UIImage(named: "icon-email") ?? UIImage()
        confirmEmailImageView.image = emailImage.withTintColor(.inactiveBorderColor)
        
        confirmEmailTextField.backgroundColor = UIColor.textFieldBackgroundColor
        confirmEmailTextField.textColor = .purpleButtonColor
        confirmEmailTextField.text = user?.email
        confirmEmailTextField.attributedPlaceholder = NSAttributedString(string: "Confirm your email address",
                                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.inactiveBorderColor])
        confirmEmailTextField.addDoneButtonOnKeyboard()
        checkImageView.isHidden = true
        let checkImage: UIImage = UIImage(named: "check") ?? UIImage()
        checkImageView.image = checkImage.withTintColor(.greenCheckColor)
    }
    
    private func setupEnterPasswordElements() {
        
        enterPasswordView.layer.cornerRadius = 30
        enterPasswordView.layer.borderWidth = 0.25
        enterPasswordView.layer.borderColor = UIColor.inactiveBorderColor.cgColor
        enterPasswordView.backgroundColor = UIColor.textFieldBackgroundColor
        
        let lockImage: UIImage = UIImage(named: "icon-lock") ?? UIImage()
        enterPasswordImageView.image = lockImage.withTintColor(.inactiveBorderColor)
        
        enterPasswordTextField.backgroundColor = UIColor.textFieldBackgroundColor
        enterPasswordTextField.isSecureTextEntry = true
        enterPasswordTextField.textColor = .purpleButtonColor
        enterPasswordTextField.text = ""
        enterPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Enter your password",
                                                                          attributes: [NSAttributedString.Key.foregroundColor: UIColor.inactiveBorderColor])
        enterPasswordTextField.addDoneButtonOnKeyboard()
        
    }
    
    private func setupConfirmPasswordElements() {
        
        confirmPasswordView.layer.cornerRadius = 30
        confirmPasswordView.layer.borderWidth = 0.25
        confirmPasswordView.layer.borderColor = UIColor.inactiveBorderColor.cgColor
        confirmPasswordView.backgroundColor = UIColor.textFieldBackgroundColor
        
        let lockImage: UIImage = UIImage(named: "icon-lock") ?? UIImage()
        confirmPasswordImage.image = lockImage.withTintColor(.inactiveBorderColor)
        
        confirmPasswordTextField.backgroundColor = UIColor.textFieldBackgroundColor
        confirmPasswordTextField.textColor = .purpleButtonColor
        confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.text = ""
        confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string: "Confirm your password",
                                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.inactiveBorderColor])
        confirmPasswordTextField.addDoneButtonOnKeyboard()
        
    }
    
    private func setupCheckbox() {
        
        updateCheckbox.checkmarkStyle = .tick
        updateCheckbox.borderStyle = .square
        updateCheckbox.checkmarkColor = .white
        
        updateCheckbox.checkedBorderColor = .purpleButtonColor
        updateCheckbox.uncheckedBorderColor = .checkBoxInactiveColor
        
        updateCheckbox.valueChanged = { (isChecked: Bool) in
            if isChecked {
                self.updateCheckbox.checkboxFillColor = .purpleButtonColor
            } else {
                self.updateCheckbox.checkboxFillColor = .inactiveBorderColor
            }
        }
        
        let tapGesture: UIGestureRecognizer = UIGestureRecognizer(target: self, action: #selector(toggleCheckbox))
        checkBoxView.addGestureRecognizer(tapGesture)
        checkBoxView.isUserInteractionEnabled = true
    }
    
    @objc func toggleCheckbox() {
        
        updateCheckbox.isChecked = !updateCheckbox.isChecked
        updateCheckbox.valueChanged?(updateCheckbox.isChecked)
        updateCheckbox.sendActions(for: .valueChanged)
    }
    
    private func setupSignUpButton() {
        
        signUpButton.tintColor = .white
        signUpButton.backgroundColor = UIColor.purpleButtonColor
        signUpButton.layer.borderColor = UIColor.purpleButtonColor.cgColor
        signUpButton.layer.borderWidth = 1.5
        signUpButton.layer.cornerRadius = 30
        signUpButton.tintColor = .white
        signUpButton.setTitle("Join Elated", for: .normal)
        signUpButton.titleLabel?.font = UIFont(name: "FuturaBT-Book", size: 18)
    }
    
    @IBAction func signUpButtonAction(_ sender: Any) {        
        let paramaters: Parameters = [
            "email": self.enterEmailTextField.text!,
            "username": self.enterEmailTextField.text!,
            "password": self.enterPasswordTextField.text!,
        ]
        
        Alamofire.request(AppConfig.API.url+"/auth​/users​/", method: .post, parameters: paramaters, encoding: JSONEncoding.default).responseJSON { (response) in
            
            print(response)
        }
    }
}

