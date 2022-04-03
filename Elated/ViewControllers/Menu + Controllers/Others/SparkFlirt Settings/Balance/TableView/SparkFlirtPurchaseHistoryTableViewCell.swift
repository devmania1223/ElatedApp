//
//  SparkFlirtPurchaseHistoryTableViewCell.swift
//  Elated
//
//  Created by Marlon on 5/7/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class SparkFlirtPurchaseHistoryTableViewCell: UITableViewCell {

    static let identifier = "SparkFlirtPurchaseHistoryTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .futuraBook(14)
        label.textColor = .jet
        return label
    }()

    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "September 1, 2021"
        label.font = .futuraBook(12)
        label.textColor = .silver
        return label
    }()
    
    let amountLabel: UILabel = {
        let label = UILabel()
        label.font = .futuraMedium(14)
        label.textColor = .jet
        return label
    }()

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
        
        let stack = UIStackView(arrangedSubviews: [descriptionLabel, dateLabel])
        stack.axis = .vertical
        stack.spacing = 10
        contentView.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(33)
            make.top.bottom.equalToSuperview().inset(15)
        }
        
        contentView.addSubview(amountLabel)
        amountLabel.snp.makeConstraints { make in
            make.top.equalTo(stack)
            make.right.equalToSuperview().inset(33)
        }

    }

    func set(_ data: SparkFlirtPurchaseData) {
        guard data.orderItems.count > 0 else { return }
        descriptionLabel.text = data.orderItems[0].name
        if let convertedPrice = data.orderItems[0].convertedPrice, !convertedPrice.isEmpty {
            amountLabel.text = convertedPrice
        } else {
            amountLabel.text = data.orderItems[0].price
        }
        dateLabel.text = data.date?.stringToPurchaseDate()
    }
    
}
