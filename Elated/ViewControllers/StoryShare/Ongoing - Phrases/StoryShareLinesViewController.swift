//
//  StoryShareLinesViewController.swift
//  Elated
//
//  Created by Marlon on 10/6/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class StoryShareLinesViewController: BaseViewController {

    private let viewModel = StoryShareLinesViewModel()
    
    private let backgroundImage = UIImageView(image: #imageLiteral(resourceName: "background-storyshare"))
    
    private let settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icon-gear-white").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .chestnut
        return button
    }()
    
    private let typeWriterImage: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "typewriter"))
        imageView.contentMode = .top
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .chestnut
        label.font = .courierPrimeRegular(20)
        label.text = "storyshare.title".localized
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let subLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "storyshare.phrase.other.finished.line".localized
        label.font = .futuraMedium(22)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .umber
        label.font = .courierPrimeRegular(14)
        label.text = "storyshare.phrase.yourTurn.message".localized
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton.createCommonBottomButton("common.continue")
        button.backgroundColor = .umber
        return button
    }()
    
    init(_ info: StoryShareGameDetail) {
        super.init(nibName: nil, bundle: nil)
        viewModel.info.accept(info)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.hideNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hideNavBar()
    }
    
    override func initSubviews() {
        super.initSubviews()
        view.backgroundColor = .white
        
        view.addSubview(backgroundImage)
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(15)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(settingsButton)
        settingsButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.right.equalToSuperview().inset(20)
            make.height.width.equalTo(24)
        }
        
        view.addSubview(subLabel)
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(70)
            make.left.right.equalToSuperview().inset(33)
        }
        
        view.addSubview(typeWriterImage)
        typeWriterImage.snp.makeConstraints { make in
            make.top.equalTo(subLabel.snp.bottom).offset(22)
            make.left.right.equalToSuperview().inset(13)
        }
        
        view.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(typeWriterImage).offset(60)
            make.left.right.equalTo(typeWriterImage).inset(33)
        }
        
        view.addSubview(continueButton)
        continueButton.snp.makeConstraints { make in
            make.top.equalTo(typeWriterImage.snp.bottom).offset(50)
            make.left.right.equalToSuperview().inset(33)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-40)
        }
        
    }
    
    override func bind() {
        super.bind()
        
        viewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)

        viewModel.presentAlert.subscribe(onNext: { [weak self] args in
            let (title, message) = args
            self?.presentAlert(title: title, message: message)
        }).disposed(by: disposeBag)
        
        viewModel.info.subscribe(onNext: { [weak self] info in
            guard let info = info else { return }
            let line = info.phrases.count
            if line > 0 {
                var lineAddition = ""
                switch line {
                case 1:
                    lineAddition = "st"
                    break
                case 2:
                    lineAddition = "nd"
                    break
                case 3:
                    lineAddition = "rd"
                    break
                default:
                    lineAddition = "th"
                    break
                }
                let name = info.currentPlayerTurn == info.inviter?.id ? info.invitee?.firstName : info.inviter?.firstName
                self?.subLabel.text = "storyshare.phrase.other.finished.line".localizedFormat("\(name ?? "")","\(line)\(lineAddition)")
            }
        }).disposed(by: disposeBag)
        
        continueButton.rx.tap.bind { [weak self] in
            guard let info = self?.viewModel.info.value else { return }
            self?.navigationController?.show(StoryShareGameViewController(info, isFromLineView: true),
                                             sender: nil)
        }.disposed(by: disposeBag)
        
    }

}
