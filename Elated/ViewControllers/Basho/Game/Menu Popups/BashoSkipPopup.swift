//
//  BashoSkipPopup.swift
//  Elated
//
//  Created by Marlon on 8/21/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BashoSkipPopup: UIView {

    let didClose = PublishRelay<Void>()

    private let bgView: UIView = {
        let view = UIView()
        view.cornerRadius = 8
        view.backgroundColor = .white
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .futuraMedium(16)
        label.textColor = .jet
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "basho.settings.turnSkipped.title".localized
        return label
    }()
    
    private let subLabel: UILabel = {
        let label = UILabel()
        label.font = .futuraLight(14)
        label.textColor = .jet
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "basho.settings.turnSkipped.message".localized
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("common.gotit".localized, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .elatedPrimaryPurple
        button.cornerRadius = 22.5
        button.titleLabel?.font = .futuraBook(14)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubviews() {
        
        backgroundColor = UIColor.black.withAlphaComponent(0.6)
        addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(33)
        }
        
        bgView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.left.right.equalToSuperview().inset(55)
        }
        
        bgView.addSubview(subLabel)
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(33)
            make.left.right.equalToSuperview().inset(22)
        }
        
        bgView.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(subLabel.snp.bottom).offset(22)
            make.left.right.equalToSuperview().inset(22)
            make.bottom.equalToSuperview().inset(33)
            make.height.equalTo(45)
        }
        
    }
    
    private func bind() {
        
        closeButton.rx.tap.bind { [weak self] in
            self?.didClose.accept(())
        }.disposed(by: rx.disposeBag)
        
    }


}
