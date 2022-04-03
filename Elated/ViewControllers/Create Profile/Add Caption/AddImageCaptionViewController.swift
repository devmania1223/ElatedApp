//
//  AddImageCaptionViewController.swift
//  Elated
//
//  Created by Marlon on 7/17/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import Kingfisher

class AddImageCaptionViewController: ScrollViewController {
    
    private let viewModel = AddImageCaptionViewModel()
    
    private let bottomBackground = UIImageView(image: #imageLiteral(resourceName: "lower_background"))
    
    private let nextButton = UIButton.createCommonBottomButton("common.next")
    
    private let profileImageView: ZoomImageScrollView  = {
        let view = ZoomImageScrollView(nil)
        view.imageView.contentMode = .scaleAspectFill
        view.imageView.clipsToBounds = true
        return view
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.font = .futuraBook(14)
        textView.textColor = .sonicSilver
        textView.backgroundColor = .alabasterSolid
        textView.layer.borderWidth = 0.25
        textView.layer.borderColor = UIColor.silver.cgColor
        textView.layer.cornerRadius = 6
        textView.textContainerInset = UIEdgeInsets(top: 21, left: 16, bottom: 21, right: 16)
        textView.text = "profile.gallery.caption.placeholder".localized
        return textView
    }()
    
    private let shadowView = UIView()
    
    private let confirmButton = UIBarButtonItem.createCheckButton()

    init(image: UIImage?, urlImage: String?, sourceID: String?, editType: EditInfoControllerType) {
        super.init(nibName: nil, bundle: nil)
        self.title = "createProfile.photo.addCaption".localized
        
        viewModel.image.accept(image)
        viewModel.urlImage.accept(urlImage)
        viewModel.sourceID.accept(sourceID)
        viewModel.editType.accept(editType)
        
        let isOnboarding = editType == .onboarding
        bottomBackground.isHidden = !isOnboarding
        nextButton.isHidden = !isOnboarding
        
        shadowView.addShadowLayer()
        profileImageView.addShadowLayer()
        
        confirmButton.tintColor = .white
        if !isOnboarding {
            self.navigationItem.rightBarButtonItem = confirmButton
        }
        
        if let image = image {
            profileImageView.image = image
        } else if let urlImage = urlImage {
            profileImageView.imageView.kf.setImage(with: URL(string: urlImage), placeholder: #imageLiteral(resourceName: "profile-placeholder"))
        }
        
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
        shadowView.addShadowLayer()
        let type = viewModel.editType.value
        self.setupNavigationBar(type == .onboarding ? .elatedPrimaryPurple : .white,
                                font: .futuraMedium(20),
                                tintColor: type == .onboarding ? .elatedPrimaryPurple : .white,
                                backgroundImage: type == .onboarding ? nil : #imageLiteral(resourceName: "background-header"),
                                addBackButton: type != .onboarding)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    
    override func initSubviews() {
        super.initSubviews()
                
        shadowView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.width)
        }
        
        contentView.addSubview(shadowView)
        shadowView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(12)
        }
        
        contentView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(12)
            make.height.equalTo(UIScreen.main.bounds.width)
            make.bottom.equalToSuperview().inset(20)
        }
        
        textView.rx.text.orEmpty.bind(to: viewModel.caption).disposed(by: disposeBag)
        
        view.addSubview(bottomBackground)
        bottomBackground.snp.makeConstraints { make in
            make.height.equalTo(viewModel.editType.value == .onboarding ? 135 : 0) //including offset 2
            make.left.equalToSuperview().offset(-2)
            make.right.bottom.equalToSuperview().offset(2)
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.centerY.equalTo(bottomBackground)
            make.left.right.equalToSuperview().inset(33)
            make.height.equalTo(viewModel.editType.value == .onboarding ? 50 : 0)
        }
        
        scrollView.snp.remakeConstraints({ make in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(bottomBackground.snp.top)
        })
        
    }
    
    override func bind() {
        super.bind()
        
        viewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)
        
        viewModel.presentAlert.subscribe( onNext: { [weak self] args in
            let (title, message) = args
            self?.presentAlert(title: title, message: message)
        }).disposed(by: disposeBag)
        
        viewModel.goBack.subscribe( onNext: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        textView.rx.didBeginEditing.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            if self.textView.text == "profile.gallery.caption.placeholder".localized {
                self.textView.text = ""
            }
        }).disposed(by: disposeBag)
        
        textView.rx.didEndEditing.subscribe(onNext: { [weak self] text in
            guard let self = self else { return }
            if self.textView.text.isEmpty {
                self.textView.text = "profile.gallery.caption.placeholder".localized
            }
        }).disposed(by: disposeBag)
        
        nextButton.rx.tap.bind { [weak self] in
            self?.viewModel.upload()
        }.disposed(by: disposeBag)
        
        confirmButton.rx.tap.bind { [weak self] in
            self?.viewModel.upload()
        }.disposed(by: rx.disposeBag)
        
    }
    
}
