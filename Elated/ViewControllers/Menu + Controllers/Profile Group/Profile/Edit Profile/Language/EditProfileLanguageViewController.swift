//
//  EditProfileLanguageViewController.swift
//  Elated
//
//  Created by Marlon on 3/27/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class EditProfileLanguageViewController: BaseViewController {

    let viewModel = EditProfileCommonViewModel()
    private let saveButton = UIBarButtonItem.creatTextButton("common.save".localized)
    
    private let dataProvider = LanguageDataProvider()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "profile.editProfile.languageTitle".localized
        label.font = .futuraMedium(22)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let textField = UITextField.createNormalTextField("profile.editProfile.language.placeholder",
                                                              font: .futuraBook(14),
                                                              cornerRadius: 25)
    
    private let bottomBackground = UIImageView(image: #imageLiteral(resourceName: "lower_background"))
    
    private let nextButton = UIButton.createCommonBottomButton("common.next")
    
    init(_ type: EditInfoControllerType, language: [String]) {
        super.init(nibName: nil, bundle: nil)
        let predefined = dataProvider.contentList.map { $0.capitalized }
        for lang in language {
            if !predefined.contains(lang.capitalized) {
                dataProvider.contentList.append(lang.capitalized)
            }
        }
        dataProvider.selectedLanguages.accept(language)
        tableView.reloadData()
        viewModel.editType.accept(type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SelectionLanguageTableViewCell.nib,
                           forCellReuseIdentifier: SelectionLanguageTableViewCell.identifier)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.dataSource = dataProvider
        tableView.delegate = dataProvider
        return tableView
    }()
    
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
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(viewModel.titleLabelTopSpace.value)
            make.left.right.equalToSuperview().inset(50)
        }
        
        view.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(40)
            make.left.right.equalToSuperview().inset(32)
            make.height.equalTo(50)
        }
        
        let isOnboarding = viewModel.editType.value == .onboarding
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(30)
            make.left.right.equalTo(textField)
            make.bottom.equalToSuperview().inset(isOnboarding ? 135 + 5/*offset*/ : 1)
        }
        
        view.addSubview(bottomBackground)
        bottomBackground.isHidden = !isOnboarding
        bottomBackground.snp.makeConstraints { make in
            make.height.equalTo(isOnboarding ? 135 : 0) //including offset 2
            make.left.equalToSuperview().offset(-2)
            make.right.bottom.equalToSuperview().offset(2)
        }
        
        view.addSubview(nextButton)
        nextButton.isHidden = !isOnboarding
        nextButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.bottomBackground)
            make.left.right.equalToSuperview().inset(33)
            make.height.equalTo(isOnboarding ? 50 : 0)
        }
        
    }
    
    override func bind() {
        super.bind()
        
        viewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)
        
        viewModel.presentAlert.subscribe( onNext: { [weak self] args in
            let (title, message) = args
            self?.presentAlert(title: title, message: message)
        }).disposed(by: disposeBag)
        
        dataProvider.selectedLanguages.bind(to: viewModel.langauge).disposed(by: disposeBag)
        
        saveButton.rx.tap.bind { [weak self] in
            self?.viewModel.sendRequest(.language)
        }.disposed(by: disposeBag)
        
        textField.rx.controlEvent([.editingDidEnd])
            .asObservable()
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                if !self.textField.text!.replacingOccurrences(of: " ", with: "").isEmpty {
                    self.dataProvider.contentList.insert(String(self.textField.text!), at: 0)
                    var selected = self.dataProvider.selectedLanguages.value
                    selected.append(self.textField.text!)
                    self.dataProvider.selectedLanguages.accept(selected)
                    self.tableView.reloadData()
                }
                
                self.textField.layer.borderColor = UIColor.silver.cgColor
                self.textField.text = ""
            })
            .disposed(by: disposeBag)
        
        viewModel.editType.subscribe(onNext: { [weak self] type in
            guard let self = self else { return }
            self.title = type == .edit ? "profile.editProfile.title".localized : ""
        }).disposed(by: disposeBag)
        
        viewModel.langauge.subscribe(onNext: { [weak self] arg in
            guard let arg = arg else { return }
            let valid = arg.count > 0
            self?.nextButton.isUserInteractionEnabled = valid
            self?.nextButton.alpha = valid ? 1 : 0.6
        }).disposed(by: disposeBag)
        
        nextButton.rx.tap.bind { [weak self] in
            self?.viewModel.sendRequest(.language)
        }.disposed(by: disposeBag)
        
        viewModel.success.subscribe(onNext: { [weak self] args in
            if self?.viewModel.editType.value != .onboarding {
                self?.navigationController?.popViewController(animated: true)
            }
        }).disposed(by: disposeBag)
        
    }

}

