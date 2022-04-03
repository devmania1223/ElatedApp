//
//  EditProfileZodiacViewController.swift
//  Elated
//
//  Created by Marlon on 4/2/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class EditProfileZodiacViewController: ScrollViewController {
    
    let viewModel = EditProfileCommonViewModel()
    private let saveButton = UIBarButtonItem.creatTextButton("common.save".localized)
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "profile.editProfile.zodiacSignTitle".localized
        label.font = .futuraMedium(22)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var ariesButton = createZodiacButton(.aries)
    private lazy var taurusButton = createZodiacButton(.taurus)
    private lazy var geminiButton = createZodiacButton(.gemini)
    private lazy var cancerButton = createZodiacButton(.cancer)
    private lazy var leoButton = createZodiacButton(.leo)
    private lazy var virgoButton = createZodiacButton(.virgo)
    private lazy var libraButton = createZodiacButton(.libra)
    private lazy var scorpioButton = createZodiacButton(.scorpio)
    private lazy var sagitariusButton = createZodiacButton(.sagitarius)
    private lazy var capricornButton = createZodiacButton(.capricorn)
    private lazy var aquariusButton = createZodiacButton(.aquarius)
    private lazy var piscesButton = createZodiacButton(.pisces)

    private let bottomBackground = UIImageView(image: #imageLiteral(resourceName: "lower_background"))
    
    private let nextButton = UIButton.createCommonBottomButton("common.next")
    
    init(_ type: EditInfoControllerType, zodiac: Zodiac?) {
        super.init(nibName: nil, bundle: nil)
        if let zodiac = zodiac {
            setSelected(zodiac)
        }
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
    
    override func initSubviews() {
        super.initSubviews()
        
        let row1 = stackButton([ariesButton, taurusButton])
        let row2 = stackButton([geminiButton, cancerButton])
        let row3 = stackButton([leoButton, virgoButton])
        let row4 = stackButton([libraButton, scorpioButton])
        let row5 = stackButton([sagitariusButton, capricornButton])
        let row6 = stackButton([aquariusButton, piscesButton])
        
        let mainStack = UIStackView(arrangedSubviews: [row1, row2, row3, row4, row5, row6])
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
        
    }
    
    private func createZodiacButton(_ zodiac: Zodiac) -> UIButton {
        let button = UIButton()
        button.setTitle(zodiac.rawValue.capitalized, for: .normal)
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
    
    override func bind() {
        super.bind()
        
        viewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)
        
        viewModel.presentAlert.subscribe( onNext: { [weak self] args in
            let (title, message) = args
            self?.presentAlert(title: title, message: message)
        }).disposed(by: disposeBag)
        
        ariesButton.rx.tap.map { .aries }.bind(to: viewModel.zodiac).disposed(by: disposeBag)
        taurusButton.rx.tap.map { .taurus }.bind(to: viewModel.zodiac).disposed(by: disposeBag)
        geminiButton.rx.tap.map { .gemini }.bind(to: viewModel.zodiac).disposed(by: disposeBag)
        cancerButton.rx.tap.map { .cancer }.bind(to: viewModel.zodiac).disposed(by: disposeBag)
        leoButton.rx.tap.map { .leo }.bind(to: viewModel.zodiac).disposed(by: disposeBag)
        virgoButton.rx.tap.map { .virgo }.bind(to: viewModel.zodiac).disposed(by: disposeBag)
        libraButton.rx.tap.map { .libra }.bind(to: viewModel.zodiac).disposed(by: disposeBag)
        scorpioButton.rx.tap.map { .scorpio }.bind(to: viewModel.zodiac).disposed(by: disposeBag)
        sagitariusButton.rx.tap.map { .sagitarius }.bind(to: viewModel.zodiac).disposed(by: disposeBag)
        capricornButton.rx.tap.map { .capricorn }.bind(to: viewModel.zodiac).disposed(by: disposeBag)
        aquariusButton.rx.tap.map { .aquarius }.bind(to: viewModel.zodiac).disposed(by: disposeBag)
        piscesButton.rx.tap.map { .pisces }.bind(to: viewModel.zodiac).disposed(by: disposeBag)

        saveButton.rx.tap.bind { [weak self] in
            self?.viewModel.sendRequest(.zodiac)
        }.disposed(by: disposeBag)
        
        viewModel.zodiac.subscribe(onNext: { [weak self] zodiac in
            guard let zodiac = zodiac else { return }
            self?.setSelected(zodiac)
        }).disposed(by: disposeBag)
        
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
        
        viewModel.zodiac.subscribe(onNext: { [weak self] arg in
            let valid = arg != nil
            self?.nextButton.isUserInteractionEnabled = valid
            self?.nextButton.alpha = valid ? 1 : 0.6
        }).disposed(by: disposeBag)
        
        nextButton.rx.tap.bind { [weak self] in
            self?.viewModel.sendRequest(.zodiac)
        }.disposed(by: disposeBag)
        
        viewModel.success.subscribe(onNext: { [weak self] args in
            if self?.viewModel.editType.value != .onboarding {
                self?.navigationController?.popViewController(animated: true)
            }
        }).disposed(by: disposeBag)
        
    }
    
    private func setSelected(_ zodiac: Zodiac) {
        let collection = [ariesButton,
                          taurusButton,
                          geminiButton,
                          cancerButton,
                          leoButton,
                          virgoButton,
                          libraButton,
                          scorpioButton,
                          sagitariusButton,
                          capricornButton,
                          aquariusButton,
                          piscesButton]
        
        for button in collection {
            if button.titleLabel?.text == zodiac.rawValue.capitalized {
                button.isSelected = true
                button.backgroundColor = .elatedPrimaryPurple
            } else {
                button.isSelected = false
                button.backgroundColor = .white
            }
        }
        
    }

}
