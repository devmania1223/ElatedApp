//
//  MediaOptionPopupView.swift
//  Elated
//
//  Created by Marlon on 5/20/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxCocoa

class MediaOptionPopupView: UIView {
    
    enum MediaType {
        case camera
        case photos
        case instagram
    }
    
    let didSelect = PublishRelay<MediaType>()
        
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "media.option.title".localized
        label.font = .futuraMedium(20)
        label.textAlignment = .center
        return label
    }()
    
    private let cameraButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icon-camera-1"), for: .normal)
        return button
    }()
    
    private let cameraLabel: UILabel = {
        let label = UILabel()
        label.text = "media.option.camera".localized
        label.font = .futuraBook(12)
        label.textAlignment = .center
        return label
    }()
    
    private let photosButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icon-gallery"), for: .normal)
        return button
    }()

    private let photosLabel: UILabel = {
        let label = UILabel()
        label.text = "media.option.photos".localized
        label.font = .futuraBook(12)
        label.textAlignment = .center
        return label
    }()
    
    private let instagramButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icon-instagram"), for: .normal)
        return button
    }()
        
    private let instagramLabel: UILabel = {
        let label = UILabel()
        label.text = "media.option.instagram".localized
        label.font = .futuraBook(12)
        label.textAlignment = .center
        return label
    }()
    
    private let cancelButton = UIButton.createCommonBottomButton("common.cancel".localized)
    
    init() {
        super.init(frame: .zero)
        initSubviews()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubviews() {
        
        backgroundColor = UIColor.lavanderFloral.withAlphaComponent(0.8)
        
        let view = UIView()
        view.cornerRadius = 12
        view.backgroundColor = .white
        addSubview(view)
        view.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(snp.width).inset(33)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(42)
            make.left.right.equalToSuperview().inset(10)
        }
        
        cameraButton.snp.makeConstraints { make in
            make.width.height.equalTo(60)
        }
        
        photosButton.snp.makeConstraints { make in
            make.width.height.equalTo(60)
        }
        
        instagramButton.snp.makeConstraints { make in
            make.width.height.equalTo(60)
        }
        
        let cameraStack = UIStackView(arrangedSubviews: [cameraButton, cameraLabel])
        cameraStack.axis = .vertical
        cameraStack.spacing = 2
        
        let photosStack = UIStackView(arrangedSubviews: [photosButton, photosLabel])
        photosStack.axis = .vertical
        photosStack.spacing = 2
        
        let instagramStack = UIStackView(arrangedSubviews: [instagramButton, instagramLabel])
        instagramStack.axis = .vertical
        instagramStack.spacing = 2
        
        let buttonStack = UIStackView(arrangedSubviews: [cameraStack, photosStack, instagramStack])
        buttonStack.distribution = .fillEqually
        
        view.addSubview(buttonStack)
        buttonStack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.left.right.equalToSuperview().inset(20)
        }
        
        view.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(buttonStack.snp.bottom).offset(54)
            make.height.equalTo(50)
            make.left.right.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(33)
        }
        
    }
    
    private func bind() {
        cameraButton.rx.tap.map { .camera }.bind(to: didSelect).disposed(by: rx.disposeBag)
        photosButton.rx.tap.map { .photos }.bind(to: didSelect).disposed(by: rx.disposeBag)
        instagramButton.rx.tap.map { .instagram }.bind(to: didSelect).disposed(by: rx.disposeBag)
        
        cancelButton.rx.tap.bind { [weak self] in
            self?.removeFromSuperview()
        }.disposed(by: rx.disposeBag)
    }
    
}
