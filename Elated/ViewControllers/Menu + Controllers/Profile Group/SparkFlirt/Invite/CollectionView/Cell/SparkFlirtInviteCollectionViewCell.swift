//
//  SparkFlirtInviteCollectionViewCell.swift
//  Elated
//
//  Created by Marlon on 5/2/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import Kingfisher

class SparkFlirtInviteCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "SparkFlirtInviteCollectionViewCell"

    var userData: SparkFlirtUser? {
        didSet {
            setImage(userData?.images.first?.image)
            nameLabel.text = userData?.getDisplayNameAge()
            subLabel.text = userData?.occupation ?? ""
        }
    }
    
    var didAccept: (() -> Void)?
    var didDecline: (() -> Void)?
    var didAddToFavorites: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        label.font = .futuraMedium(14)
        label.textColor = .white
        label.textAlignment = .center
        label.addShadow()
        label.lineBreakMode = .byTruncatingMiddle
        return label
    }()
    
    let subLabel: UILabel = {
        let label = UILabel()
        label.text = "Software Engineer"
        label.font = .futuraBook(10)
        label.textColor = .white
        label.textAlignment = .center
        label.addShadow()
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
        
        contentView.addSubview(sparkButton)
        sparkButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.centerY.equalTo(layerView.snp.bottom)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        sparkButton.addTarget(self, action: #selector(acceptAction), for: .touchUpInside)
        
        contentView.addSubview(starButton)
        starButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.right.equalTo(sparkButton.snp.left).offset(-10)
            make.top.equalTo(sparkButton)
        }
        starButton.addTarget(self, action: #selector(addToFavoritesAction), for: .touchUpInside)
        
        contentView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.left.equalTo(sparkButton.snp.right).offset(10)
            make.top.equalTo(sparkButton)
        }
        cancelButton.addTarget(self, action: #selector(declineAction), for: .touchUpInside)
        
        contentView.addSubview(subLabel)
        subLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalTo(sparkButton.snp.top).offset(-5)
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.right.equalTo(subLabel)
            make.bottom.equalTo(subLabel.snp.top)
        }
        
    }
    
    private func setImage(_ imageUrl: String?) {
        imageView.kf.setImage(with: URL(string: imageUrl ?? ""), placeholder: #imageLiteral(resourceName: "profile-placeholder"))
        layerView.addShadowLayer()
    }
    
    // MARK: Actions
    @objc func acceptAction() {
        didAccept?()
    }
    
    @objc func declineAction() {
        didDecline?()
    }
    
    @objc func addToFavoritesAction() {
        didAddToFavorites?()
    }
    
}
