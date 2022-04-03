//
//  HowToUseTableViewCell.swift
//  Elated
//
//  Created by Marlon on 2021/3/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class HowToUseTableViewCell: UITableViewCell {

    static let identifier = "HowToUseTableViewCell"
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .futuraBook(16)
        label.textColor = .jet
        label.textAlignment = .left
        return label
    }()
    
    private let shareImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "icon-share-grey")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let shareLabel: UILabel = {
        let label = UILabel()
        label.text = "howToUse.share".localized
        label.font = .futuraMedium(14)
        label.textColor = .jet
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubviews()
    }
    
    private func initSubviews() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(25)
            make.left.equalToSuperview().inset(32)
            make.height.width.equalTo(24)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(iconImageView)
            make.left.equalTo(iconImageView.snp.right).offset(12)
        }
        
        let stackView = UIStackView(arrangedSubviews: [shareImage, shareLabel])
        stackView.spacing = 6
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerY.equalTo(iconImageView)
            make.left.greaterThanOrEqualTo(titleLabel.snp.right).offset(12)
            make.right.equalToSuperview().inset(32)
        }
        
    }
    
    func set(_ title: String, icon: UIImage) {
        titleLabel.text = title
        iconImageView.image = icon
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
