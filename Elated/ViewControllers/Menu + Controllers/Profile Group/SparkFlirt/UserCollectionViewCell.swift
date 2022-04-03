//
//  UserCollectionViewCell.swift
//  Elated
//
//  Created by Marlon on 10/30/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "UserCollectionViewCell"
    
    private let avatarImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.cornerRadius = 28
        view.clipsToBounds = true
        view.image = #imageLiteral(resourceName: "profile-placeholder")
        return view
    }()
    
    private let chatIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.cornerRadius = 8.5
        view.borderWidth = 2
        view.borderColor = .white
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .sonicSilver
        label.font = .futuraBook(10)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubViews() {
        
        contentView.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(2)
            make.height.width.equalTo(56)
        }
        
        contentView.addSubview(chatIndicatorView)
        chatIndicatorView.snp.makeConstraints { make in
            make.right.equalTo(avatarImageView)
            make.bottom.equalTo(avatarImageView).offset(3)
            make.width.height.equalTo(17)
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(chatIndicatorView.snp.bottom).offset(2)
            make.left.right.equalTo(avatarImageView)
            make.bottom.equalToSuperview().inset(2)
        }
            
    }
    
    func set(name: String, avatar: URL?, online: Bool) {
        nameLabel.text = name
        avatarImageView.kf.setImage(with: avatar, placeholder: #imageLiteral(resourceName: "profile-placeholder"))
        chatIndicatorView.backgroundColor = online ? .onlineGreen : .red
    }
    
}

