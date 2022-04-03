//
//  EmojiGoTableViewTextOtherCell.swift
//  Elated
//
//  Created by Marlon on 9/3/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class EmojiGoTableViewTextOtherCell: UITableViewCell {

    static let identifier = "EmojiGoTableViewTextOtherCell"

    private let avatarImageView: UIImageView = {
        let view = UIImageView()
        view.cornerRadius = 20
        view.contentMode = .scaleToFill
        view.clipsToBounds = true
        view.image = #imageLiteral(resourceName: "profile-placeholder")
        return view
    }()
    
    private let label: PaddingLabel = {
        let label = PaddingLabel()
        label.font = .futuraBook(14)
        label.textColor = .white
        label.backgroundColor = .lavanderFloral
        label.textEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        label.textAlignment = .right
        label.clipsToBounds = true
        label.cornerRadius = 5
        label.numberOfLines = 0
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
        
        backgroundColor = .clear

        contentView.addSubview(label)
        contentView.addSubview(avatarImageView)

        avatarImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.bottom.equalTo(label)
            make.width.height.equalTo(40)
        }
        
        label.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(12)
            make.right.lessThanOrEqualToSuperview().inset(66)
            make.top.bottom.equalToSuperview().inset(5)
            make.height.greaterThanOrEqualTo(40)
        }
        
    }
    
    func set(_ text: String, avatar: URL?) {
        label.text = text
        label.sizeToFit()
        avatarImageView.kf.setImage(with: avatar, placeholder: #imageLiteral(resourceName: "profile-placeholder"))
    }

}
