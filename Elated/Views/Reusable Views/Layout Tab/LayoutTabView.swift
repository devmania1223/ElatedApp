//
//  LayoutTabView.swift
//  Elated
//
//  Created by Marlon on 2021/3/19.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class LayoutTabView: UIView {

    enum Layout {
        case tile
        case grid
    }
    
    let layout = BehaviorRelay<Layout>(value: .tile)
    
    private let tileButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icon-tile-view"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "icon-tile-view-active"), for: .selected)
        button.contentMode = .center
        return button
    }()
    
    private let gridButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icon-grid-view"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "icon-grid-view-active"), for: .selected)
        button.contentMode = .center
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
        let stackView = UIStackView(arrangedSubviews: [tileButton, gridButton])
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(40)
        }
    }

    private func bind() {
        tileButton.rx.tap.map { Layout.tile }.bind(to: layout).disposed(by: rx.disposeBag)
        gridButton.rx.tap.map { Layout.grid }.bind(to: layout).disposed(by: rx.disposeBag)
        layout.map { $0 == .tile }.bind(to: tileButton.rx.isSelected).disposed(by: rx.disposeBag)
        layout.map { $0 == .grid }.bind(to: gridButton.rx.isSelected).disposed(by: rx.disposeBag)
    }
    
}
