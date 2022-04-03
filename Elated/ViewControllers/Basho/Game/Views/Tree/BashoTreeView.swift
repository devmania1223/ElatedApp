//
//  BashoTreeView.swift
//  Elated
//
//  Created by Marlon on 8/6/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class BashoTreeView: UIView {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        return stackView
    }()

    let bashoWords = BehaviorRelay<[WordSuggestion]>(value: [])
    let suggestedWords = BehaviorRelay<[WordSuggestion]>(value: [])
    let treeItems = BehaviorRelay<[BashoWordDragDropView]>(value: [])

    init() {
        super.init(frame: .zero)
        initSubviews()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubviews() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints({ make in
            make.top.bottom.centerX.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width)
        })
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        
    }
    
    private func bind() {
        Observable.combineLatest(bashoWords, suggestedWords)
            .subscribe(onNext: { [weak self] basho,
                                             suggestedWords in
            guard let self = self else { return }
            for view in self.stackView.arrangedSubviews {
                view.removeFromSuperview()
            }
            
            var items = [BashoWordDragDropView]()
            
            let pairs = stride(from: 0, to: suggestedWords.endIndex, by: 2).map {
                (suggestedWords[$0], $0 < suggestedWords.index(before: suggestedWords.endIndex) ? suggestedWords[$0.advanced(by: 1)] : nil)
            }
            
            for pair in pairs {
                let view: BashoTreeItem = .fromNib()
                let selectedWord1 = basho.contains(where: { $0.word == pair.0.word })
                let selectedWord2 = basho.contains(where: { $0.word == pair.1?.word })
                view.set(word1: pair.0,
                         selectedWord1: selectedWord1,
                         word2: pair.1,
                         selectedWord2: selectedWord2)
                items.append(view.word1View)
                items.append(view.word2View)
                self.stackView.addArrangedSubview(view)
            }
            self.treeItems.accept(items)
        }).disposed(by: rx.disposeBag)
    }
    
}
