//
//  EdirProfileLocationViewController.swift
//  Elated
//
//  Created by Marlon on 3/26/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class EditProfileLocationViewController: BaseViewController {

    let viewModel = EditProfileCommonViewModel()
    private let saveButton = UIBarButtonItem.creatTextButton("common.save".localized)
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "profile.editProfile.locationTitle".localized
        label.font = .futuraMedium(22)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let textField = UITextField.createNormalTextField("profile.editProfile.location.placeholder",
                                                              font: .futuraBook(14),
                                                              cornerRadius: 25)
    
    internal let tableView = PlacesTableView()
    
    internal let dismissPlacesButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "img_delete"), for: .normal)
        return button
    }()
    
    private let bottomBackground = UIImageView(image: #imageLiteral(resourceName: "lower_background"))
    
    private let nextButton = UIButton.createCommonBottomButton("common.next")
    
    init(_ type: EditInfoControllerType, location: String) {
        super.init(nibName: nil, bundle: nil)
        viewModel.address.accept(location)
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
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(viewModel.titleLabelTopSpace.value)
            make.left.right.equalToSuperview().inset(50)
        }
        
        view.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(50)
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
        
        view.addSubview(dismissPlacesButton)
        dismissPlacesButton.isHidden = true
        dismissPlacesButton.snp.makeConstraints { make in
            make.top.equalTo(tableView).offset(12)
            make.height.width.equalTo(25)
            make.right.equalTo(tableView.snp.left).inset(10)
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
        
        viewModel.places.subscribe(onNext: { [weak self] places in
            self?.tableView.data.accept(places)
            self?.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        dismissPlacesButton.rx.tap.map { true }.bind(to: tableView.rx.isHidden).disposed(by: disposeBag)
        dismissPlacesButton.rx.tap.map { true }.bind(to: dismissPlacesButton.rx.isHidden).disposed(by: disposeBag)
        dismissPlacesButton.rx.tap.bind { [weak self] in self?.textField.resignFirstResponder() }.disposed(by: disposeBag)
        
        viewModel.address.bind(to: textField.rx.text).disposed(by: disposeBag)
        
        textField.rx.controlEvent([.editingDidBegin, .editingChanged])
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.tableView.isHidden = false
                self.dismissPlacesButton.isHidden = false
                NSObject.cancelPreviousPerformRequests(withTarget: self,
                                                       selector: #selector(self.triggerSearch),
                                                       object: self.textField)
                self.perform(#selector(self.triggerSearch),
                             with: self.textField,
                             afterDelay: 0.6)
        }).disposed(by: disposeBag)
                
        tableView.didSelect.subscribe(onNext: { [weak self] index in
            guard let self = self else { return }
            let place = self.viewModel.places.value[index]
            self.viewModel.selectedPlace.accept(place)
            self.tableView.isHidden = true
            self.dismissPlacesButton.isHidden = true
        }).disposed(by: disposeBag)
        
        saveButton.rx.tap.bind { [weak self] in
            self?.viewModel.sendRequest(.location)
        }.disposed(by: disposeBag)
        
        viewModel.editType.subscribe(onNext: { [weak self] type in
            guard let self = self else { return }
            self.title = type == .edit ? "profile.editProfile.title".localized : ""
        }).disposed(by: disposeBag)
        
        viewModel.selectedPlace.subscribe(onNext: { [weak self] arg in
            let valid = arg != nil
            self?.nextButton.isUserInteractionEnabled = valid
            self?.nextButton.alpha = valid ? 1 : 0.6
        }).disposed(by: disposeBag)
        
        nextButton.rx.tap.bind { [weak self] in
            self?.viewModel.sendRequest(.location)
        }.disposed(by: disposeBag)
        
        viewModel.success.subscribe(onNext: { [weak self] args in
            if self?.viewModel.editType.value != .onboarding {
                self?.navigationController?.popViewController(animated: true)
            }
        }).disposed(by: disposeBag)
        
    }
    
    @objc func triggerSearch() {
        viewModel.getPlaces(keyword: textField.text ?? "")
    }

}
