//
//  SparkFlirtChatRoomCollectionTableViewCell.swift
//  Elated
//
//  Created by Marlon on 10/29/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class SparkFlirtChatRoomCollectionTableViewCell: UITableViewCell {

    static let identifier = "SparkFlirtChatRoomCollectionTableViewCell"

    private let avatarImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.cornerRadius = 28
        view.image = #imageLiteral(resourceName: "profile-placeholder")
        view.clipsToBounds = true
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
        label.textColor = .jet
        label.font = .futuraMedium(14)
        return label
    }()
    
    private let previewChatLabel: UILabel = {
        let label = UILabel()
        label.textColor = .sonicSilver
        label.font = .futuraBook(12)
        label.numberOfLines = 2
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .sonicSilver
        label.font = .futuraBook(14)
        label.textAlignment = .right
        return label
    }()
    
    private let badgeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .futuraBook(10)
        label.cornerRadius = 9.5
        label.backgroundColor = .elatedPrimaryPurple
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubviews() {
        selectionStyle = .none
        
        contentView.backgroundColor = .init(hexString: "#FBF8FF")
        
        contentView.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(10)
            make.height.width.equalTo(56)
            make.bottom.equalToSuperview().inset(12)
        }
        
        contentView.addSubview(chatIndicatorView)
        chatIndicatorView.snp.makeConstraints { make in
            make.right.equalTo(avatarImageView)
            make.bottom.equalTo(avatarImageView).offset(3)
            make.width.height.equalTo(17)
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView)
            make.left.equalTo(avatarImageView.snp.right).offset(9)
        }
        
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel)
            make.left.equalTo(nameLabel.snp.right).offset(9)
            make.right.equalToSuperview().inset(15)
        }
        
        contentView.addSubview(previewChatLabel)
        previewChatLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.left.right.equalTo(nameLabel)
        }
        
        contentView.addSubview(badgeLabel)
        badgeLabel.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(10)
            make.right.equalTo(timeLabel)
        }
        
    }
    
    func set(name: String,
             avatar: URL?,
             preview: String,
             time: String,
             online: Bool) {
        
        nameLabel.text = name
        previewChatLabel.text = preview
        timeLabel.text = time.stringToTimeAgo()
        avatarImageView.kf.setImage(with: avatar, placeholder: #imageLiteral(resourceName: "profile-placeholder"))
        chatIndicatorView.backgroundColor = online ? .onlineGreen : .red
    }

}
