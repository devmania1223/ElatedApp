//
//  LineTabView.swift
//  Elated
//
//  Created by Marlon on 2021/3/6.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LineTabView: UIView {

    private let disposeBag = DisposeBag()
    let selected = BehaviorRelay<Bool>(value: false)
    private var normalColor: UIColor = .white
    private var activeColor: UIColor = .elatedPrimaryPurple

    private let label: PaddingLabel = {
        let label = PaddingLabel()
        label.paddingLeft = 20
        label.paddingRight = 20
        label.paddingTop = 10
        label.paddingBottom = 10
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let line = UIView()

    init(_ text: String,
         normalColor: UIColor,
         activeColor: UIColor,
         font: UIFont,
         selected: Bool) {
        
        self.label.font = font
        self.label.text = text
        self.label.textColor = normalColor
        self.line.backgroundColor = activeColor
        self.normalColor = normalColor
        self.activeColor = activeColor
        self.selected.accept(selected)
        
        super.init(frame: .zero)
        initSubviews()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initSubviews() {
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapEvent)))

        addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addSubview(line)
        line.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(3.5)
        }
        
    }
    
    private func bind(){
        selected.subscribe(onNext: { [weak self] selected in
            self?.label.textColor = selected ? self?.activeColor : self?.normalColor
            self?.line.isHidden = !selected
        }).disposed(by: disposeBag)
    }
    
    @objc private func tapEvent() {
        selected.accept(true)
    }
    
}
