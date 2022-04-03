//
//  FavoritesFavedCollectionCell.swift
//  Elated
//
//  Created by Marlon on 5/4/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class FavoritesFavedCollectionCell: UICollectionViewCell {
    
    static let identifier = "FavoritesFavedCollectionCell"

    var sparkAction: (() -> Void)?
    var favoriteAction: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.cornerRadius = 6
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Marlon B. 27"
        label.font = .futuraMedium(14)
        label.textColor = .white
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingMiddle
        return label
    }()
    
    let subLabel: UILabel = {
        let label = UILabel()
        label.text = "Software Engineer"
        label.font = .futuraBook(10)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let sparkButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "button-sparkflirt"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.clipsToBounds = true
        return button
    }()
    
    
    let favoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "button-favorite"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var stackview: UIStackView = {
        let view = UIStackView(arrangedSubviews: [sparkButton, favoriteButton])
        view.spacing = 12
        view.distribution = .fillEqually
        return view
    }()
    
    private let layerView = UIView()

    private func initSubviews() {
        
        //keep image from going out of bounds
        contentView.addSubview(layerView)
        layerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        layerView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        imageView.addGradientLayer(height: 75)
        
        contentView.addSubview(stackview)
        stackview.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(92)
            make.centerY.equalTo(layerView.snp.bottom)
            make.bottom.centerX.equalToSuperview()
        }
        
        contentView.addSubview(subLabel)
        subLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalTo(stackview.snp.top).offset(-5)
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.right.equalTo(subLabel)
            make.bottom.equalTo(subLabel.snp.top)
        }
        
    }
    
    private func bind() {
        sparkButton.addTarget(self, action: #selector(sparkDidTap), for: .touchUpInside)
        favoriteButton.addTarget(self, action: #selector(cancelDidTap), for: .touchUpInside)
    }
    
    @objc private func sparkDidTap() {
        sparkAction?()
    }
    
    @objc private func cancelDidTap() {
        favoriteAction?()
    }
    
    func set(_ match: Match) {
        imageView.kf.setImage(with: URL(string: match.matchedWith?.images.first?.image ?? ""), placeholder: #imageLiteral(resourceName: "profile-placeholder"))
        nameLabel.text = match.matchedWith?.getDisplayNameAge()
        subLabel.text = match.matchedWith?.occupation
        layerView.addShadowLayer()
    }
    
}
