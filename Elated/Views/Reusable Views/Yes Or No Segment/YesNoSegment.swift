//
//  YesNoSegment.swift
//  Elated
//
//  Created by Marlon on 3/29/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class YesNoSegment: UIView {

    enum State {
        case yes
        case no
    }
    
    let state = BehaviorRelay<State>(value: .yes)
    
    private let yesButton: UIButton = {
        let button = UIButton()
        button.setTitle("common.yes".localized, for: .normal)
        button.titleLabel?.font = .futuraBook(12)
        button.titleLabel?.textColor = .elatedPrimaryPurple
        button.contentEdgeInsets = UIEdgeInsets(top: 15, left: 20,bottom: 15,right: 15)
        return button
    }()
    
    private let noButton: UIButton = {
        let button = UIButton()
        button.setTitle("common.no".localized, for: .normal)
        button.titleLabel?.font = .futuraBook(12)
        button.titleLabel?.textColor = .elatedPrimaryPurple
        button.contentEdgeInsets = UIEdgeInsets(top: 15, left: 15,bottom: 15,right: 20)
        return button
    }()
    
    private lazy var view: UIView = {
        let view = UIView()
        view.backgroundColor = .palePurplePantone
        view.cornerRadius = 20
        return view
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .futuraBook(12)
        label.textColor = .white
        label.backgroundColor = .elatedPrimaryPurple
        label.cornerRadius = 20
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()

    init(_ state: State) {
        super.init(frame: .zero)
        self.state.accept(state)
        initSubviews()
        bind()
    }
    
    private func initSubviews() {
        
        view.addSubview(yesButton)
        yesButton.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
        }
        
        view.addSubview(noButton)
        noButton.snp.makeConstraints { make in
            make.left.equalTo(yesButton.snp.right)
            make.right.top.bottom.equalToSuperview()
        }
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalTo(state.value == .yes ? yesButton : noButton)
        }
        
        addSubview(view)
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(40)
        }
        
    }
    
    private func bind() {
        yesButton.rx.tap.map { .yes }.bind(to: state).disposed(by: rx.disposeBag)
        noButton.rx.tap.map { .no }.bind(to: state).disposed(by: rx.disposeBag)
        
        state.subscribe(onNext: { state in
            UIView.animate(withDuration: 0.2) { [weak self] in
                guard let self = self else { return }
                self.label.snp.remakeConstraints { make in
                    make.edges.equalTo(state == .yes ? self.yesButton : self.noButton)
                }
                self.label.text = state == .yes ? "common.yes".localized : "common.no".localized
                self.layoutIfNeeded()
            }
        }).disposed(by: rx.disposeBag)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
