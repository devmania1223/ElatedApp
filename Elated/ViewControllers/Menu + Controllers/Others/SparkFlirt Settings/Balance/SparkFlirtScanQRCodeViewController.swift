//
//  SparkFlirtScanQRCodeViewController.swift
//  Elated
//
//  Created by Rey Felipe on 9/30/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

// Reference: https://medium.com/appcoda-tutorials/how-to-build-qr-code-scanner-app-in-swift-b5532406dd6b

import UIKit
import AVFoundation
import Lottie

class SparkFlirtScanQRCodeViewController: ScrollViewController {
    let viewModel = SparkFlirtQRCodeViewModel()
    
    private let bottomBackground = UIImageView(image: #imageLiteral(resourceName: "lower_background"))
    private let scanButton = UIButton.createCommonBottomButton("profile.sparkFlirt.scan")

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .eerieBlack
        label.font = .futuraMedium(22)
        label.text = "profile.sparkFlirt.scan.qr.code".localized
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
    
    private let qrFrame = UIImageView(image: #imageLiteral(resourceName: "qr-frame"))
    
    private let cameraPreview: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    //AV Foundation
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    
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
        
        self.title = isOnboarding ? "" : "profile.sparkFlirt.qr.code.title".localized
        self.setupNavigationBar( !isOnboarding ? .white : .elatedPrimaryPurple,
                                font: .futuraMedium(20),
                                tintColor: !isOnboarding ? .white : .elatedPrimaryPurple,
                                backgroundImage: !isOnboarding ? #imageLiteral(resourceName: "background-header") : nil,
                                addBackButton: true)
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
        
        contentView.addSubview(qrFrame)
        qrFrame.snp.makeConstraints { make in
            make.height.width.equalTo(266)
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
        }

        qrFrame.addSubview(cameraPreview)
        cameraPreview.snp.makeConstraints { make in
            make.height.width.equalTo(250)
            make.center.equalToSuperview()
        }
        
        contentView.addSubview(bodyLabel)
        bodyLabel.snp.makeConstraints { make in
            make.top.equalTo(cameraPreview.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(60)
        }
        
        contentView.addSubview(scanButton)
        scanButton.isHidden = true
        scanButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalToSuperview().inset(50)
            make.top.equalTo(bodyLabel.snp.bottom).offset(30)
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
        
        centerContentViewIfNeeded(offset: Util.heigherThanIphone6 ? 133 : 35)
        
        if !initQRScanner() {
            presentAlert(title: "common.error".localized,
                         message: "profile.sparkFlirt.error.init.camera".localized,
                         callback: {
                            self.navigationController?.popViewController(animated: true)
                         })
        }
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
        
        scanButton.rx.tap.bind {
            // Show credit successful screen.
            
        }.disposed(by: disposeBag)

    }
}

//MARK: - Private Methods
extension SparkFlirtScanQRCodeViewController {
    
    private func gotoToTOnboardingTutorial() {
        let landingNav = UINavigationController(rootViewController: ThisOrThatWelcomePageViewController(onboarding: true))
        landingNav.modalPresentationStyle = .fullScreen
        landingNav.modalTransitionStyle = .crossDissolve
        Util.setRootViewController(landingNav)
    }
    
    private func initQRScanner() -> Bool {
        // Get the back-facing camera for capturing videos
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)

        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return false
        }

        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)

            // Set the input device on the capture session.
            captureSession.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()

            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                cameraPreview.addSubview(qrCodeFrameView)
                cameraPreview.bringSubviewToFront(qrCodeFrameView)
            }

        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return false
        }
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = cameraPreview.layer.bounds
        cameraPreview.layer.addSublayer(videoPreviewLayer!)
        
        // Start video capture.
        captureSession.startRunning()
        
        return true
    }
}

//MARK: - AVCaptureMetadataOutputObjectsDelegate
extension SparkFlirtScanQRCodeViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        guard !viewModel.isBusy() else {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            //bodyLabel.text = "No QR code is detected"
            return
        }

        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject

        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            guard let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj),
                  let qrCode = metadataObj.stringValue,
                  let qrCodeFrameView = qrCodeFrameView
            else {
                //bodyLabel.text = "No QR code is detected"
                return
            }
            
            qrCodeFrameView.frame = barCodeObject.bounds
            cameraPreview.bringSubviewToFront(qrCodeFrameView)

            //bodyLabel.text = qrCode
            //TODO: Send the QR Code to BE for validation, app should not detect QRCode once a request is in process.
            viewModel.claimQRCode(qrCode)
        }
    }
    
}
