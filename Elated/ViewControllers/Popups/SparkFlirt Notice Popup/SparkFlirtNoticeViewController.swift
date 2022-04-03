//
//  SparkFlirtNoticeViewController.swift
//  Elated
//
//  Created by Marlon on 5/15/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxCocoa

class SparkFlirtNoticeViewController: BaseViewController {
    
    //MARK: - Properties
    
    internal var viewModel = SparkFlirtNoticeViewModel()
    
    internal let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .eerieBlack
        label.font = .futuraMedium(22)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    internal let successImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "sf-4")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    internal let subLabel: UILabel = {
        let label = UILabel()
        label.textColor = .sonicSilver
        label.font = .futuraBook(14)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    internal let balanceImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "icons-sparkflirt-active").withTintColor(.napiesYellow)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    internal let balanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .eerieBlack
        label.font = .futuraMedium(16)
        label.numberOfLines = 0
        return label
    }()
    
    internal let continueButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = .futuraBook(14)
        button.layer.cornerRadius = 25
        button.backgroundColor = .elatedPrimaryPurple
        button.setTitleColor(.white, for: .normal)
        button.layer.applySketchShadow(color: .black,
                                       alpha: 0.15,
                                       x: 0,
                                       y: 3,
                                       blur: 18,
                                       spread: 0)
        return button
    }()
    
    internal let footerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "Assets_Graphics_Bottom_Curve")
        return imageView
    }()
    
    init(title: String, subTitle: String, balance: String, button: String) {
        super.init(nibName: nil, bundle: nil)
        viewModel.titleText.accept(title)
        viewModel.messageText.accept(subTitle)
        viewModel.balanceText.accept(balance)
        viewModel.buttonText.accept(button)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //viewModel.setSettingsAccountType(type: settingsAccountType)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(65)
            make.left.right.equalToSuperview().inset(40)
        }
        
        view.addSubview(successImageView)
        successImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(250)
        }
        
        view.addSubview(subLabel)
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(successImageView.snp.bottom).offset(28)
            make.left.right.equalToSuperview().inset(43)
        }
        
        view.addSubview(balanceLabel)
        balanceLabel.snp.makeConstraints { make in
            make.top.equalTo(subLabel.snp.bottom).offset(43)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(balanceImageView)
        balanceImageView.snp.makeConstraints { make in
            make.top.bottom.equalTo(balanceLabel)
            make.right.equalTo(balanceLabel.snp.left).offset(-8)
            make.width.height.equalTo(16)
        }
        
        view.addSubview(continueButton)
        continueButton.snp.makeConstraints { make in
            make.top.equalTo(balanceImageView.snp.bottom).offset(48)
            make.centerX.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(50)
        }
                
        view.addSubview(footerImageView)
        footerImageView.snp.makeConstraints { make in
            make.bottom.equalTo(1)
            make.left.equalTo(-2)
            make.right.equalTo(1)
            make.height.width.equalTo(156)
        }
    }
    
    override func bind() {
        super.bind()
        
        bindView()
        bindEvents()
    }
    
    //MARK: - Custom
    
    func bindView() {
        viewModel.titleText.bind(to: titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.messageText.bind(to: subLabel.rx.text).disposed(by: disposeBag)
        viewModel.buttonText.bind(to: continueButton.rx.title(for: .normal)).disposed(by: disposeBag)
        viewModel.balanceText.bind(to: balanceLabel.rx.text).disposed(by: disposeBag)
    }
    
    func bindEvents() {
        continueButton.rx.tap.bind { [weak self] in
            self?.viewModel.success.accept(())
        }.disposed(by: disposeBag)
    }
    
}
