//
//  BashoKeyboardAccessoryView.swift
//  Elated
//
//  Created by Marlon on 4/15/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxCocoa

class BashoKeyboardAccessoryView: UIView {    
    
    let manageSyllable = BehaviorRelay<Bool>(value: false)
    let manageSearch = BehaviorRelay<Bool>(value: false)

    lazy var textField: UITextField = {
        let view = UITextField()
        view.layer.cornerRadius = 30
        view.backgroundColor = .alabasterApprox
        view.font = .futuraBook(12)
        view.textColor = .jet
        
        let spacer = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 60))
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 78, height: 60))
        
        view.leftViewMode = .always
        view.rightViewMode = .always
        view.leftView = spacer
        view.rightView = rightView
        view.enablesReturnKeyAutomatically = false
        view.placeholder = "basho.texfield.placeholder".localized
        view.inputAccessoryView = nil
        view.autocorrectionType = .no
        view.returnKeyType = .next
        view.enablesReturnKeyAutomatically = false
        
//        rightView.addSubview(sylableButton)
//        rightView.addSubview(searchButton)
        return view
    }()
    
    //TODO: Update button images
    let sylableButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icon-basho-syllable"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "icon-basho-syllable-active"), for: .selected)
        return button
    }()
    
    let searchButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icon-basho-search"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "icon-basho-search-active"), for: .selected)
        return button
    }()
    
    let sendButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icon-chat-send"), for: .normal)
        return button
    }()
    
    let didTap = PublishRelay<Void>()
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 86))
        initSubviews()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubviews() {
        
        backgroundColor = .white
        addSubview(textField)
        textField.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(16)
            make.height.equalTo(60)
            make.bottom.equalToSuperview().inset(10)
        }
        
        addSubview(sendButton)
        sendButton.snp.makeConstraints { make in
            make.left.equalTo(textField.snp.right).offset(9)
            make.right.equalToSuperview().inset(16)
            make.height.width.equalTo(25)
            make.centerY.equalTo(textField)
        }
        
        addSubview(sylableButton)
        sylableButton.snp.makeConstraints { make in
            make.height.width.equalTo(25)
            make.centerY.equalTo(textField)
        }

        addSubview(searchButton)
        searchButton.snp.makeConstraints { make in
            make.left.equalTo(sylableButton.snp.right).offset(8)
            make.right.equalTo(sendButton.snp.left).offset(-22)
            make.height.width.equalTo(sylableButton)
            make.centerY.equalTo(textField)
        }
        
    }
    
    private func bind() {
        sylableButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.manageSearch.accept(false)
            self.manageSyllable.accept(!self.manageSyllable.value)
            self.sylableButton.isSelected = !self.sylableButton.isSelected
            self.searchButton.isSelected = false
        }.disposed(by: rx.disposeBag)
        
        searchButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.manageSyllable.accept(false)
            self.manageSearch.accept(!self.manageSearch.value)
            self.searchButton.isSelected = !self.searchButton.isSelected
            self.sylableButton.isSelected = false
        }.disposed(by: rx.disposeBag)
    }
    
    @objc func didTapBg() {
        didTap.accept(())
    }
    
}
