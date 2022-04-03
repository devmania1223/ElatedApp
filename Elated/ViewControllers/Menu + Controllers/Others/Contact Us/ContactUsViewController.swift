//
//  ContactUsViewController.swift
//  Elated
//
//  Created by Marlon on 2021/3/9.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import SideMenu
import RxSwift
import RxCocoa

class ContactUsViewController: ScrollViewController {

    internal lazy var menu = self.createMenu(SideMenuViewController.shared)
    internal let menuButton = UIBarButtonItem.createMenuButton()
    
    let viewModel = ContactUsViewModel()
    
    private let selectLabel: UILabel = {
        let label = UILabel()
        label.font = .futuraMedium(16)
        label.text = "contactUs.select".localized
        label.textColor = .jet
        return label
    }()
    
    private let suggestBullet = Bullet("contactUs.suggest".localized)
    private let questionBullet = Bullet("contactUs.question".localized)
    private let reportTechnicalBullet = Bullet("contactUs.reportTechnical".localized)
    private let reportBillingBullet = Bullet("contactUs.reportBilling".localized)
    
    private lazy var bulletStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [suggestBullet,
                                                       questionBullet,
                                                       reportTechnicalBullet,
                                                       reportBillingBullet])
        stackView.axis = .vertical
        stackView.spacing = 17
        return stackView
    }()

    private let textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .alabasterSolid
        return textField
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.font = .futuraBook(14)
        textView.textColor = .sonicSilver
        textView.backgroundColor = .alabasterSolid
        textView.layer.borderWidth = 0.25
        textView.layer.borderColor = UIColor.silver.cgColor
        textView.layer.cornerRadius = 6
        textView.text = "contactUs.message.placeholder".localized
        textView.textContainerInset = UIEdgeInsets(top: 21, left: 16, bottom: 21, right: 16)
        return textView
    }()
    
    internal let sendButton = UIButton.createCommonBottomButton("contactUs.send")
   
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "menu.item.contactUs".localized
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.leftBarButtonItem = menuButton
        menuButton.tintColor = .white
        self.setupNavigationBar(.white,
                                font: .futuraMedium(20),
                                tintColor: .white,
                                backgroundImage: #imageLiteral(resourceName: "background-header"))
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        contentView.addSubview(selectLabel)
        selectLabel.snp.makeConstraints { make in
            make.top.left.equalTo(32)
        }
        
        contentView.addSubview(bulletStack)
        bulletStack.snp.makeConstraints { make in
            make.top.equalTo(selectLabel.snp.bottom).offset(19)
            make.left.right.equalToSuperview().inset(32)
        }
        
        contentView.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.equalTo(bulletStack.snp.bottom).offset(28)
            make.left.right.equalTo(bulletStack)
            make.height.equalTo(50)
        }
        
        contentView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(17)
            make.left.right.equalTo(textField)
            make.height.equalTo(150)
        }
        
        contentView.addSubview(sendButton)
        sendButton.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(28)
            make.left.right.equalTo(textView)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().inset(50)
        }
        
    }
    
    override func bind() {
        super.bind()
        bindView()
        bindEvent()
    }
    
    private func bindView() {
        
        viewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)
        
        viewModel.presentAlert.subscribe( onNext: { [weak self] args in
            let (title, message) = args
            self?.presentAlert(title: title, message: message)
        }).disposed(by: disposeBag)
        
        suggestBullet.selected.subscribe(onNext: { [weak self] selected in
            if selected {
                self?.viewModel.selected.accept(.suggestion)
            }
        }).disposed(by: disposeBag)

        questionBullet.selected.subscribe(onNext: { [weak self] selected in
            if selected {
                self?.viewModel.selected.accept(.question)
            }
        }).disposed(by: disposeBag)
        
        reportTechnicalBullet.selected.subscribe(onNext: { [weak self] selected in
            if selected {
                self?.viewModel.selected.accept(.reportTechnical)
            }
        }).disposed(by: disposeBag)
        
        reportBillingBullet.selected.subscribe(onNext: { [weak self] selected in
            if selected {
                self?.viewModel.selected.accept(.reportBilling)
            }
        }).disposed(by: disposeBag)

        textField.rx.text.orEmpty
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        textView.rx.text.orEmpty
            .bind(to: viewModel.message)
            .disposed(by: disposeBag)
        
        viewModel.allowSend
            .bind(to: sendButton.rx.isUserInteractionEnabled)
            .disposed(by: disposeBag)
        
        viewModel.allowSend
            .map { $0 ? 1 : 0.6 }
            .bind(to: sendButton.rx.alpha)
            .disposed(by: disposeBag)
       
        viewModel.messageValid
            .map { $0 ? 1.5 : 0.25 }
            .bind(to: textView.layer.rx.borderWidth )
            .disposed(by: disposeBag)
        
        viewModel.messageValid
            .map { $0 ? UIColor.elatedPrimaryPurple : UIColor.silver }
            .bind(to: textView.layer.rx.borderColor )
            .disposed(by: disposeBag)
        
    }
    
    private func bindEvent() {
        
        menuButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.present(self.menu, animated: true, completion: nil)
        }.disposed(by: disposeBag)
        
        viewModel.emailValid.subscribe(onNext: { [weak self] isValid in
            self?.textField.customizeTextField(false,
                                               leftImage: nil,
                                               rightImage: nil,
                                               placeholder: "signin.email.placeholder".localized,
                                               colorTheme: isValid ? .elatedPrimaryPurple : .silver,
                                               borderWidth: isValid ? 1.5 : 0.25,
                                               cornerRadius: 25,
                                               spacerWidth: 26)
          }).disposed(by: disposeBag)
        
        viewModel.selected.subscribe(onNext: { [weak self] selected in
            switch selected {
            case ContactUsViewModel.Concern.suggestion:
                self?.questionBullet.selected.accept(false)
                self?.reportTechnicalBullet.selected.accept(false)
                self?.reportBillingBullet.selected.accept(false)
                break
            case ContactUsViewModel.Concern.question:
                self?.suggestBullet.selected.accept(false)
                self?.reportTechnicalBullet.selected.accept(false)
                self?.reportBillingBullet.selected.accept(false)
                break
            case ContactUsViewModel.Concern.reportTechnical:
                self?.suggestBullet.selected.accept(false)
                self?.questionBullet.selected.accept(false)
                self?.reportBillingBullet.selected.accept(false)
                break
            case ContactUsViewModel.Concern.reportBilling:
                self?.suggestBullet.selected.accept(false)
                self?.questionBullet.selected.accept(false)
                self?.reportTechnicalBullet.selected.accept(false)
                break
            }
        }).disposed(by: disposeBag)

        sendButton.rx.tap.bind { [weak self] in
            self?.viewModel.sendMessage()
        }.disposed(by: disposeBag)
        
        textView.rx.didBeginEditing.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            if self.textView.text == "contactUs.message.placeholder".localized {
                self.textView.text = ""
            }
        }).disposed(by: disposeBag)
        
        textView.rx.didEndEditing.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            if self.textView.text.isEmpty {
                self.textView.text = "contactUs.message.placeholder".localized
            }
        }).disposed(by: disposeBag)
        
    }

}
