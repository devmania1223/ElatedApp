//
//  MediaOptionMinimumPopupView.swift
//  Elated
//
//  Created by Marlon on 6/10/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxCocoa

class MediaOptionMinimumPopupView: UIView {
    
    enum MediaType {
        case camera
        case photos
        case instagram
    }
    
    let dismiss = PublishRelay<Void>()
        
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "media.option.minimum.title".localized
        label.font = .futuraMedium(20)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let descLabel: UILabel = {
        let label = UILabel()
        label.text = "media.option.minimum.description".localized
        label.font = .futuraBook(16)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let button = UIButton.createCommonBottomButton("media.option.minimum.button".localized)
    
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
            make.left.right.equalToSuperview().inset(30)
        }
        
        view.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(22)
            make.left.right.equalToSuperview().inset(30)
        }
        
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom).offset(30)
            make.height.equalTo(50)
            make.left.right.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(33)
        }
        
    }
    
    private func bind() {
        button.rx.tap.bind(to: dismiss).disposed(by: rx.disposeBag)
    }
    
}
