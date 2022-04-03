//
//  EditProfileGenderViewController.swift
//  Elated
//
//  Created by Marlon on 4/5/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class EditProfileGenderViewController: ScrollViewController {
    
    let viewModel = EditProfileCommonViewModel()
    private let saveButton = UIBarButtonItem.creatTextButton("common.save".localized)
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "profile.editProfile.genderTitle".localized
        label.font = .futuraMedium(22)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let bottomBackground = UIImageView(image: #imageLiteral(resourceName: "lower_background"))
    
    private let nextButton = UIButton.createCommonBottomButton("common.next")
    
    private lazy var femaleButton = createButton(.female)
    private lazy var maleButton = createButton(.male)
    private lazy var bisexualButton = createButton(.bisexual)
    private lazy var gayButton = createButton(.gay)
    private lazy var lesbianButton = createButton(.lesbian)
    private lazy var transgenderButton = createButton(.transgender)
    private lazy var otherButton = createButton(.other)

    init(_ type: EditInfoControllerType,
         gender: Gender?,
         isGenderPreference: Bool) {
        
        super.init(nibName: nil, bundle: nil)
        
        if let gender = gender {
            setSelected(gender)
        }

        viewModel.editType.accept(type)
        viewModel.isGenderPreference.accept(isGenderPreference)
        
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
    
    override func initSubviews() {
        super.initSubviews()
        
        let row1 = stackButton([femaleButton, maleButton])
        let row2 = stackButton([bisexualButton, gayButton])
        let row3 = stackButton([lesbianButton, transgenderButton])
        let row4 = stackButton([otherButton, UIButton()])

        let mainStack = UIStackView(arrangedSubviews: [row1, row2, row3, row4])
        mainStack.spacing = 15
        mainStack.axis = .vertical
        mainStack.distribution = .fillEqually
        
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(viewModel.titleLabelTopSpace.value)
            make.left.right.equalToSuperview().inset(50)
        }
        
        contentView.addSubview(mainStack)
        mainStack.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(50)
            make.left.right.equalToSuperview().inset(32)
            make.bottom.equalToSuperview().inset(32)
        }
        
        if viewModel.editType.value == .onboarding {
            view.addSubview(bottomBackground)
            bottomBackground.snp.makeConstraints { make in
                make.height.equalTo(135) //including offset 2
                make.left.equalToSuperview().offset(-2)
                make.right.bottom.equalToSuperview().offset(2)
            }

            view.addSubview(nextButton)
            nextButton.snp.makeConstraints { make in
                make.centerY.equalTo(bottomBackground)
                make.left.right.equalToSuperview().inset(33)
                make.height.equalTo(50)
            }

            scrollView.snp.remakeConstraints({ make in
                make.left.right.equalToSuperview()
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                make.bottom.equalTo(bottomBackground.snp.top)
            })
        }
        
    }
    
    private func createButton(_ preference: Gender) -> UIButton {
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
        stack.axis = .horizontal
        return stack
    }
    
    private func setSelected(_ preference: Gender) {
        let collection = [femaleButton,
                          maleButton,
                          bisexualButton,
                          gayButton,
                          lesbianButton,
                          transgenderButton,
                          otherButton]
        
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
    
    override func bind() {
        super.bind()
        
        viewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)
        
        viewModel.presentAlert.subscribe( onNext: { [weak self] args in
            let (title, message) = args
            self?.presentAlert(title: title, message: message)
        }).disposed(by: disposeBag)
        
        femaleButton.rx.tap.map { .female }.bind(to: viewModel.gender).disposed(by: disposeBag)
        maleButton.rx.tap.map { .male }.bind(to: viewModel.gender).disposed(by: disposeBag)
        bisexualButton.rx.tap.map { .bisexual }.bind(to: viewModel.gender).disposed(by: disposeBag)
        gayButton.rx.tap.map { .gay }.bind(to: viewModel.gender).disposed(by: disposeBag)
        lesbianButton.rx.tap.map { .lesbian }.bind(to: viewModel.gender).disposed(by: disposeBag)
        transgenderButton.rx.tap.map { .transgender }.bind(to: viewModel.gender).disposed(by: disposeBag)
        otherButton.rx.tap.map { .other }.bind(to: viewModel.gender).disposed(by: disposeBag)

        saveButton.rx.tap.bind { [weak self] in
            self?.viewModel.sendRequest(.gender)
        }.disposed(by: disposeBag)
        
        viewModel.gender.subscribe(onNext: { [weak self] gender in
            guard let gender = gender else { return }
            self?.setSelected(gender)
        }).disposed(by: disposeBag)
        
        viewModel.editType.subscribe(onNext: { [weak self] type in
            guard let self = self else { return }
            switch type {
            case .edit:
                self.label.text = "profile.editProfile.genderTitle".localized
                self.title = "profile.editProfile.title".localized
            case .onboarding:
                self.label.text = "profile.editProfile.genderTitle".localized
                self.title = ""
                break
            case .settings:
                self.label.text =  "settings.gender.title".localized
                self.title = "settings.edit.title".localized
                break
            }
        }).disposed(by: disposeBag)
        
        viewModel.isGenderPreference.subscribe(onNext: { [weak self] isGenderPreference in
            self?.label.text = isGenderPreference
                ? "settings.gender.title".localized
                : "profile.editProfile.genderTitle".localized
        }).disposed(by: disposeBag)
        
        viewModel.gender.subscribe(onNext: { [weak self] arg in
            let valid = arg != nil
            self?.nextButton.isUserInteractionEnabled = valid
            self?.nextButton.alpha = valid ? 1 : 0.6
        }).disposed(by: disposeBag)
        
        nextButton.rx.tap.bind { [weak self] in
            self?.viewModel.sendRequest(.gender)
        }.disposed(by: disposeBag)
        
        viewModel.success.subscribe(onNext: { [weak self] args in
            if self?.viewModel.editType.value != .onboarding {
                self?.navigationController?.popViewController(animated: true)
            }
        }).disposed(by: disposeBag)
        
    }

}
