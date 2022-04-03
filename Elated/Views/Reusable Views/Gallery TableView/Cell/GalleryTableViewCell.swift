//
//  GalleryTableViewCell.swift
//  Elated
//
//  Created by Marlon on 2021/3/20.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class GalleryTableViewCell: UITableViewCell {

    static let identifier = "GalleryTableViewCell"
    
    private let photoImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.layer.cornerRadius = 20
        imageview.clipsToBounds = true
        imageview.contentMode = .scaleAspectFill
        return imageview
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .futuraBook(16)
        label.text = "0 likes"
        label.textColor = .eerieBlack
        return label
    }()
    
    //TODO: Change image
    private let optionButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icon-edit"), for: .normal)
        return button
    }()
    
    private let mainImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.clipsToBounds = true
        imageview.contentMode = .scaleAspectFill
        return imageview
    }()
    
    private let commentButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icon-comment"), for: .normal)
        //hide for now
        button.isHidden = true
        return button
    }()
    
    private let likeImage = UIImageView(image: #imageLiteral(resourceName: "icons-matches"))
    
    private let likeLabel: UILabel = {
        let label = UILabel()
        label.text = "0 Likes"
        label.font = .futuraBook(16)
        label.textColor = .sonicSilver
        return label
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = .futuraBook(12)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubviews()
    }
    
    private func initSubviews() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(photoImageView)
        photoImageView.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.left.equalTo(16)
            make.height.width.equalTo(40)
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(photoImageView)
            make.left.equalTo(photoImageView.snp.right).offset(12)
        }
        
        contentView.addSubview(optionButton)
        optionButton.snp.makeConstraints { make in
            make.centerY.equalTo(photoImageView)
            make.left.equalTo(nameLabel.snp.right).offset(12)
            make.right.equalToSuperview().inset(16)
        }
        
        contentView.addSubview(mainImageView)
        mainImageView.snp.makeConstraints { make in
            make.top.equalTo(photoImageView.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.width)
        }
        mainImageView.addGradientLayer(height: 75)
        
        contentView.addSubview(commentButton)
        commentButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.bottom.equalTo(mainImageView).inset(12)
            make.height.width.equalTo(25)
        }
        
        contentView.addSubview(likeImage)
        likeImage.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(30)
            make.left.equalToSuperview().inset(16)
            make.width.equalTo(24)
            make.height.equalTo(20)
            make.bottom.equalToSuperview().inset(12)
        }
        
        contentView.addSubview(likeLabel)
        likeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(likeImage)
            make.left.equalTo(likeImage.snp.right).offset(8)
            make.right.equalToSuperview().inset(16)
        }
        
        contentView.addSubview(captionLabel)
        captionLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalTo(mainImageView.snp.bottom).inset(16)
        }
        
    }
    
    func set(_ url: URL?, caption: String?) {
        let name = MemCached.shared.userInfo?.firstName ?? ""
        let profileUrl = URL(string: MemCached.shared.userInfo?.profileImages.first?.image ?? "")
        photoImageView.kf.setImage(with: profileUrl, placeholder: #imageLiteral(resourceName: "profile-placeholder"))
        nameLabel.text = name
        mainImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "profile-placeholder"))
        captionLabel.text = caption ?? ""
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
