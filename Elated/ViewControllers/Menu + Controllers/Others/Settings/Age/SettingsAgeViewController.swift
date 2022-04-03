//
//  SettingsAgeViewController.swift
//  Elated
//
//  Created by Yiel Miranda on 3/24/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import WARangeSlider
import RxCocoa

class SettingsAgeViewController: BaseViewController {
    
    let viewModel = SettingsCommonViewModel()
    
    internal let saveButton = UIBarButtonItem.creatTextButton("common.save".localized)
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .eerieBlack
        label.font = .futuraMedium(22)
        label.text = "settings.age.title".localized
        return label
    }()
    
    let minAgeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .elatedPrimaryPurple
        label.textAlignment = .center
        label.font = .futuraMedium(20)
        label.layer.cornerRadius = 32
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.grayLabelBorderColor.cgColor
        return label
    }()
    
    let maxAgeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .elatedPrimaryPurple
        label.textAlignment = .center
        label.font = .futuraMedium(20)
        label.layer.cornerRadius = 32
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.grayLabelBorderColor.cgColor
        return label
    }()
    
    private let toLabel: UILabel = {
        let label = UILabel()
        label.textColor = .jet
        label.textAlignment = .center
        label.font = .futuraMedium(16)
        label.text = "settings.age.to".localized
        return label
    }()
    
    let rangeSlider: RangeSlider = {
        let rangeSlider = RangeSlider(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
        rangeSlider.maximumValue = 65
        rangeSlider.minimumValue = 18
        rangeSlider.lowerValue = 20
        rangeSlider.upperValue = 40
        rangeSlider.trackHighlightTintColor = .elatedPrimaryPurple
        
        return rangeSlider
    }()
    
    internal let bottomBackground = UIImageView(image: #imageLiteral(resourceName: "lower_background"))
    
    internal let nextButton = UIButton.createCommonBottomButton("common.next")
    
    //MARK: - View Life Cycle
    
    init(_ type: EditInfoControllerType,
         minAge: Int = 18,
         maxAge: Int = 32) {
        super.init(nibName: nil, bundle: nil)
        
        viewModel.editType.accept(type)
        viewModel.minAge.accept(minAge)
        viewModel.maxAge.accept(maxAge)
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
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(viewModel.editType.value == .onboarding ? 84 : 40)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(rangeSlider)
        rangeSlider.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
            make.left.right.equalToSuperview().inset(28)
        }
        
        view.addSubview(toLabel)
        toLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(rangeSlider.snp.top).offset(-23)
            make.height.equalTo(64)
            make.width.equalTo(72)
        }
        
        view.addSubview(minAgeLabel)
        minAgeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(toLabel)
            make.height.equalTo(toLabel)
            make.width.equalTo(64)
            make.right.equalTo(toLabel.snp.left)
        }
        
        view.addSubview(maxAgeLabel)
        maxAgeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(minAgeLabel)
            make.height.equalTo(minAgeLabel)
            make.width.equalTo(minAgeLabel)
            make.left.equalTo(toLabel.snp.right)
        }
    }
    
    override func bind() {
        super.bind()
        
        bindView()
        bindEvents()
    }
    
    //MARK: - Custom
    
    @objc func rangeSliderValueChanged(sender: RangeSlider) {
        viewModel.minAge.accept(Int(sender.lowerValue))
        viewModel.maxAge.accept(Int(sender.upperValue))
    }
}
