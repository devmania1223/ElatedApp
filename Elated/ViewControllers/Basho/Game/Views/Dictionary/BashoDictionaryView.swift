//
//  BashoDictionaryView.swift
//  Elated
//
//  Created by Marlon on 4/15/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BashoDictionaryView: UIView {

    var definition = BehaviorRelay<BashoWordDefinition?>(value: nil)
    let didHide = PublishRelay<Void>()
    
    let bgView = UIView()

    private let textView: UITextView = {
        let view = UITextView()
        view.textColor = .jet
        view.backgroundColor = .clear
        view.isEditable = false
        return view
    }()
    
    private let arrowButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "page-up"), for: .normal)
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        initSubviews()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initSubviews() {
        
        backgroundColor = .clear
        
        bgView.backgroundColor = .palePurplePantone
        addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(18)
        }
        
        bgView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.equalTo(bgView.safeAreaLayoutGuide.snp.top).inset(8)
            make.left.right.equalToSuperview().inset(32)
            make.bottom.equalToSuperview().inset(18)
            make.height.equalTo(130)
        }
        
        addSubview(arrowButton)
        arrowButton.snp.makeConstraints { make in
            make.width.height.equalTo(36)
            make.centerX.bottom.equalToSuperview()
        }
        
    }
    
    private func bind() {
        
        definition.subscribe(onNext: { [weak self] def in
            guard let self = self else  { return }
            guard let definitions = def?.definitions else {
                self.textView.text = ""
                return
            }
            
            let groupByCategory = Dictionary(grouping: definitions) { ($0.partOfSpeech ?? "") }
            
            var text = "\(def?.word ?? "")\n"
            for (key, value) in groupByCategory {
                text += "\n \(key)"
                for def in value {
                    text +=  "\n\n \t\((value.firstIndex(where: { $0.definition == def.definition }) ?? 1) + 1).  \(def.definition ?? "")"
                }
            }
            
            self.textView.text = text
            self.textView.scrollToTop(animated: true)
        }).disposed(by: rx.disposeBag)
        
        arrowButton.rx.tap.bind { [weak self] in
            self?.didHide.accept(())
        }.disposed(by: rx.disposeBag)
    }

}
