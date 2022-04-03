//
//  EditProfileRangeViewController.swift
//  Elated
//
//  Created by Marlon on 3/30/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class EditProfileRangeViewController: BaseViewController {

    let viewModel = EditProfileCommonViewModel()
    private let saveButton = UIBarButtonItem.creatTextButton("common.save".localized)
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "profile.editProfile.rangeTitle".localized
        label.font = .futuraMedium(22)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
        
    private let distanceButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.elatedPrimaryPurple, for: .normal)
        button.titleLabel?.font = .futuraMedium(20)
        button.layer.cornerRadius = 34
        button.layer.borderColor = UIColor.silver.cgColor
        button.layer.borderWidth = 0.25
        return button
    }()
    
    private let segment: UISegmentedControl = {
        let segment = UISegmentedControl()
        let normalTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.elatedPrimaryPurple]
        let activeAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segment.insertSegment(withTitle: "distance.miles.short".localized, at: 0, animated: true)
        segment.insertSegment(withTitle: "distance.kilometers.short".localized, at: 1, animated: true)
        segment.setTitleTextAttributes(normalTextAttributes, for: .normal)
        segment.setTitleTextAttributes(activeAttributes, for: .selected)
        segment.selectedSegmentTintColor = .elatedPrimaryPurple
        segment.backgroundColor = .alabasterSolid
        segment.selectedSegmentIndex = 1
        return segment
    }()
    
    private let slider: UISlider = {
        let slider = UISlider()
        slider.maximumValue = 500
        slider.minimumValue = 1
        slider.tintColor = .elatedPrimaryPurple
        return slider
    }()
    
    private let bottomBackground = UIImageView(image: #imageLiteral(resourceName: "lower_background"))
    
    private let nextButton = UIButton.createCommonBottomButton("common.next")
    
    init(_ type: EditInfoControllerType,
         distanceType: DistanceType,
         range: Int) {
        
        super.init(nibName: nil, bundle: nil)
        
        slider.value = Float(range)
        segment.selectedSegmentIndex = distanceType == .miles ? 0 : 1
        self.title = title?.localized
        
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
        
        view.addSubview(distanceButton)
        distanceButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(68)
        }
        
        view.addSubview(segment)
        segment.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(distanceButton.snp.bottom).offset(18)
            make.height.equalTo(20)
            make.width.equalTo(120)
        }
        
        view.addSubview(slider)
        slider.snp.makeConstraints { make in
            make.top.equalTo(segment.snp.bottom).offset(18)
            make.centerY.equalToSuperview().offset(30)
            make.left.right.equalToSuperview().inset(32)
        }
    }
    
    override func bind() {
        super.bind()
        
        viewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)
        
        viewModel.presentAlert.subscribe( onNext: { [weak self] args in
            let (title, message) = args
            self?.presentAlert(title: title, message: message)
        }).disposed(by: disposeBag)
            
        slider.rx.value.map { Int($0) }.bind(to: viewModel.distance).disposed(by: disposeBag)
        slider.rx.value.map { String(Int($0)) }.bind(to: distanceButton.rx.title(for: .normal)).disposed(by: disposeBag)

        segment.rx.controlEvent([.valueChanged]).subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            let unit = self.segment.selectedSegmentIndex == 0 ? DistanceType.miles : DistanceType.kilometeres
            self.viewModel.distanceType.accept(unit)
        }).disposed(by: disposeBag)
        
        saveButton.rx.tap.bind { [weak self] in
            self?.viewModel.sendRequest(.distance)
        }.disposed(by: disposeBag)
        
        viewModel.editType.subscribe(onNext: { [weak self] type in
            guard let self = self else { return }
            if type == .onboarding {
                self.title = ""
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
            } else if type == .edit {
                self.title = "profile.editProfile.title".localized
            } else {
                self.title = "settings.edit.title".localized
            }
        }).disposed(by: disposeBag)
        
        viewModel.distance.subscribe(onNext: { [weak self] arg in
            guard let arg = arg else { return }
            let valid = arg != 0
            self?.nextButton.isUserInteractionEnabled = valid
            self?.nextButton.alpha = valid ? 1 : 0.6
        }).disposed(by: disposeBag)
        
        nextButton.rx.tap.bind { [weak self] in
            self?.viewModel.sendRequest(.distance)
        }.disposed(by: disposeBag)
        
        viewModel.success.subscribe(onNext: { [weak self] args in
            if self?.viewModel.editType.value != .onboarding {
                self?.navigationController?.popViewController(animated: true)
            }
        }).disposed(by: disposeBag)
        
    }

}
