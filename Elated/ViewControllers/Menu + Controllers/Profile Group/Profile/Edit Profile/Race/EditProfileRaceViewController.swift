//
//  EditProfileRaceViewController.swift
//  Elated
//
//  Created by Marlon on 3/29/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class EditProfileRaceViewController: ScrollViewController {

    let viewModel = EditProfileCommonViewModel()
    private let saveButton = UIBarButtonItem.creatTextButton("common.save".localized)
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "profile.editProfile.raceTitle".localized
        label.font = .futuraMedium(22)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
        
    private lazy var collectionView = CommonCollectionView([CommonDataModel(nil, title: Race.asian.getName()),
                                                            CommonDataModel(nil, title: Race.arab.getName()),
                                                            CommonDataModel(nil, title: Race.americanIndian.getName()),
                                                            CommonDataModel(nil, title: Race.blackAfrican.getName()),
                                                            CommonDataModel(nil, title: Race.hispanicLatina.getName()),
                                                            CommonDataModel(nil, title: Race.hispanicLatino.getName()),
                                                            CommonDataModel(nil, title: Race.pacificIslander.getName()),
                                                            CommonDataModel(nil, title: Race.southAsian.getName()),
                                                            CommonDataModel(nil, title: Race.whiteCaucasian.getName()),
                                                            CommonDataModel(nil, title: Race.other.getName())],
                                                           isEdit: false,
                                                           selectionType: .single)
    
    private let textField = UITextField.createNormalTextField("profile.editProfile.race.placeholder",
                                                              cornerRadius: 25)

    private let bottomBackground = UIImageView(image: #imageLiteral(resourceName: "lower_background"))
    
    private let nextButton = UIButton.createCommonBottomButton("common.next")
        
    init(_ type: EditInfoControllerType, race: String) {
        super.init(nibName: nil, bundle: nil)
        if let index = collectionView.data.value.firstIndex(where: { $0.title == race }) {
            collectionView.selectedItems.accept([index])
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
        
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(viewModel.titleLabelTopSpace.value)
            make.left.right.equalToSuperview().inset(50)
        }

        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(80)
            make.left.right.equalToSuperview().inset(32)
        }
        
        contentView.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(32)
            make.height.equalTo(50)
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
    
    override func bind() {
        super.bind()
        
        viewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)
        
        viewModel.presentAlert.subscribe( onNext: { [weak self] args in
            let (title, message) = args
            self?.presentAlert(title: title, message: message)
        }).disposed(by: disposeBag)
            
        collectionView.selectedItems.subscribe(onNext: { [weak self] items in
            guard let self = self else { return }
            if let first = items.first {
                let race = Race.convertToEnum(self.collectionView.data.value[first].title)
                self.viewModel.race.accept(race)
            }
        }).disposed(by: disposeBag)
        
        textField.rx.text.orEmpty.bind(to: viewModel.otherRace).disposed(by: disposeBag)
        
        saveButton.rx.tap.bind { [weak self] in
            self?.viewModel.sendRequest(.race)
        }.disposed(by: disposeBag)
        
        viewModel.editType.subscribe(onNext: { [weak self] type in
            guard let self = self else { return }
            self.title = type == .edit ? "profile.editProfile.title".localized : ""
        }).disposed(by: disposeBag)
        
        viewModel.race.subscribe(onNext: { [weak self] arg in
            let valid = arg != nil
            self?.nextButton.isUserInteractionEnabled = valid
            self?.nextButton.alpha = valid ? 1 : 0.6
            
            self?.textField.isHidden = arg != .other
        }).disposed(by: disposeBag)
        
        nextButton.rx.tap.bind { [weak self] in
            self?.viewModel.sendRequest(.race)
        }.disposed(by: disposeBag)
        
        viewModel.success.subscribe(onNext: { [weak self] args in
            if self?.viewModel.editType.value != .onboarding {
                self?.navigationController?.popViewController(animated: true)
            }
        }).disposed(by: disposeBag)
        
    }

}

