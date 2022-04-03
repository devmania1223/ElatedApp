//
//  AddDeleteTableViewCell.swift
//  Elated
//
//  Created by Marlon on 2021/3/12.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher

class AddDeleteTableViewCell: UITableViewCell {
    
    enum ButtonType {
        case add
        case delete
        case display
    }
    
    static let identifier = "AddDeleteTableViewCell"
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.cornerRadius = 20
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .futuraMedium(14)
        label.textColor = .sonicSilver
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let button = UIButton()
    
    //for independent use
    let didTap = PublishRelay<Void>()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubviews()
    }
    
    private func initSubviews() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapView)))
        //Cell will be 70 in height. 5 bottom and top insets
        
        let view = UIView()
        view.layer.cornerRadius = 30
        view.backgroundColor = .palePurplePantone
        contentView.addSubview(view)
        view.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(5)
            make.height.equalTo(60)
        }
        
        view.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(40)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(15)
            make.centerY.equalToSuperview()
        }
        
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.left.greaterThanOrEqualTo(titleLabel.snp.right).offset(13)
            make.right.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
        
    }
    
    func setData(_ image: UIImage, imageURL: URL?, title: String?, type: ButtonType) {
        iconImageView.image = image
        if let url = imageURL {
            iconImageView.kf.setImage(with: url, placeholder: image)
        }
        titleLabel.text = title
        button.setImage(type == .display ? nil : type == .add ? #imageLiteral(resourceName: "icon-add") : #imageLiteral(resourceName: "icon-remove"), for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapView() {
        didTap.accept(())
    }
    
}
