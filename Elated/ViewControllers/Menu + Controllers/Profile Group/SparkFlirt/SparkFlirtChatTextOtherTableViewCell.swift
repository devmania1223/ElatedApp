//
//  SparkFlirtChatTextOtherTableViewCell.swift
//  Elated
//
//  Created by Marlon on 5/6/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class SparkFlirtChatTextOtherTableViewCell: UITableViewCell {

    static let identifier = "SparkFlirtChatTextOtherTableViewCell"
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.font = .futuraBook(14)
        textView.textColor = .white
        textView.backgroundColor = .lavanderFloral
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        textView.textAlignment = .left
        textView.clipsToBounds = true
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isSelectable = false
        textView.roundCorners(radius: 15, corners: [.layerMaxXMinYCorner,
                                                    .layerMinXMinYCorner,
                                                    .layerMaxXMaxYCorner])
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
            make.top.left.equalToSuperview().inset(5)
            make.right.lessThanOrEqualToSuperview().inset(40)
        }
        
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(3)
            make.left.equalTo(textView)
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
