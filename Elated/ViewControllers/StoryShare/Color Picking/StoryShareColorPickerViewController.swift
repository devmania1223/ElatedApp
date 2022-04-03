//
//  StoryShareColorPickerViewController.swift
//  Elated
//
//  Created by Rey Felipe on 6/30/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class StoryShareColorPickerViewController: BaseViewController {
    
    private let viewModel = StoryShareColorPickerViewModel()
    
    private let ssBackground = UIImageView(image: #imageLiteral(resourceName: "background-storyshare"))

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .chestnut
        label.font = .courierPrimeRegular(22)
        label.text = "storyshare.title".localized
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let colorPickerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerRadius = 15.0
        view.addShadowLayer()
        return view
    }()
    
    private let redColorButton = SSColorRadioButton(color: .red)
    private let blueColorButton = SSColorRadioButton(color: .blue)
    private let orangeColorButton = SSColorRadioButton(color: .orange)
    private let mustardColorButton = SSColorRadioButton(color: .mustard)
    private let pinkColorButton = SSColorRadioButton(color: .pink)
    private let greenColorButton = SSColorRadioButton(color: .green)
    private let violetColorButton = SSColorRadioButton(color: .violet)
    private let grayColorButton = SSColorRadioButton(color: .gray)
    
    private let pickColorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .futuraMedium(16)
        label.text = "storyshare.pickyourcolor".localized
        label.textAlignment = .center
        return label
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton.createCommonBottomButton("common.continue")
        button.backgroundColor = .umber
        return button
    }()
    
    var radioButtonController: SSRadioButtonsController?
    
    init(_ detail: StoryShareGameDetail) {
        super.init(nibName: nil, bundle: nil)
        viewModel.detail.accept(detail)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.hideNavBar()
        radioButtonController = SSRadioButtonsController(buttons: redColorButton,
                                                         blueColorButton,
                                                         orangeColorButton,
                                                         mustardColorButton,
                                                         pinkColorButton,
                                                         greenColorButton,
                                                         violetColorButton,
                                                         grayColorButton)
        radioButtonController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hideNavBar()
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        view.backgroundColor = .white
        
        view.addSubview(ssBackground)
        ssBackground.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }

        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(colorPickerView)
        colorPickerView.snp.makeConstraints { make in
            make.height.equalTo(300)
            make.left.right.equalToSuperview().inset(30)
            make.centerY.equalToSuperview()
        }
        
        colorPickerView.addSubview(pickColorLabel)
        pickColorLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(10)
            make.top.equalToSuperview().offset(40)
        }
        
        colorPickerView.addSubview(continueButton)
        continueButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.left.right.equalToSuperview().inset(25)
            make.bottom.equalToSuperview().offset(-30)
        }
        
        let colorHStack1 = UIStackView(arrangedSubviews: [redColorButton, blueColorButton, orangeColorButton, mustardColorButton])
        colorHStack1.axis = .horizontal
        colorHStack1.spacing = 20
        colorHStack1.distribution = .fillEqually
        colorHStack1.alignment = .center
        
        let colorHStack2 = UIStackView(arrangedSubviews: [pinkColorButton, greenColorButton, violetColorButton, grayColorButton])
        colorHStack2.axis = .horizontal
        colorHStack2.spacing = 20
        colorHStack2.distribution = .fillEqually
        colorHStack2.alignment = .center
        
        let colorVStack = UIStackView(arrangedSubviews: [colorHStack1, colorHStack2])
        colorVStack.axis = .vertical
        colorVStack.spacing = 20
        colorVStack.distribution = .fillEqually
        colorVStack.alignment = .center
        
        colorPickerView.addSubview(colorVStack)
        colorVStack.snp.makeConstraints { make in
            make.top.equalTo(pickColorLabel.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(50)
        }
        
    }
    
    override func bind() {
        super.bind()
        
        viewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)

        viewModel.presentAlert.subscribe( onNext: { [weak self] args in
            let (title, message) = args
            self?.presentAlert(title: title, message: message)
        }).disposed(by: disposeBag)
        
        viewModel.colorSelected.map { $0 != nil }.bind(to: continueButton.rx.isUserInteractionEnabled).disposed(by: disposeBag)
        viewModel.colorSelected.map { $0 != nil ? 1 : 0.5 }.bind(to: continueButton.rx.alpha).disposed(by: disposeBag)

        viewModel.successSettingColor.subscribe(onNext: { [weak self] in
            if let detail = self?.viewModel.detail.value,
               let color = self?.viewModel.colorSelected.value {
                var new = detail
                if MemCached.shared.isSelf(id: detail.inviter?.id) {
                    new.inviterTextColor = color
                } else {
                    new.inviteeTextColor = color
                }
                self?.navigationController?.show(StoryShareGameViewController(new), sender: nil)
            }
        }).disposed(by: disposeBag)
        
        //solve multiple trigger bug on continueButton.rx.tap
        continueButton.addTarget(self, action: #selector(didContinue), for: .touchUpInside)
        
    }
    
    @objc private func didContinue() {
        viewModel.setColor()
    }
    
}

// MARK: SSRadioButtonControllerDelegate
extension StoryShareColorPickerViewController: SSRadioButtonControllerDelegate {
    func didSelectButton(selectedButton: UIButton?) {
        guard let colorButton = selectedButton as? SSColorRadioButton else { return }
        NSLog("Selected Color for StoryShare: \(String(describing: selectedButton))" )
        //StoryShareColor wont be nil
        if let color = StoryShareColor(rawValue: colorButton.circleColor) {
            pickColorLabel.textColor = color.getColor()
            viewModel.colorSelected.accept(color)
        }
    }
}
