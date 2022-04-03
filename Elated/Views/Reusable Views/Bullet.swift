//
//  Bullet.swift
//  Elated
//
//  Created by Marlon on 2021/3/22.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class Bullet: UIView {
    
    let selected = BehaviorRelay<Bool>(value: false)
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .jet
        label.font = .futuraBook(14)
        label.numberOfLines = 0
        return label
    }()
    
    private let bullet: UIView = {
        let view = UIView()
        view.backgroundColor = .palePurplePantone
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let bulletFill: UIView = {
        let view = UIView()
        view.backgroundColor = .elatedPrimaryPurple
        view.layer.cornerRadius = 5
        return view
    }()
    
    init(_ text: String) {
        super.init(frame: .zero)
        label.text = text
        initSubviews()
        bind()
    }
    
    private func initSubviews() {
        addSubview(bullet)
        bullet.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.height.equalTo(16)
            make.centerY.equalToSuperview()
        }
        
        addSubview(bulletFill)
        bulletFill.snp.makeConstraints { make in
            make.center.equalTo(bullet)
            make.height.width.equalTo(10)
        }
        
        addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalTo(bullet.snp.right).offset(10)
            make.right.top.bottom.equalToSuperview()
        }
    }
    
    
    private func bind() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setSelected)))
        selected.map { !$0 }.bind(to: bulletFill.rx.isHidden).disposed(by: rx.disposeBag)
    }
    
    @objc private func setSelected() {
        selected.accept(true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
