//
//  QuickFactsDetailTableViewTableViewCell.swift
//  Elated
//
//  Created by Marlon on 3/25/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class QuickFactsDetailTableViewCell: UITableViewCell {

    static let identifier = "QuickFactsDetailTableViewCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .futuraBook(14)
        label.textColor = .sonicSilver
        label.textAlignment = .left
        label.minimumScaleFactor = 0.9
        return label
    }()
    
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .futuraMedium(14)
        label.textColor = .jet
        label.textAlignment = .right
        return label
    }()
    
    private let arrow: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "icon-forward").withRenderingMode(.alwaysTemplate))
        imageView.tintColor = .jet
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubviews()
    }
    
    private func initSubviews() {
        backgroundColor = .clear
        selectionStyle = .none
        
        let view = UIView()
        view.layer.borderWidth = 0.25
        view.layer.borderColor = UIColor.silver.cgColor
        view.layer.cornerRadius = 25
        view.backgroundColor = .alabasterSolid
        
        contentView.addSubview(view)
        view.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stackView.distribution = .equalCentering
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(25)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.width.greaterThanOrEqualToSuperview().dividedBy(2).offset(-15)
        }
        
        view.addSubview(arrow)
        arrow.snp.makeConstraints { make in
            make.left.equalTo(stackView.snp.right).offset(2)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
            make.right.equalToSuperview().inset(12)
        }
        
    }
    
    func set(_ title: String, value: String) {
        titleLabel.text = title
        valueLabel.text = value
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
       
    
                  
