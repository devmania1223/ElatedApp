//
//  EditProfileHeightViewController.swift
//  Elated
//
//  Created by Marlon on 4/7/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class EditProfileHeightViewController: BaseViewController {

    let viewModel = EditProfileCommonViewModel()
    
    private let saveButton = UIBarButtonItem.creatTextButton("common.save".localized)
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "profile.editProfile.heightTitle".localized
        label.font = .futuraMedium(22)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
        
    private let heightImageView = UIImageView(image: #imageLiteral(resourceName: "icon-male"))
    
    private lazy var bubbleView: UIView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "human_height_message_icon").withRenderingMode(.alwaysTemplate))
        imageView.tintColor = .elatedPrimaryPurple
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        
        let view = UIView()
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(heightlabel)
        heightlabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(5)
            make.bottom.equalToSuperview().inset(10)
        }
        
        return view
    }()
    
    private let heightlabel: UILabel = {
        let label = UILabel()
        label.tintColor = .elatedPrimaryPurple
        label.font = .futuraBook(12)
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private let segment: UISegmentedControl = {
        let segment = UISegmentedControl()
        let normalTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.elatedPrimaryPurple]
        let activeAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segment.insertSegment(withTitle: HeightType.feet.getName(), at: 0, animated: true)
        segment.insertSegment(withTitle: HeightType.cm.getName(), at: 1, animated: true)
        segment.setTitleTextAttributes(normalTextAttributes, for: .normal)
        segment.setTitleTextAttributes(activeAttributes, for: .selected)
        segment.selectedSegmentTintColor = .elatedPrimaryPurple
        segment.backgroundColor = .alabasterSolid
        segment.selectedSegmentIndex = 0
        return segment
    }()
    
    private let slider: UISlider = {
        let slider = UISlider()
        slider.maximumValue = 120 //inches
        slider.minimumValue = 30
        slider.value = 60
        slider.tintColor = .elatedPrimaryPurple
        return slider
    }()
    
    private let bottomBackground = UIImageView(image: #imageLiteral(resourceName: "lower_background"))
    
    private let nextButton = UIButton.createCommonBottomButton("common.next")
    
    init(_ type: EditInfoControllerType, heightIn: Double) {
        super.init(nibName: nil, bundle: nil)
        slider.value = Float(heightIn == 0 ? 60 : heightIn)
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
            make.top.equalTo(viewModel.titleLabelTopSpace.value).priorityRequired()
            make.left.right.equalToSuperview().inset(50)
            make.height.equalTo(35).priorityRequired()
        }
        
        view.addSubview(heightImageView)
        heightImageView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(label.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.height.equalTo(70).priorityLow()
        }
        
        view.addSubview(segment)
        segment.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(heightImageView.snp.bottom).offset(18).priorityRequired()
            make.height.equalTo(20)
            make.width.equalTo(120)
        }
        
        view.addSubview(slider)
        slider.snp.makeConstraints { make in
            make.top.equalTo(segment.snp.bottom).offset(18).priorityRequired()
            make.left.right.equalToSuperview().inset(32)
            if Util.heigherThanIphone6 {
                make.bottom.equalToSuperview().inset(viewModel.editType.value != .onboarding ? 132 : 218).priorityRequired()
            } else {
                make.bottom.equalToSuperview().inset(viewModel.editType.value != .onboarding ? 32 : 138).priorityRequired()
            }
        }
        
        view.addSubview(bubbleView)
        bubbleView.snp.makeConstraints { make in
            make.bottom.equalTo(heightImageView.snp.top).offset(50)
            make.width.equalTo(62)
            make.height.equalTo(51)
            make.left.equalTo(heightImageView.snp.right).offset(8)
        }
        
        view.addSubview(bottomBackground)
        self.bottomBackground.isHidden = viewModel.editType.value != .onboarding
        self.bottomBackground.snp.makeConstraints { make in
            make.height.equalTo(135) //including offset 2
            make.left.equalToSuperview().offset(-2)
            make.right.bottom.equalToSuperview().offset(2)
        }
        
        view.addSubview(nextButton)
        self.nextButton.isHidden = viewModel.editType.value != .onboarding
        self.nextButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.bottomBackground)
            make.left.right.equalToSuperview().inset(33)
            make.height.equalTo(50)
        }
        
    }
    
    override func bind() {
        super.bind()
        
        viewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)
        
        viewModel.presentAlert.subscribe( onNext: { [weak self] args in
            let (title, message) = args
            self?.presentAlert(title: title, message: message)
        }).disposed(by: disposeBag)
            
        slider.rx.value.map {
            return Double($0)
        }.bind(to: viewModel.height).disposed(by: disposeBag)
        
        segment.rx.controlEvent([.valueChanged]).subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.viewModel.heightType.accept(self.segment.selectedSegmentIndex == 0 ? .feet : .cm)
            self.calculatedHeight()
        }).disposed(by: disposeBag)
        
        viewModel.height.subscribe( onNext: { [weak self] height in
            self?.calculatedHeight()
        }).disposed(by: disposeBag)

        saveButton.rx.tap.bind { [weak self] in
            self?.viewModel.sendRequest(.height)
        }.disposed(by: disposeBag)
        
        viewModel.editType.subscribe(onNext: { [weak self] type in
            guard let self = self else { return }
            self.title = type == .edit ? "profile.editProfile.title".localized : ""
        }).disposed(by: disposeBag)
        
        viewModel.height.subscribe(onNext: { [weak self] arg in
            guard let arg = arg else { return }
            let valid = arg > 0
            self?.nextButton.isUserInteractionEnabled = valid
            self?.nextButton.alpha = valid ? 1 : 0.6
        }).disposed(by: disposeBag)
        
        nextButton.rx.tap.bind { [weak self] in
            self?.viewModel.sendRequest(.height)
        }.disposed(by: disposeBag)
        
        viewModel.success.subscribe(onNext: { [weak self] args in
            if self?.viewModel.editType.value != .onboarding {
                self?.navigationController?.popViewController(animated: true)
            }
        }).disposed(by: disposeBag)
        
    }
    
    func calculatedHeight() {
        let isFt = segment.selectedSegmentIndex == 0
        guard let height = viewModel.height.value else { return }
        
        if isFt {
            let feet = height / 12
            let inches = height.truncatingRemainder(dividingBy: 12)
            heightlabel.text = "\(Int(feet))' \(Int(inches))\""
        } else {
            let cm = height * 2.54
            heightlabel.text = String(format: "%.2f", cm)
            print(cm)
        }
            
        if Util.heigherThanIphone6  || viewModel.editType.value != .onboarding {
            heightImageView.snp.updateConstraints { make in
                make.height.equalTo(height * 2.5).priorityLow()
            }
        }
        
        view.layoutIfNeeded()
    }

}
