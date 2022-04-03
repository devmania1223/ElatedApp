//
//  EditProfileBioViewController.swift
//  Elated
//
//  Created by Marlon on 3/26/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class EditProfileBioViewController: ScrollViewController {

    let viewModel = EditProfileCommonViewModel()
    private let saveButton = UIBarButtonItem.creatTextButton("common.save".localized)

    private let label: UILabel = {
        let label = UILabel()
        label.text = "profile.editProfile.bioTitle".localized
        label.font = .futuraMedium(22)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    internal let textView: UITextView = {
        let textView = UITextView()
        textView.font = .futuraBook(14)
        textView.textColor = .sonicSilver
        textView.backgroundColor = .alabasterSolid
        textView.layer.borderWidth = 0.25
        textView.layer.borderColor = UIColor.silver.cgColor
        textView.layer.cornerRadius = 6
        textView.text = "sample.profile".localized
        textView.textContainerInset = UIEdgeInsets(top: 21, left: 16, bottom: 21, right: 16)
        return textView
    }()
    
    private let bottomBackground = UIImageView(image: #imageLiteral(resourceName: "lower_background"))
    
    private let nextButton = UIButton.createCommonBottomButton("common.next")
    
    init(_ type: EditInfoControllerType, bio: String) {
        super.init(nibName: nil, bundle: nil)
        textView.text = bio
        viewModel.editType.accept(type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let type = viewModel.editType.value
        self.navigationItem.rightBarButtonItem = type == .onboarding ? nil : saveButton
        self.setupNavigationBar(type == .onboarding ? .elatedPrimaryPurple : .white,
                                font: .futuraMedium(20),
                                tintColor: type == .onboarding ? .elatedPrimaryPurple : .white,
                                backgroundImage: type == .onboarding ? nil : #imageLiteral(resourceName: "background-header"),
                                addBackButton: type != .onboarding)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(viewModel.titleLabelTopSpace.value)
            make.left.right.equalToSuperview().inset(50)
        }
        
        contentView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(84)
            make.left.right.equalToSuperview().inset(15)
            make.centerX.equalToSuperview()
            make.height.equalTo(300)
            make.bottom.equalToSuperview()
        }
        
    }
    
    override func bind() {
        super.bind()
        
        viewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)
        
        viewModel.presentAlert.subscribe( onNext: { [weak self] args in
            let (title, message) = args
            self?.presentAlert(title: title, message: message)
        }).disposed(by: disposeBag)
        
        textView.rx.text.orEmpty.bind(to: viewModel.bio).disposed(by: disposeBag)
        
        saveButton.rx.tap.bind { [weak self] in
            self?.viewModel.sendRequest(.bio)
        }.disposed(by: disposeBag)
        
        viewModel.editType.subscribe(onNext: { [weak self] type in
            guard let self = self else { return }
            self.title = type == .edit ? "profile.editProfile.title".localized : ""
            if type == .onboarding {
                self.view.addSubview(self.bottomBackground)
                self.bottomBackground.snp.makeConstraints { make in
                    make.height.equalTo(135) //including offset 2
                    make.left.equalToSuperview().offset(-2)
                    make.right.bottom.equalToSuperview().offset(2)
                }
                
                self.view.addSubview(self.nextButton)
                self.nextButton.snp.makeConstraints { make in
                    make.centerY.equalTo(self.bottomBackground)
                    make.left.right.equalToSuperview().inset(33)
                    make.height.equalTo(50)
                }
                
                self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 140, right: 0)
            }
        }).disposed(by: disposeBag)
        
        viewModel.bio.subscribe(onNext: { [weak self] arg in
            guard let arg = arg else { return }
            let valid = !arg.isEmpty
            self?.nextButton.isUserInteractionEnabled = valid
            self?.nextButton.alpha = valid ? 1 : 0.6
        }).disposed(by: disposeBag)
        
        nextButton.rx.tap.bind { [weak self] in
            self?.viewModel.sendRequest(.bio)
        }.disposed(by: disposeBag)
        
        viewModel.success.subscribe(onNext: { [weak self] args in
            if self?.viewModel.editType.value != .onboarding {
                self?.navigationController?.popViewController(animated: true)
            }
        }).disposed(by: disposeBag)
        
    }

}
