//
//  HaveKidsViewController.swift
//  Elated
//
//  Created by Marlon on 4/5/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class EditProfileHaveKidsViewController: ScrollViewController {
    
    private let viewModel = EditProfileCommonViewModel()
    private let saveButton = UIBarButtonItem.creatTextButton("common.save".localized)
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "profile.editProfile.haveKidsTitle".localized
        label.font = .futuraMedium(22)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var nopeButton = createButton(.none)
    private lazy var companionsButton = createButton(.companions)
    private lazy var minionsButton = createButton(.minions)
    private lazy var halfHalfButton = createButton(.halfHalf)

    init(_ haveKids: HaveKids?) {
        super.init(nibName: nil, bundle: nil)
        if let haveKids = haveKids {
            setSelected(haveKids)
        }
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
        self.title = "profile.editProfile.title".localized
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
        
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(viewModel.titleLabelTopSpace.value)
            make.left.right.equalToSuperview().inset(50)
        }
        
        let stack = stackButton([nopeButton, companionsButton, minionsButton, halfHalfButton])
        contentView.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(91)
            make.left.right.equalToSuperview().inset(32)
            make.bottom.equalToSuperview().inset(32)
        }
        
    }
    
    private func createButton(_ preference: HaveKids) -> UIButton {
        let button = UIButton()
        button.setTitle(preference.getName(), for: .normal)
        button.setTitleColor(.elatedPrimaryPurple, for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.titleLabel?.font = .futuraBook(14)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 20
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.contentEdgeInsets = UIEdgeInsets(top: 13, left: 0, bottom: 13, right: 0)
        return button
    }
    
    private func stackButton(_ buttons: [UIButton]) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.distribution = .fillEqually
        stack.spacing = 20
        stack.axis = .vertical
        return stack
    }
    
    override func bind() {
        super.bind()
        
        viewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)
        
        viewModel.presentAlert.subscribe( onNext: { [weak self] args in
            let (title, message) = args
            self?.presentAlert(title: title, message: message)
        }).disposed(by: disposeBag)
        
        nopeButton.rx.tap.map { .none }.bind(to: viewModel.haveKids).disposed(by: disposeBag)
        companionsButton.rx.tap.map { .companions }.bind(to: viewModel.haveKids).disposed(by: disposeBag)
        minionsButton.rx.tap.map { .minions }.bind(to: viewModel.haveKids).disposed(by: disposeBag)
        halfHalfButton.rx.tap.map { .halfHalf }.bind(to: viewModel.haveKids).disposed(by: disposeBag)

        saveButton.rx.tap.bind { [weak self] in
            self?.viewModel.sendRequest(.haveKids)
        }.disposed(by: disposeBag)
        
        viewModel.haveKids.subscribe(onNext: { [weak self] haveKids in
            guard let haveKids = haveKids else { return }
            self?.setSelected(haveKids)
        }).disposed(by: disposeBag)
        
        viewModel.success.subscribe(onNext: { [weak self] args in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
    }
    
    private func setSelected(_ preference: HaveKids) {
        let collection = [nopeButton,
                          companionsButton,
                          minionsButton,
                          halfHalfButton]
        
        for button in collection {
            if button.titleLabel?.text == preference.getName() {
                button.isSelected = true
                button.backgroundColor = .elatedPrimaryPurple
            } else {
                button.isSelected = false
                button.backgroundColor = .white
            }
        }
        
    }

}

