//
//  EditPopupView.swift
//  Elated
//
//  Created by Marlon on 5/31/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class EditPopupView: UIView {

    let didEdit = PublishRelay<Void>()
    let didDelete = PublishRelay<Void>()

    private let editButton: UIButton = {
        let view = UIButton()
        view.titleLabel?.font = .futuraMedium(14)
        view.setTitleColor(.sonicSilver, for: .normal)
        view.setTitle("common.edit".localized, for: .normal)
        view.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return view
    }()
    
    private let deleteButton: UIButton = {
        let view = UIButton()
        view.titleLabel?.font = .futuraMedium(14)
        view.setTitleColor(.sonicSilver, for: .normal)
        view.setTitle("common.delete".localized, for: .normal)
        view.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return view
    }()
    
    @objc func dismiss() {
        self.removeFromSuperview()
    }
    
    init() {
        super.init(frame: .zero)
        initSubviews()
        bindView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    private func initSubviews() {
        backgroundColor = .white
        cornerRadius = 6
        borderWidth = 0.25
        borderColor = .sonicSilver

        snp.makeConstraints { make in
            make.width.equalTo(160)
        }
        
        addSubview(editButton)
        editButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(22)
            make.left.equalToSuperview().inset(17)
        }
        
        addSubview(deleteButton)
        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(editButton.snp.bottom)
            make.left.equalToSuperview().inset(19)
            make.bottom.equalToSuperview().inset(22)
        }
    }
    
    private func bindView() {
        editButton.rx.tap.bind(to: didEdit).disposed(by: rx.disposeBag)
        deleteButton.rx.tap.bind(to: didDelete).disposed(by: rx.disposeBag)
    }

    
}
