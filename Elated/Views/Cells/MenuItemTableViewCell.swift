//
//  MenuItemTableViewCell.swift
//  Elated
//
//  Created by Rey Felipe on 9/29/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class MenuItemTableViewCell: UITableViewCell {
    
    static let identifier = "MenuItemTableViewCell"

    private let logoView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .jet
        label.font = .futuraBook(16)
        return label
    }()
    
    private let arrow: UIImageView = {
        let view = UIImageView(image: #imageLiteral(resourceName: "icon-forward"))
        view.contentMode = .scaleAspectFit
        return view
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
        contentView.addSubview(logoView)
        logoView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(34)
            make.top.bottom.equalToSuperview().inset(24)
            make.width.height.equalTo(24)
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(logoView.snp.right).offset(17)
            make.centerY.equalTo(logoView)
        }
        
        contentView.addSubview(arrow)
        arrow.snp.makeConstraints { make in
            make.left.equalTo(nameLabel.snp.right).offset(17)
            make.right.equalToSuperview().inset(34)
            make.centerY.equalTo(nameLabel)
            make.width.height.equalTo(24)
        }
        
    }
    
    func set(image: UIImage, name: String) {
        logoView.image = image
        nameLabel.text = name
    }

}
