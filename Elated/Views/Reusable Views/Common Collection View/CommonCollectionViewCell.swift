//
//  QuickFactsCollectionViewCell.swift
//  Elated
//
//  Created by Marlon on 2021/3/12.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift

class CommonCollectionViewCell: UICollectionViewCell {

    static let identifier = "CommonCollectionViewCell"
    let disposeBag = DisposeBag()
    
    var theme: CommonCollectionView.Theme?
    var edit: (() -> Void)?
    
    var editButtonWidth: Double = 24 {
        didSet {
            editButton.snp.updateConstraints { make in
                make.width.height.equalTo(editButtonWidth)
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        theme = nil
        initSubViews()
    }
    
    private let icon: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.font = .futuraMedium(14)
        label.textColor = .sonicSilver
        return label
    }()
    
    let editButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.setImage(#imageLiteral(resourceName: "icon-remove").withRenderingMode(.alwaysTemplate), for: .normal)
        return button
    }()
    
    private let view: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.backgroundColor = .palePurplePantone
        return view
    }()

    private func initSubViews() {
        
        backgroundColor = .clear
        
        contentView.addSubview(view)
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(30)
        }
        
        view.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.width.height.lessThanOrEqualTo(12)
            make.centerY.equalToSuperview()
        }
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalTo(icon.snp.right).offset(8)
            make.centerY.equalToSuperview()
        }

        view.addSubview(editButton)
        editButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(label.snp.right).offset(12)
            make.right.equalToSuperview().inset(6)
            make.width.height.equalTo(24)
        }
        contentView.bringSubviewToFront(editButton)
    }
    
    func setData(_ image: UIImage? = nil,
                 text: String,
                 isEdit: Bool,
                 selected: Bool = false,
                 backgroundColor: UIColor? = nil) {
        icon.image = image
        label.text = text
        
        label.textColor = selected ? .white : .sonicSilver
        view.backgroundColor = selected ? .elatedPrimaryPurple : .palePurplePantone

        editButton.isHidden = !isEdit
        if isEdit {
            editButton.addTarget(self, action: #selector(editAction), for: .touchUpInside)
        }
        
        editButton.snp.updateConstraints { make in
            make.width.height.equalTo(isEdit ? editButtonWidth : 0)
        }
        
        if let theme = theme {
            label.textColor = theme.textColor
            view.backgroundColor = selected ? .elatedPrimaryPurple : theme.backgroundColor
            view.borderColor = theme.borderColor
            view.borderWidth = theme.borderWidth
        }
        
        if backgroundColor != nil {
            //for conditional color only. not a theme
            view.backgroundColor = backgroundColor!
            
            //TODO: Make more dynamic
            label.textColor = .white
        }
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func editAction() {
        edit?()
    }

}
