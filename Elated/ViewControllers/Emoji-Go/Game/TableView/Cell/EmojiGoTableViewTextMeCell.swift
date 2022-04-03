//
//  EmojiGoTableViewTextCell.swift
//  Elated
//
//  Created by Marlon on 9/3/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class EmojiGoTableViewTextMeCell: UITableViewCell {

    static let identifier = "EmojiGoTableViewTextMeCell"

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
        label.numberOfLines = 0
        label.cornerRadius = 5
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
        label.snp.makeConstraints { make in
            make.left.greaterThanOrEqualToSuperview().offset(66)
            make.top.bottom.equalToSuperview().inset(5)
            make.height.greaterThanOrEqualTo(40)
        }
        
        contentView.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.bottom.equalTo(label)
            make.left.equalTo(label.snp.right).offset(12)
            make.width.height.equalTo(40)
        }
        
        avatarImageView.kf.setImage(with: URL(string: MemCached.shared.userInfo?.profileImages.first?.image ?? ""), placeholder: #imageLiteral(resourceName: "profile-placeholder"))
    }
    
    func set(_ text: String) {
        label.text = text
        label.sizeToFit()
    }

}
