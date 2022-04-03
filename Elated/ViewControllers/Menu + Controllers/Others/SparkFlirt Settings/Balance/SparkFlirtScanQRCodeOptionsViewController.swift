//
//  SparkFlirtScanQRCodeOptionsViewController.swift
//  Elated
//
//  Created by Rey Felipe on 9/30/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import AVFoundation
import Lottie

class SparkFlirtScanQRCodeOptionsViewController: ScrollViewController {
    let viewModel = SparkFlirtQRCodeViewModel()
    
    private let bottomBackground = UIImageView(image: #imageLiteral(resourceName: "lower_background"))
    private let scanButton = UIButton.createCommonBottomButton("profile.sparkFlirt.scan.qr.code")
    private let photoButton: UIButton = {
        let button = UIButton.createButtonWithShadow("profile.sparkFlirt.choose.from.photo.album", with: true)
        button.borderWidth = 0.25
        button.borderColor = .silver
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .eerieBlack
        label.font = .futuraMedium(22)
        label.text = "profile.sparkFlirt.scan.qr.code.title".localized
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    //TODO: Design concern is label even needed?
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grayColor
        label.font = .futuraMedium(14)
        label.text = "Add some note here... (optional)".localized
        label.text = ""
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let animationView: AnimationView = {
        let animation = AnimationView(name: "qr-popout")
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .loop
        animation.backgroundBehavior = .pauseAndRestore
        animation.play()
        return animation
    }()
    
    private var isOnboarding = false
    
    init(_ onboarding: Bool = false) {
        super.init(nibName: nil, bundle: nil)
        self.isOnboarding = onboarding
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = isOnboarding ? "" : "QR Code".localized
//        self.setupNavigationBar(.white,
//                                font: .futuraMedium(20),
//                                tintColor: .white,
//                                backgroundImage: #imageLiteral(resourceName: "background-header"),
//                                addBackButton: !isOnboarding)
        
        self.setupNavigationBar(isOnboarding ? .elatedPrimaryPurple : .white,
                                font: .futuraMedium(20),
                                tintColor: isOnboarding ? .elatedPrimaryPurple : .white,
                                backgroundImage: isOnboarding ? nil : #imageLiteral(resourceName: "background-header"),
                                addBackButton: !isOnboarding)
        
        //Add Skip button on the upper left side of the screen if onboarding
        if isOnboarding {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "common.skip".localized,
                                                                     style: .done,
                                                                     target: self,
                                                                     action: #selector(skip))
        }
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
            make.height.width.equalTo(200)
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
        }
        
        contentView.addSubview(bodyLabel)
        bodyLabel.snp.makeConstraints { make in
            make.top.equalTo(animationView.snp.bottom)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(60)
        }
        
        contentView.addSubview(scanButton)
        scanButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalToSuperview().inset(50)
            make.top.equalTo(bodyLabel.snp.bottom).offset(30)
        }
        
        contentView.addSubview(photoButton)
        photoButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalToSuperview().inset(50)
            make.top.equalTo(scanButton.snp.bottom).offset(20)
            make.bottom.equalToSuperview().offset(-25)
        }
        
        view.addSubview(bottomBackground)
        bottomBackground.snp.makeConstraints { make in
            make.height.equalTo(135)
            make.left.equalToSuperview().offset(-2)
            make.right.equalToSuperview().offset(2)
            make.bottom.equalToSuperview().offset(Util.heigherThanIphone6 ? 2 : 100)
        }
        view.bringSubviewToFront(scrollView)
        
        //navigationController?.hideNavBar()
        centerContentViewIfNeeded(offset: Util.heigherThanIphone6 ? 133 : 35)
    }
    
    override func bind() {
        super.bind()
        
        viewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)
        
        viewModel.success.subscribe( onNext: { [weak self] args in
            guard let self = self else { return }
            let (credit) = args
            let vc = SparkFlirtAddCreditSuccessViewController(.viaQRCode, credit: credit, onboarding: self.isOnboarding)
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.dismissCompleteHandler = { [weak self] in
                guard let self = self else { return }
                if self.isOnboarding {
                    self.gotoToTOnboardingTutorial()
                } else {
                    self.goBack(to: SparkFlirtPageSettingsViewController.self)
                }
            }
            self.present(vc, animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        let imagePicker = ImagePicker()
        scanButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            //Check for camera permission
            imagePicker.getPermissionCamera { granted in
                if granted {
                    self.show(SparkFlirtScanQRCodeViewController(self.isOnboarding), sender: nil)
                }
            }
        }.disposed(by: disposeBag)
        
        photoButton.rx.tap.bind {
            imagePicker.getPermissionLibraryImage { image in
                guard let qrCodeImage = image,
                      let detector  = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh]),
                      let ciImage = CIImage(image:qrCodeImage),
                      let features = detector.features(in: ciImage) as? [CIQRCodeFeature]
                else { return }
                    
                guard !features.isEmpty,
                      let qrCode = features[0].messageString
                else {
                    print("No QR Code to decode.")
                    //self.bodyLabel.text = "No QR Code to decode."
                    self.presentAlert(title: "common.error".localized,
                                      message: "profile.sparkFlirt.error.no.qrcode".localized,
                                      callback: nil)
                    return
                }

                print("Decoded QR Code: \(qrCode)")
                //self.bodyLabel.text = "Decoded QR Code: \(qrCode)"
                self.viewModel.claimQRCode(qrCode)
            }
        }.disposed(by: disposeBag)

    }
    
    
}

//MARK: - Private Methods
extension SparkFlirtScanQRCodeOptionsViewController {
    
    private func gotoToTOnboardingTutorial() {
        let landingNav = UINavigationController(rootViewController: ThisOrThatWelcomePageViewController(onboarding: true))
        landingNav.modalPresentationStyle = .fullScreen
        landingNav.modalTransitionStyle = .crossDissolve
        Util.setRootViewController(landingNav)
    }

    @objc private func skip() {
        let landingNav = UINavigationController(rootViewController: ThisOrThatWelcomePageViewController(onboarding: true))
        landingNav.modalPresentationStyle = .fullScreen
        landingNav.modalTransitionStyle = .crossDissolve
        Util.setRootViewController(landingNav)
    }

}
