//
//  MatchesCarouselViewCell.swift
//  Elated
//
//  Created by Marlon on 5/4/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class MatchesCarouselViewCell: UIView {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.cornerRadius = 6
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Marlon B. 27"
        label.font = .futuraMedium(16)
        label.textColor = .white
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingMiddle
        return label
    }()
    
    let subLabel: UILabel = {
        let label = UILabel()
        label.text = "Software Engineer"
        label.font = .futuraBook(14)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let starButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "button-favorite"), for: .normal)
        return button
    }()
    
    let sparkButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "button-sparkflirt"), for: .normal)
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "button-close"), for: .normal)
        return button
    }()
    
    let viewUserButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    var viewUserAction: (() -> Void)?
    var sparkAction: (() -> Void)?
    var favoriteAction: (() -> Void)?
    var cancelAction: (() -> Void)?

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 300, height: 368))
        initSubviews()
        bind()
    }

    private let layerView = UIView()

    private func initSubviews() {
        
        //keep image from going out of bounds
        addSubview(layerView)
        layerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        layerView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        imageView.addGradientLayer(height: 100)
        
        addSubview(sparkButton)
        sparkButton.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.centerY.equalTo(layerView.snp.bottom)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        addSubview(starButton)
        starButton.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.right.equalTo(sparkButton.snp.left).offset(-10)
            make.top.equalTo(sparkButton)
        }
        
        addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.left.equalTo(sparkButton.snp.right).offset(10)
            make.top.equalTo(sparkButton)
        }
        
        addSubview(subLabel)
        subLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalTo(sparkButton.snp.top).offset(-15)
        }
        
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.right.equalTo(subLabel)
            make.bottom.equalTo(subLabel.snp.top).offset(-5)
        }
        
        layerView.addSubview(viewUserButton)
        viewUserButton.snp.makeConstraints { make in
            make.edges.equalTo(imageView)
        }
        
    }
    
    private func bind() {
        sparkButton.addTarget(self, action: #selector(sparkDidTap), for: .touchUpInside)
        starButton.addTarget(self, action: #selector(favoriteDidTap), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelDidTap), for: .touchUpInside)
        viewUserButton.addTarget(self, action: #selector(viewUserDidTap), for: .touchUpInside)
    }
    
    @objc private func sparkDidTap() {
        sparkAction?()
    }
    
    @objc private func cancelDidTap() {
        cancelAction?()
    }
    
    @objc private func favoriteDidTap() {
        favoriteAction?()
    }
    
    @objc private func viewUserDidTap() {
        viewUserAction?()
    }
    
    func set(selected: Bool, match: Match) {
        imageView.kf.setImage(with: URL(string: match.matchedWith?.images.first?.image ?? ""), placeholder: #imageLiteral(resourceName: "profile-placeholder"))
        imageView.alpha = selected ? 1 : 0.5
        cancelButton.isHidden = selected ? false : true
        starButton.isHidden = selected ? false : true
        sparkButton.isHidden = selected ? false : true
        nameLabel.text = match.matchedWith?.getDisplayNameAge()
        subLabel.text = match.matchedWith?.occupation ?? ""
        layerView.addShadowLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
