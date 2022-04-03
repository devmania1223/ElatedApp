//
//  SparkFlirtChatTextMeTableViewCell.swift
//  Elated
//
//  Created by Marlon on 5/5/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class SparkFlirtChatTextMeTableViewCell: UITableViewCell {

    static let identifier = "SparkFlirtChatTextMeTableViewCell"

    private let textView: UITextView = {
        let textView = UITextView()
        textView.font = .futuraBook(14)
        textView.textColor = .jet
        textView.backgroundColor = .palePurplePantone
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        textView.textAlignment = .right
        textView.clipsToBounds = true
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.roundCorners(radius: 15, corners: [.layerMaxXMinYCorner,
                                                    .layerMinXMinYCorner,
                                                    .layerMinXMaxYCorner])
        textView.isSelectable = false
        return textView
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .silver
        label.font = .futuraBook(12)
        label.text = "2:15pm"
        label.isUserInteractionEnabled = false
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
        contentView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(5)
            make.left.greaterThanOrEqualToSuperview().offset(40)
        }
        
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(3)
            make.right.equalTo(textView)
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    func set(_ message: FirebaseChatMessage) {
        let msg = message.isDeleted ? "chat.message.deleted".localized : message.message
        textView.text = msg
        textView.alpha = message.isDeleted ? 0.6 : 1
        timeLabel.text = message.created.stringToTimeAgo()
        textView.sizeToFit()
    }

}
