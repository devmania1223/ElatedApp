//
//  SparkFlirtSentPopupViewController.swift
//  Elated
//
//  Created by Marlon on 5/17/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class SparkFlirtSentPopupViewController: BaseViewController {

    let viewModel = SparkFlirtInviteViewModel()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "sparkFlirt.invite.title.1".localized
        label.textColor = .eerieBlack
        label.font = .futuraMedium(22)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let mainImageView: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "h4"))
        image.contentMode = .scaleAspectFill
        image.cornerRadius = 69
        image.clipsToBounds = true
        return image
    }()
    
    private let sparkImageView: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "icon-pushnotification-sf"))
        image.contentMode = .scaleAspectFit
        image.cornerRadius = 19
        image.clipsToBounds = true
        return image
    }()
    
    private let subLabel: UILabel = {
        let label = UILabel()
        label.text = "sparkFlirt.invite.sub.1".localized
        label.textColor = .eerieBlack
        label.font = .futuraBook(14)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let footerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "Assets_Graphics_Bottom_Curve")
        return imageView
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
    
    init(title: String, sub: String, button: String) {
        super.init(nibName: nil, bundle: nil)
        viewModel.titleText.accept(title)
        viewModel.buttonText.accept(button)
        viewModel.subText.accept(sub)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(65)
            make.left.right.equalToSuperview().inset(40)
        }
        
        view.addSubview(subLabel)
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(52)
            make.left.right.equalTo(titleLabel)
        }
        
        view.addSubview(mainImageView)
        mainImageView.snp.makeConstraints { make in
            make.top.equalTo(subLabel.snp.bottom).offset(52)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(138)
        }
        
        let sparkView = UIView()
        view.addSubview(sparkView)
        sparkView.backgroundColor = .white
        sparkView.cornerRadius = 24
        sparkView.addSubview(sparkImageView)
        sparkImageView.snp.makeConstraints { make in
            make.height.width.equalTo(36)
            make.center.equalToSuperview()
        }
        
        view.addSubview(sparkView)
        sparkView.snp.makeConstraints { make in
            make.right.bottom.equalTo(mainImageView)
            make.height.width.equalTo(48)
        }
         
        view.addSubview(continueButton)
        continueButton.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(58)
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
        viewModel.buttonText.bind(to: continueButton.rx.title(for: .normal)).disposed(by: disposeBag)
        viewModel.subText.bind(to: subLabel.rx.text).disposed(by: disposeBag)
    }
    
    func bindEvents() {
        continueButton.rx.tap.bind { [weak self] in
            self?.viewModel.success.accept(())
        }.disposed(by: disposeBag)
    }

}
