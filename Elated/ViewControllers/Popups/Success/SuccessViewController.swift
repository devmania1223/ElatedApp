//
//  SuccessViewController.swift
//  Elated
//
//  Created by Yiel Miranda on 3/26/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import RxCocoa
import Lottie

class SuccessViewController: BaseViewController {
    
    //MARK: - Properties
    
    internal var viewModel = SuccessViewModel()
    
    internal let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .eerieBlack
        label.font = .futuraMedium(22)
        label.textAlignment = .center
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
    
    private var animationViewSuccess: AnimationView = {
        let view = AnimationView(name: "success")
        view.contentMode = .scaleAspectFit
        view.backgroundBehavior = .pauseAndRestore
        view.loopMode = .loop
        view.play()
        return view
    }()
    
    internal let footerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "Assets_Graphics_Bottom_Curve")
        return imageView
    }()
    
    //MARK: - View Life Cycle
    
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
            make.left.right.equalToSuperview().inset(40)
        }
        
        view.addSubview(animationViewSuccess)
        animationViewSuccess.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.center.equalToSuperview()
            make.height.width.equalTo(280)
        }
        
        view.addSubview(continueButton)
        continueButton.snp.makeConstraints { make in
            make.top.equalTo(animationViewSuccess.snp.bottom).offset(43)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        
        view.addSubview(footerImageView)
        footerImageView.snp.makeConstraints { make in
            make.bottom.equalTo(1)
            make.left.equalTo(-2)
            make.right.equalTo(1)
            make.height.width.equalTo(156)
        }
        footerImageView.isHidden = true //hide for now
    }
    
    override func bind() {
        super.bind()
        
        bindView()
        bindEvents()
    }
    
    //MARK: - Custom
    
    func bindView() {
        viewModel.messageText.bind(to: titleLabel.rx.text).disposed(by: disposeBag)
        
        viewModel.buttonText.bind(to: continueButton.rx.title(for: .normal)).disposed(by: disposeBag)
    }
    
    func bindEvents() {
        continueButton.rx.tap.bind { [weak self] in
            self?.viewModel.success.accept(())
        }.disposed(by: disposeBag)
    }
    
}
