//
//  SyllableView.swift
//  Elated
//
//  Created by Marlon on 9/8/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BashoSyllableView: UIView {

    let syllableLimit = BehaviorRelay<Int>(value: 1)
    let currentSelected = BehaviorRelay<Int>(value: 1)

    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 8
        return view
    }()
    
    private lazy var syllableButton1 = createButton(number: 1)
    private lazy var syllableButton2 = createButton(number: 2)
    lazy var syllableButton3 = createButton(number: 3)
    private lazy var syllableButton4 = createButton(number: 4)
    private lazy var syllableButton5 = createButton(number: 5)
    private lazy var syllableButton6 = createButton(number: 6)
    private lazy var syllableButton7 = createButton(number: 7)
    
    private lazy var buttonCollection = [syllableButton1,
                                         syllableButton2,
                                         syllableButton3,
                                         syllableButton4,
                                         syllableButton5,
                                         syllableButton6,
                                         syllableButton7]
    
    private let arrowButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icon-forward").withRenderingMode(.alwaysTemplate), for: .selected)
        button.setImage(#imageLiteral(resourceName: "icon-back").withRenderingMode(.alwaysTemplate), for: .normal)
        button.borderWidth = 2
        button.borderColor = .elatedPrimaryPurple
        button.cornerRadius = 16
        button.backgroundColor = .white
        button.tintColor = .elatedPrimaryPurple
        return button
    }()

    init() {
        super.init(frame: .zero)
        initSubviews()
        bind()
    }
    
    private func initSubviews() {
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview().inset(2)
        }
        
        syllableButton1.snp.makeConstraints { make in
            make.width.height.equalTo(32)
        }
        
        syllableButton2.snp.makeConstraints { make in
            make.width.height.equalTo(32)
        }
        
        syllableButton3.snp.makeConstraints { make in
            make.width.height.equalTo(32)
        }
        
        syllableButton4.snp.makeConstraints { make in
            make.width.height.equalTo(32)
        }
        
        syllableButton5.snp.makeConstraints { make in
            make.width.height.equalTo(32)
        }
        
        syllableButton6.snp.makeConstraints { make in
            make.width.height.equalTo(32)
        }
        
        syllableButton7.snp.makeConstraints { make in
            make.width.height.equalTo(32)
        }
        
        addSubview(arrowButton)
        arrowButton.snp.makeConstraints { make in
            make.left.equalTo(stackView.snp.right).offset(8)
            make.centerY.equalTo(stackView)
            make.right.equalToSuperview().inset(2)
            make.width.height.equalTo(32)
        }
        
    }
    
    private func bind() {
 
        syllableLimit.subscribe(onNext: { [weak self] limit in
            guard let self = self else { return }
            if !self.arrowButton.isSelected {
                self.manageValues()
            }
            if limit < self.currentSelected.value {
                //to avoid unnecessary logic
                self.currentSelected.accept(1)
            }
        }).disposed(by: rx.disposeBag)
        
        currentSelected.subscribe(onNext: { [weak self] selected in
            guard let self = self else { return }
            for sub in self.stackView.arrangedSubviews {
                sub.removeFromSuperview()
            }
            let button = self.buttonCollection[selected - 1]
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .elatedPrimaryPurple
            
            self.arrowButton.isSelected = true
            
            self.stackView.addArrangedSubview(button)
            self.stackView.setNeedsLayout()
            self.layoutSubviews()
            self.layoutIfNeeded()
        }).disposed(by: rx.disposeBag)
        
        arrowButton.rx.tap.bind { [weak self] in
            self?.manageValues()
        }.disposed(by: rx.disposeBag)
        
        syllableButton1.rx.tap.map { 1 }.bind(to: currentSelected).disposed(by: rx.disposeBag)
        syllableButton2.rx.tap.map { 2 }.bind(to: currentSelected).disposed(by: rx.disposeBag)
        syllableButton3.rx.tap.map { 3 }.bind(to: currentSelected).disposed(by: rx.disposeBag)
        syllableButton4.rx.tap.map { 4 }.bind(to: currentSelected).disposed(by: rx.disposeBag)
        syllableButton5.rx.tap.map { 5 }.bind(to: currentSelected).disposed(by: rx.disposeBag)
        syllableButton6.rx.tap.map { 6 }.bind(to: currentSelected).disposed(by: rx.disposeBag)
        syllableButton7.rx.tap.map { 7 }.bind(to: currentSelected).disposed(by: rx.disposeBag)

    }
    
    func manageValues() {
        let selected = self.arrowButton.isSelected
        let limit = self.syllableLimit.value
        
        UIView.animate(withDuration: 0.1) {
            for sub in self.stackView.arrangedSubviews {
                sub.removeFromSuperview()
            }
            if selected {
                for i in 0..<limit {
                    let button = self.buttonCollection[i]
                    button.setTitleColor(.elatedPrimaryPurple, for: .normal)
                    button.backgroundColor = .white
                    self.stackView.addArrangedSubview(button)
                }
            } else {
                let button = self.buttonCollection[self.currentSelected.value - 1]
                button.setTitleColor(.white, for: .normal)
                button.backgroundColor = .elatedPrimaryPurple
                self.stackView.addArrangedSubview(button)
            }
            self.arrowButton.isSelected = !selected
        }
        
        self.stackView.setNeedsLayout()
        self.layoutSubviews()
        self.layoutIfNeeded()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createButton(number: Int) -> UIButton {
        let button = UIButton()
        button.setTitle("\(number)", for: .normal)
        button.titleLabel?.font = .futuraBook(14)
        button.cornerRadius = 16
        button.backgroundColor = .white
        button.borderWidth = 2
        button.borderColor = .elatedPrimaryPurple
        button.cornerRadius = 16
        return button
    }
    
}
