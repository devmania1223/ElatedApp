//
//  ChatKeyboardView.swift
//  Elated
//
//  Created by Marlon on 5/6/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ChatKeyboardView: UIView {
    
    let camera = PublishRelay<Void>()
    let send = PublishRelay<String>()

    let textView: UITextView = {
        let textView = UITextView()
        textView.font = .futuraBook(14)
        textView.textColor = .jet
        textView.backgroundColor = .alabasterApprox
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        textView.textAlignment = .right
        textView.clipsToBounds = true
        textView.isScrollEnabled = false
        textView.cornerRadius = 25
        return textView
    }()

    let cameraButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icon-camera"), for: .normal)
        return button
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icon-chat-send"), for: .normal)
        return button
    }()
        
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 86))
        initSubviews()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubviews() {
        
        //NOTE: Make sure to assign height on View Controller
        
        backgroundColor = .white
        addSubview(cameraButton)
        //hide for now
        cameraButton.alpha = 0
        cameraButton.isUserInteractionEnabled = false
        cameraButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            //make.width.equalTo(25)
            make.width.equalTo(0)
            make.height.equalTo(23)
        }
        
        addSubview(textView)
        textView.snp.makeConstraints { make in
            make.left.equalTo(cameraButton.snp.right).offset(8)
            make.centerY.equalTo(cameraButton)
            make.height.lessThanOrEqualTo(300)
            make.top.bottom.greaterThanOrEqualToSuperview().inset(17)
        }
        
        addSubview(sendButton)
        sendButton.snp.makeConstraints { make in
            make.left.equalTo(textView.snp.right).offset(8)
            make.right.equalToSuperview().inset(16)
            make.height.width.equalTo(24)
            make.centerY.equalTo(textView)
        }
        
    }
    
    private func bind() {
        sendButton.rx.tap.bind { [weak self] in
            self?.send.accept(self?.textView.text ?? "")
            self?.textView.text = ""
        }.disposed(by: rx.disposeBag)
        
        cameraButton.rx.tap.bind(to: camera).disposed(by: rx.disposeBag)
        
        textView.rx.text.orEmpty.map { !$0.isEmpty }.bind(to: sendButton.rx.isUserInteractionEnabled).disposed(by: rx.disposeBag)
        textView.rx.text.orEmpty.map { !$0.isEmpty ? 1 : 0.5 }.bind(to: sendButton.rx.alpha).disposed(by: rx.disposeBag)
    }
    
}
