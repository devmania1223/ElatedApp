//
//  EmojiGoTableViewEmojiCell.swift
//  Elated
//
//  Created by Marlon on 9/3/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class EmojiGoTableViewEmojiMeCell: UITableViewCell {

    static let identifier = "EmojiGoTableViewEmojiMeCell"

    private let avatarImageView: UIImageView = {
        let view = UIImageView()
        view.cornerRadius = 20
        view.contentMode = .scaleToFill
        view.clipsToBounds = true
        view.image = #imageLiteral(resourceName: "profile-placeholder")
        return view
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
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

        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.greaterThanOrEqualToSuperview().offset(66)
            make.top.bottom.equalToSuperview().inset(5)
            make.height.greaterThanOrEqualTo(40)
        }
        
        contentView.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.bottom.equalTo(stackView)
            make.left.equalTo(stackView.snp.right).offset(12)
            make.width.height.equalTo(40)
        }
        
        avatarImageView.kf.setImage(with: URL(string: MemCached.shared.userInfo?.profileImages.first?.image ?? ""), placeholder: #imageLiteral(resourceName: "profile-placeholder"))
    }
    
    func set(_ emojiText: String) {
        
        let emojis = emojiText.emojis
        
        for view in stackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        
        for emoji in emojis {
            let button = createButton(emoji: String(emoji))
            stackView.addArrangedSubview(button)
        }
        
    }

    private func createButton(emoji: String) -> UIButton {
        let button = UIButton()
        button.setTitle(emoji, for: .normal)
        button.titleLabel?.font = .futuraBold(23)
        button.cornerRadius = 8
        button.borderWidth = 2
        button.borderColor = .tuftsBlue
        button.backgroundColor = .white
        
        button.snp.makeConstraints { make in
            make.width.equalTo(40)
        }
        
        return button
    }

}
