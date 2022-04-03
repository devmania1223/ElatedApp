//
//  CommonTableViewTextCell.swift
//  Elated
//
//  Created by Marlon on 2021/3/2.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class CommonTableViewTextCell: UITableViewCell {
    
    static let identifier = "CommonTableViewTextCell"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .futuraBook(16)
        label.textColor = .white
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubviews()
    }
    
    private func initSubviews() {
        contentView.addSubview(titleLabel)
        backgroundColor = .clear
        selectionStyle = .none
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(15)
            make.left.right.equalToSuperview().inset(23)
        }
    }
    
    func set(_ title: String, textColor: UIColor = .white) {
        titleLabel.text = title
        titleLabel.textColor = textColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
