//
//  BookCollectionViewCell.swift
//  Elated
//
//  Created by Marlon on 2021/3/12.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import Kingfisher

class BookCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "BookCollectionViewCell"
    
    var didDelete: (() -> Void)?

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.borderColor = .silver
        imageView.borderWidth = 0.25
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icon-remove"), for: .normal)
        return button
    }()
    
    private let titlelabel: UILabel = {
        let label = UILabel()
        label.textColor = .sonicSilver
        label.font = .futuraMedium(10)
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .sonicSilver
        label.font = .futuraBook(10)
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubViews() {
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().priority(.high)
            make.width.equalTo(85)
            make.height.equalTo(125).priority(.high)
            make.bottom.equalToSuperview().inset(61)
        }
        
        contentView.addSubview(button)
        button.snp.makeConstraints { make in
            make.centerX.equalTo(imageView.snp.right)
            make.bottom.equalTo(imageView)
            make.right.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        contentView.addSubview(titlelabel)
        titlelabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.left.right.equalToSuperview()
        }
        
        contentView.addSubview(authorLabel)
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(titlelabel.snp.bottom).offset(4)
            make.left.right.equalToSuperview()
        }
        
        button.addTarget(self, action: #selector(deleteItem), for: .touchUpInside)
    }
    
    @objc private func deleteItem() {
        didDelete?()
    }
    
    func setData(_ image: URL?, title: String, author: String, buttonHide: Bool = false) {
        button.isHidden = buttonHide
        imageView.kf.setImage(with: image)
        titlelabel.text = title
        authorLabel.text = author
    }
    
}

