//
//  SparkFlirtInviteNoticeViewController.swift
//  Elated
//
//  Created by Marlon on 5/15/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class SparkFlirtInviteNoticeViewController: BaseViewController {

    internal var viewModel = SparkFlirtInviteNoticeViewModel()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "sparkFlirt.play.title.1".localized
        label.textColor = .eerieBlack
        label.font = .futuraMedium(22)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let meImageView: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "h2"))
        image.contentMode = .scaleAspectFill
        image.cornerRadius = 60
        image.clipsToBounds = true
        return image
    }()
    
    private let otherImageView: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "h7"))
        image.contentMode = .scaleAspectFill
        image.cornerRadius = 60
        image.clipsToBounds = true
        return image
    }()
    
    private let sparkImageView: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "buttons-sparkflirtyellow-circle"))
        image.contentMode = .scaleAspectFit
        image.cornerRadius = 24
        image.clipsToBounds = true
        return image
    }()
    
    private let footerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "Assets_Graphics_Bottom_Curve")
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "sparkFlirt.play.subTitle.2".localized
        label.textColor = .eerieBlack
        label.font = .futuraBook(14)
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
    
    init(title: String, name: String, button: String) {
        super.init(nibName: nil, bundle: nil)
        viewModel.titleText.accept(title)
        viewModel.buttonText.accept(button)
        viewModel.nameText.accept(name)
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
        
        let sparkView = UIView()
        view.addSubview(sparkView)
        sparkView.backgroundColor = .white
        sparkView.cornerRadius = 32
        sparkView.addSubview(sparkImageView)
        sparkImageView.snp.makeConstraints { make in
            make.height.width.equalTo(48)
            make.center.equalToSuperview()
        }
        
        view.addSubview(meImageView)
        view.addSubview(otherImageView)
        view.addSubview(sparkView)
        
        sparkView.snp.makeConstraints { make in
            make.height.width.equalTo(64)
            make.centerY.equalTo(meImageView)
            make.centerX.equalToSuperview()
        }
        
        meImageView.snp.makeConstraints { make in
            make.right.equalTo(sparkView.snp.left).offset(25)
            make.top.equalTo(titleLabel.snp.bottom).offset(55)
            make.height.width.equalTo(120)
        }
        
        otherImageView.snp.makeConstraints { make in
            make.left.equalTo(sparkView.snp.right).offset(-25)
            make.top.equalTo(meImageView)
            make.centerY.equalTo(sparkView)
            make.height.width.equalTo(meImageView)
        }
        
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(otherImageView.snp.bottom).offset(55)
            make.centerX.equalToSuperview()
        }
            
        view.addSubview(continueButton)
        continueButton.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(48)
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
        viewModel.nameText.bind(to: nameLabel.rx.text).disposed(by: disposeBag)
    }
    
    func bindEvents() {
        continueButton.rx.tap.bind { [weak self] in
            self?.viewModel.success.accept(())
        }.disposed(by: disposeBag)
    }

}
