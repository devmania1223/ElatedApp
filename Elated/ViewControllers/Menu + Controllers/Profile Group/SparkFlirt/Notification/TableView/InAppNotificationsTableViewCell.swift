//
//  InAppNotificationsTableViewCell.swift
//  Elated
//
//  Created by Rey Felipe on 11/15/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class InAppNotificationsTableViewCell: UITableViewCell {

    static let identifier = "InAppNotificationsTableViewCell"
    
    private let senderImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "profile-placeholder"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30
        imageView.layer.borderWidth = 0
        return imageView
    }()
    
    private let notificationType:  UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "buttons-sparkflirtyellow-circle"))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private let notificationLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .futuraMedium(14)
        label.textColor = .jet
        label.numberOfLines = 0
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .futuraBook(12)
        label.textColor = .silver
        return label
    }()
    
    private let unreadImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill")?.withRenderingMode(.alwaysTemplate))
        imageView.tintColor = .elatedPrimaryPurple
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func initSubviews() {
        selectionStyle = .none
        backgroundColor = .white
        
        contentView.addSubview(senderImageView)
        senderImageView.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.left.equalToSuperview().inset(15)
            make.top.bottom.equalToSuperview().inset(5)
        }
        
        contentView.addSubview(notificationType)
        notificationType.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.bottom.trailing.equalTo(senderImageView)
        }
        
        contentView.addSubview(unreadImageView)
        unreadImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(15)
            make.right.equalToSuperview().inset(15)
        }
        
        let stack = UIStackView(arrangedSubviews: [notificationLabel, dateLabel])
        stack.axis = .vertical
        stack.spacing = 5
        contentView.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.left.equalTo(senderImageView.snp.right).offset(10)
            make.right.equalTo(unreadImageView).inset(20)
            make.top.bottom.equalToSuperview().inset(5)
        }
    
    }
    
    func set(_ data: InAppNotificationData) {
        notificationLabel.text = data.message ?? ""
        unreadImageView.isHidden = data.isRead ? true : false
        senderImageView.kf.setImage(with: URL(string: data.sender?.avatar?.image ?? ""), placeholder: #imageLiteral(resourceName: "profile-placeholder"))
        dateLabel.text = data.dateTimeStamp?.stringToTimeAgo(.backend)
        if let type = data.type {
            notificationType.image = UIImage(named: type.getIconImage())
            notificationLabel.text = constructMessage(data)
        }
        
    }
    
}

//MARK: Private methods
extension InAppNotificationsTableViewCell {
    
    private func constructMessage(_ data: InAppNotificationData) -> String {
        guard let type = data.type else { return "" }
        switch type {
        case .gameCanceledEmojiGo:
            return "inapp.notification.messsage.game.canceled.emojigo".localized
        case .gameCompletedEmojiGo:
            return "inapp.notification.messsage.game.completed.emojigo".localized
        case .gameTurnEmojiGo:
            return "inapp.notification.messsage.game.turn.emojigo".localized
        case .favorite:
            return "inapp.notification.messsage.favorites.added".localizedFormat(data.sender?.getDisplayName() ?? "common.someone".localized)
        case .sparkFlirtInvite:
            return  "inapp.notification.messsage.sparkflirt.invite".localizedFormat(data.sender?.getDisplayName() ?? "common.someone".localized)
        case .sparkFlirtInviteAccepted:
            return  "inapp.notification.messsage.sparkflirt.invite.accepted".localizedFormat(data.sender?.getDisplayName() ?? "common.someone".localized)
        default: return "Missing message construct for notification \(type)"
        }
    }
    
}
