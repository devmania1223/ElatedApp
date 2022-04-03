//
//  SettingsLocationViewController.swift
//  Elated
//
//  Created by Yiel Miranda on 3/24/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import RxCocoa

class SettingsLocationViewController: ScrollViewController {
    
    //MARK: - Properties
    internal let viewModel = SettingsLocationViewModel()
    
    internal let saveButton = UIBarButtonItem.creatTextButton("common.save".localized)
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .eerieBlack
        label.font = .futuraMedium(22)
        label.text = "settings.location.title".localized
        label.textAlignment = .center
        return label
    }()

    internal lazy var nearMeButton = createButton(title: "settings.location.nearme".localized,
                                                  tag: 0)
    
    internal lazy var otherButton = createButton(title: "settings.location.other".localized,
                                                 tag: 1)
    
    internal lazy var addressTextfield = createTextfield(placeholder: "settings.location.address".localized)
    
    internal lazy var zipCodeTextfield = createTextfield(placeholder: "settings.location.zipcode".localized)
    
    internal let dismissPlacesButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "img_delete"), for: .normal)
        return button
    }()
    
    internal let tableView = PlacesTableView()
    
    internal let bottomBackground = UIImageView(image: #imageLiteral(resourceName: "lower_background"))
    
    internal let nextButton = UIButton.createCommonBottomButton("common.next")
    
    init(type: EditInfoControllerType,
         location: MatchPrefLocationType,
         address: String,
         zipCode: String) {
        
        super.init(nibName: nil, bundle: nil)
        
        viewModel.address.accept(address)
        viewModel.zipCode.accept(zipCode)
        
        viewModel.selectedLocation.accept(location)
        viewModel.editType.accept(type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        view.backgroundColor = .white

        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(viewModel.titleLabelTopSpace.value)
            make.left.right.equalToSuperview().inset(50)
        }
        
        contentView.addSubview(nearMeButton)
        nearMeButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(104)
            make.height.equalTo(40)
            make.left.equalToSuperview().inset(34)
            make.right.equalTo(view.snp.centerX).offset(-10)
        }
        
        contentView.addSubview(otherButton)
        otherButton.snp.makeConstraints { make in
            make.top.equalTo(nearMeButton)
            make.height.equalTo(nearMeButton)
            make.right.equalToSuperview().inset(34)
            make.left.equalTo(nearMeButton.snp.right).offset(20)
        }
        
        contentView.addSubview(addressTextfield)
        addressTextfield.snp.makeConstraints { make in
            make.top.equalTo(nearMeButton.snp.bottom).offset(19)
            make.height.equalTo(52)
            make.left.right.equalToSuperview().inset(32)
        }
        
        contentView.addSubview(zipCodeTextfield)
        zipCodeTextfield.snp.makeConstraints { make in
            make.top.equalTo(addressTextfield.snp.bottom).offset(13)
            make.height.equalTo(addressTextfield)
            make.left.right.equalTo(addressTextfield)
        }
        
        contentView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(addressTextfield.snp.bottom)
            make.height.greaterThanOrEqualTo(80)
            make.left.right.equalTo(addressTextfield)
            make.bottom.equalToSuperview()
        }
        
        contentView.addSubview(dismissPlacesButton)
        dismissPlacesButton.isHidden = true
        dismissPlacesButton.snp.makeConstraints { make in
            make.top.equalTo(tableView).offset(12)
            make.height.width.equalTo(25)
            make.right.equalTo(tableView.snp.left).inset(10)
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
        
        bindView()
        bindEvents()
    }

    //MARK: - Custom
    
    private func createButton(title: String, tag: Int) -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = .white
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.lightGray.cgColor
        
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .futuraBook(14)
        button.setTitleColor(.elatedPrimaryPurple, for: .normal)
        button.layer.cornerRadius = 20
        
        button.tag = tag
        
        return button
    }
    
    private func createTextfield(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.font = .futuraBook(14)
        textField.textColor = .elatedPrimaryPurple
        textField.layer.cornerRadius = 26
        textField.layer.borderColor = UIColor.elatedPrimaryPurple.cgColor
        textField.layer.borderWidth = 1
        textField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                         attributes: [NSAttributedString.Key.foregroundColor:
                                                                      UIColor.silver])
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 50))
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 50))
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        
        return textField
    }

    func setButtonSelection(button: UIButton, selected: Bool) {
        if selected {
            button.backgroundColor = .elatedPrimaryPurple
            button.layer.borderWidth = 0
            button.setTitleColor(.white, for: .normal)
        } else {
            button.backgroundColor = .white
            button.layer.borderWidth = 1.0
            button.layer.borderColor = UIColor.lightGray.cgColor
            button.setTitleColor(.elatedPrimaryPurple, for: .normal)
        }
    }
    
    @objc func triggerSearch() {
        viewModel.getPlaces(keyword: addressTextfield.text ?? "")
    }
    
}
