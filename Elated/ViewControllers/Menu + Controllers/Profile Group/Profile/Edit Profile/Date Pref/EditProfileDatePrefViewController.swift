//
//  EditProfileDatePrefViewController.swift
//  Elated
//
//  Created by Marlon on 4/3/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class EditProfileDatePrefViewController: ScrollViewController {
    
    private let viewModel = EditProfileCommonViewModel()
    private let saveButton = UIBarButtonItem.creatTextButton("common.save".localized)
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "profile.editProfile.datePreferenceTitle".localized
        label.font = .futuraMedium(22)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var casualButton = createButton(.casual)
    private lazy var soulmateButton = createButton(.soulMate)
    private lazy var notSureButton = createButton(.notSure)

    init(_ preference: DatingPreference?) {
        super.init(nibName: nil, bundle: nil)
        if let preference = preference {
            setSelected(preference)
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
        
        let stack = stackButton([casualButton, soulmateButton, notSureButton])
        contentView.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(91)
            make.left.right.equalToSuperview().inset(32)
            make.bottom.equalToSuperview().inset(32)
        }
        
    }
    
    private func createButton(_ preference: DatingPreference) -> UIButton {
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
        
        casualButton.rx.tap.map { .casual }.bind(to: viewModel.datingPreference).disposed(by: disposeBag)
        soulmateButton.rx.tap.map { .soulMate }.bind(to: viewModel.datingPreference).disposed(by: disposeBag)
        notSureButton.rx.tap.map { .notSure }.bind(to: viewModel.datingPreference).disposed(by: disposeBag)

        saveButton.rx.tap.bind { [weak self] in
            self?.viewModel.sendRequest(.datingPreference)
        }.disposed(by: disposeBag)
        
        viewModel.datingPreference.subscribe(onNext: { [weak self] pref in
            guard let pref = pref else { return }
            self?.setSelected(pref)
        }).disposed(by: disposeBag)
        
        viewModel.success.subscribe(onNext: { [weak self] args in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
    }
    
    private func setSelected(_ preference: DatingPreference) {
        let collection = [casualButton,
                          soulmateButton,
                          notSureButton]
        
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
