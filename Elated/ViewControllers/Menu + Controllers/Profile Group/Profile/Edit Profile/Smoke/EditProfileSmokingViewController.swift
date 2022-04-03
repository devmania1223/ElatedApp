//
//  EditProfileSmokingViewController.swift
//  Elated
//
//  Created by Marlon on 4/5/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class EditProfileSmokingViewController: ScrollViewController {
    
    private let viewModel = EditProfileCommonViewModel()
    private let saveButton = UIBarButtonItem.creatTextButton("common.save".localized)
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "profile.editProfile.smokingTitle".localized
        label.font = .futuraMedium(22)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private let subLabel: UILabel = {
        let label = UILabel()
        label.text = "profile.editProfile.smokingSubTitle".localized
        label.font = .futuraBook(18)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .sonicSilver
        return label
    }()
    
    private lazy var notOpenButton = createButton(.notOpen)
    private lazy var neverButton = createButton(.never)
    private lazy var four20Button = createButton(.four20)
    private lazy var ocationalButton = createButton(.ocational)
    private lazy var fineButton = createButton(.fine)
    private lazy var oftenButton = createButton(.often)
    private lazy var welcomeButton = createButton(.welcome)

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
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(viewModel.titleLabelTopSpace.value)
            make.left.right.equalToSuperview().inset(50)
        }
        
        contentView.addSubview(subLabel)
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.equalTo(titleLabel)
        }
        
        let stack = stackButton([notOpenButton, neverButton, four20Button, ocationalButton, fineButton, oftenButton, welcomeButton])
        contentView.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.equalTo(subLabel.snp.bottom).offset(91)
            make.left.right.equalToSuperview().inset(32)
            make.bottom.equalToSuperview().inset(32)
        }
        
    }
    
    private func createButton(_ preference: SmokingPreference) -> UIButton {
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
        
        notOpenButton.rx.tap.bind { [weak self] pref in
            guard let self = self else { return }
            var pref = self.viewModel.smokingPreference.value
            pref.contains(.notOpen) ? pref.remove(.notOpen) : pref.append(.notOpen)
            self.viewModel.smokingPreference.accept(pref)
        }.disposed(by: disposeBag)
        
        neverButton.rx.tap.bind { [weak self] pref in
            guard let self = self else { return }
            var pref = self.viewModel.smokingPreference.value
            pref.contains(.never) ? pref.remove(.never) : pref.append(.never)
            self.viewModel.smokingPreference.accept(pref)
        }.disposed(by: disposeBag)
        
        four20Button.rx.tap.bind { [weak self] pref in
            guard let self = self else { return }
            var pref = self.viewModel.smokingPreference.value
            pref.contains(.four20) ? pref.remove(.four20) : pref.append(.four20)
            self.viewModel.smokingPreference.accept(pref)
        }.disposed(by: disposeBag)
        
        ocationalButton.rx.tap.bind { [weak self] pref in
            guard let self = self else { return }
            var pref = self.viewModel.smokingPreference.value
            pref.contains(.ocational) ? pref.remove(.ocational) : pref.append(.ocational)
            self.viewModel.smokingPreference.accept(pref)
        }.disposed(by: disposeBag)
        
        fineButton.rx.tap.bind { [weak self] pref in
            guard let self = self else { return }
            var pref = self.viewModel.smokingPreference.value
            pref.contains(.fine) ? pref.remove(.fine) : pref.append(.fine)
            self.viewModel.smokingPreference.accept(pref)
        }.disposed(by: disposeBag)
        
        oftenButton.rx.tap.bind { [weak self] pref in
            guard let self = self else { return }
            var pref = self.viewModel.smokingPreference.value
            pref.contains(.often) ? pref.remove(.often) : pref.append(.often)
            self.viewModel.smokingPreference.accept(pref)
        }.disposed(by: disposeBag)
        
        welcomeButton.rx.tap.bind { [weak self] pref in
            guard let self = self else { return }
            var pref = self.viewModel.smokingPreference.value
            pref.contains(.welcome) ? pref.remove(.welcome) : pref.append(.welcome)
            self.viewModel.smokingPreference.accept(pref)
        }.disposed(by: disposeBag)

        saveButton.rx.tap.bind { [weak self] in
            self?.viewModel.sendRequest(.smokingPrefence)
        }.disposed(by: disposeBag)
        
        viewModel.smokingPreference.subscribe(onNext: { [weak self] pref in
            self?.setSelected(pref)
        }).disposed(by: disposeBag)
        
        viewModel.success.subscribe(onNext: { [weak self] args in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
    }
    
    private func setSelected(_ preferences: [SmokingPreference]) {
        let collection = [notOpenButton,
                          neverButton,
                          four20Button,
                          ocationalButton,
                          fineButton,
                          oftenButton,
                          welcomeButton]
        
        let names = preferences.map { $0.getName() }
        for button in collection {
            if names.contains(button.titleLabel?.text ?? "") {
                button.isSelected = true
                button.backgroundColor = .elatedPrimaryPurple
            } else {
                button.isSelected = false
                button.backgroundColor = .white
            }
        }
    }

}


