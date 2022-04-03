//
//  CarouselCellView.swift
//  Elated
//
//  Created by Marlon on 5/3/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class PriceCarouselCellView: UIView {
    
    let gradientLayer = UIView()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .futuraBold(30)
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.text = "$1.98"
        return label
    }()
    
    let amountLabel: UILabel = {
        let label = UILabel()
        label.font = .futuraMedium(20)
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.text = "2 SparkFlirt"
        return label
    }()
    
    let radioView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerRadius = 11
        return view
    }()
    
    let radioInsideView: UIView = {
        let view = UIView()
        view.backgroundColor = .elatedPrimaryPurple
        view.cornerRadius = 6
        view.isHidden = true
        return view
    }()
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 140, height: 140))
        initSubviews()
        bind()
    }
    
    private func initSubviews() {
        
        layer.cornerRadius = 6
        clipsToBounds = true
        backgroundColor = .palePurplePantone
        
        addSubview(gradientLayer)
        gradientLayer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.width.equalTo(140)
        }
        
        addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(13)
            make.left.right.equalToSuperview().inset(27)
        }
        
        addSubview(amountLabel)
        amountLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(2)
            make.left.right.equalTo(priceLabel)
        }
        
        addSubview(radioView)
        radioView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.height.equalTo(22)
            make.bottom.equalToSuperview().inset(13)
        }
        
        radioView.addSubview(radioInsideView)
        radioInsideView.snp.makeConstraints { make in
            make.center.equalTo(radioView)
            make.width.height.equalTo(12)
        }
        
    }
    
    private func bind() {
        
    }
    
    func set(selected: Bool, price: String, amount: String) {
        priceLabel.text = price
        amountLabel.text = amount
        
        priceLabel.textColor = selected ? .white : .elatedPrimaryPurple
        amountLabel.textColor = selected ? .white : .elatedPrimaryPurple

        if selected {
            self.gradientBackground(from: .lavanderFloral,
                                    to: .darkOrchid,
                                    direction: .topToBottom)
        }
        radioInsideView.isHidden = !selected
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
