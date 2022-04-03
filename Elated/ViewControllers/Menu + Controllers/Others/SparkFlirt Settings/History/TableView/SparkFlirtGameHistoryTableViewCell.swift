//
//  SparkFlirtGameHistoryTableViewCell.swift
//  Elated
//
//  Created by Rey Felipe on 11/24/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class SparkFlirtGameHistoryTableViewCell: UITableViewCell {

    static let identifier = "SparkFlirtGameHistoryTableViewCell"
    
    var didSelectProfile: ((Int) -> Void)?
    
    private let playerImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "profile-placeholder"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .futuraMedium(14)
        label.textColor = .jet
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "time ago date here..."
        label.font = .futuraBook(12)
        label.textColor = .silver
        return label
    }()
    
    private let gameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .futuraBook(14)
        label.textColor = .elatedPrimaryPurple
        label.textAlignment = .right
        return label
    }()
    
    private let gameImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "profile-placeholder"))
        imageView.contentMode = .scaleAspectFit
        //imageView.clipsToBounds = true
        return imageView
    }()
    
    private var profileId: Int = 0

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
        
        contentView.addSubview(playerImageView)
        playerImageView.snp.makeConstraints { make in
            make.width.height.equalTo(55)
            make.left.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview().inset(5)
        }
        playerImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnPlayerImage)))
        
        let stack1 = UIStackView(arrangedSubviews: [nameLabel, dateLabel])
        stack1.axis = .vertical
        stack1.spacing = 1.5
        
        let stack2 = UIStackView(arrangedSubviews: [gameLabel, gameImageView])
        stack2.axis = .horizontal
        stack2.spacing = 5
        
        gameImageView.snp.makeConstraints { make in
            make.width.height.equalTo(45)
        }
        
        let stackDetail = UIStackView(arrangedSubviews: [stack1, stack2])
        stackDetail.axis = .horizontal
        stackDetail.spacing = 5
        contentView.addSubview(stackDetail)
        stackDetail.snp.makeConstraints { make in
            make.left.equalTo(playerImageView.snp.right).offset(10)
            make.right.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview().inset(5)
        }
    
    }
    
    func set(_ data: GameDetail) {
        
        let invitee = data.detail?.invitee
        let isInviteeMe = MemCached.shared.isSelf(id: invitee?.id)
        let detail = data.detail
        
        if isInviteeMe {
            playerImageView.kf.setImage(with: URL(string: detail?.inviter?.avatar?.image ?? ""), placeholder: #imageLiteral(resourceName: "profile-placeholder"))
            nameLabel.text = detail?.inviter?.getDisplayName() ?? ""
            profileId = detail?.inviter?.id ?? 0
        } else {
            playerImageView.kf.setImage(with: URL(string: detail?.invitee?.avatar?.image ?? ""), placeholder: #imageLiteral(resourceName: "profile-placeholder"))
            nameLabel.text = detail?.invitee?.getDisplayName() ?? ""
            profileId = detail?.invitee?.id ?? 0
        }
        
        dateLabel.text = data.gameCompleteDatetime?.stringToTimeAgo(.backend) ?? ""
        gameLabel.text = detail?.game?.getTitle() ?? "Unknown"
        gameImageView.image = UIImage(named: detail?.game?.getIconImage() ?? "button-sparkflirt-circle")
        
    }
    
    @objc func didTapOnPlayerImage() {
        didSelectProfile?(profileId)
    }

}
