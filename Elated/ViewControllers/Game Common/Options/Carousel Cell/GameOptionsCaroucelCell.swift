//
//  GameOptionsCaroucelCell.swift
//  Elated
//
//  Created by Marlon on 5/18/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class GameOptionsCaroucelCell: UIView {

    private let imageView: UIImageView = {
        let view =  UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.cornerRadius = 12
        return view
    }()
    
    private let bgView: UIImageView = {
        let view =  UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.cornerRadius = 12
        return view
    }()
    
    private let logoView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let label: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = .futuraBook(14)
        view.textColor = .white
        view.textAlignment = .center
        return view
    }()
    
    init(size: CGFloat) {
        super.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
        initSubviews()
        bind()
    }
    
    private func initSubviews() {
        
        let view = UIView()
        addSubview(view)
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        imageView.addGradientLayer(height: 100)
        
        view.addSubview(logoView)
        logoView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-45)
            make.left.right.equalToSuperview().inset(28)
        }
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview().inset(28)
        }
    }
    
    private func bind() {
        
    }
    
    func set(_ option: GameOptionsViewModel.GameOption) {
        imageView.image = option.image
        bgView.image = option.background
        logoView.image = option.logo
        label.text = option.message
        label.addShadowLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
