//
//  SparkFlirtAddCreditSuccessViewController.swift
//  Elated
//
//  Created by Rey Felipe on 9/28/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation

import UIKit
import Lottie

class SparkFlirtAddCreditSuccessViewController: ScrollViewController {
    
    enum CreditType {
        case viaInAppPurchase
        case viaQRCode
    }
    
    let viewModel = SparkFlirtSettingsBalanceViewModel()
    
    private let bottomBackground = UIImageView(image: #imageLiteral(resourceName: "lower_background"))
    private let continueButton = UIButton.createCommonBottomButton("common.continue")

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .eerieBlack
        label.font = .futuraMedium(22)
        label.text = "sparkFlirt.title.credit.added".localized
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grayColor
        label.font = .futuraMedium(14)
        label.text = "sparkFlirt.credit.added".localizedFormat("2")
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let balanceStack: UIStackView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "buttons-sparkflirtyellow-circle"))
        image.contentMode = .scaleAspectFit
        let stackView = UIStackView(arrangedSubviews: [image])
        image.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }
        stackView.spacing = 5
        stackView.alignment = .center
        return stackView
    }()
    
    private let balanceLabel: UILabel = {
        let label = UILabel()
        label.text = "sparkFlirt.notice.balance.1".localizedFormat("...")
        label.textColor = .eerieBlack
        label.font = .futuraMedium(16)
        return label
    }()
    
    private let animationView: AnimationView = {
        let animation = AnimationView(name: "spark-logo")
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .loop
        animation.backgroundBehavior = .pauseAndRestore
        animation.play()
        return animation
    }()
    
    private var creditType: CreditType = .viaInAppPurchase
    private var credit: Int = 0
    private var isOnboarding: Bool = false
    
    var dismissCompleteHandler: (() -> Void)?
    
    init(_ creditType: CreditType, credit: Int, onboarding: Bool = false) {
        super.init(nibName: nil, bundle: nil)
        self.creditType = creditType
        self.credit = credit
        self.isOnboarding = onboarding
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getSparkFlirtAvailableCredit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        view.backgroundColor = .white
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(40)
        }
        
        contentView.addSubview(animationView)
        animationView.snp.makeConstraints { make in
            make.height.width.equalTo(175)
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
        }
        
        contentView.addSubview(bodyLabel)
        bodyLabel.text = "sparkFlirt.credit.added".localizedFormat("\(credit)")
        bodyLabel.snp.makeConstraints { make in
            make.top.equalTo(animationView.snp.bottom)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(40)
        }
        
        balanceStack.addArrangedSubview(balanceLabel)
        contentView.addSubview(balanceStack)
        balanceStack.snp.makeConstraints { make in
            make.top.equalTo(bodyLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        contentView.addSubview(continueButton)
        continueButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(200)
            make.top.equalTo(balanceStack.snp.bottom).offset(40)
            make.bottom.equalToSuperview().offset(-25)
        }
        
        if creditType == .viaQRCode && !isOnboarding {
            continueButton.setTitle("sparkFlirt.button.goto.sparkflirt".localized, for: .normal)
        }
        
        view.addSubview(bottomBackground)
        bottomBackground.snp.makeConstraints { make in
            make.height.equalTo(135)
            make.left.equalToSuperview().offset(-2)
            make.right.equalToSuperview().offset(2)
            make.bottom.equalToSuperview().offset(Util.heigherThanIphone6 ? 2 : 100)
        }
        view.bringSubviewToFront(scrollView)
        
        navigationController?.hideNavBar()
        centerContentViewIfNeeded(offset: Util.heigherThanIphone6 ? 133 : 35)
    }
    
    override func bind() {
        super.bind()
        
        viewModel.availableCredits.bind { [weak self] credits in
            guard let self = self else { return }
            self.balanceLabel.text = "sparkFlirt.notice.balance.1".localizedFormat("\(credits)")
        }
        
        continueButton.rx.tap.bind { [weak self] in
            self?.dismiss(animated: true, completion: nil)
            self?.dismissCompleteHandler?()
        }.disposed(by: disposeBag)
        
    }
}
