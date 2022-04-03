//
//  SparkFlirtChatImageOtherTableViewCell.swift
//  Elated
//
//  Created by Marlon on 5/6/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class SparkFlirtChatImageOtherTableViewCell: UITableViewCell {
    
    static let identifier = "SparkFlirtChatImageOtherTableViewCell"

    private let mImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.cornerRadius = 15
        imageView.clipsToBounds = true
        return imageView
    }()
        
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .silver
        label.font = .futuraBook(12)
        label.text = "2:15pm"
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
        contentView.addSubview(mImageView)
        mImageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(5)
            make.width.equalTo(150)
            make.height.equalTo(200)
        }
        
        contentView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(mImageView.snp.bottom).offset(3)
            make.left.equalTo(mImageView)
            make.bottom.equalToSuperview().inset(10)
        }
        
    }
    
    func set(url: URL?, time: String) {
        mImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "profile-placeholder"))
        timeLabel.text = time.stringToTimeAgo()
    }

}
