//
//  SparkFlirtSentCollectionViewCell.swift
//  Elated
//
//  Created by Marlon on 5/2/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import Kingfisher

class SparkFlirtSentCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "SparkFlirtSentCollectionViewCell"
    
    var didCancel: (() -> Void)?
    var didNudge: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.cornerRadius = 6
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Marlon B. 27"
        label.font = .futuraMedium(14)
        label.textColor = .white
        label.textAlignment = .center
        label.addShadow()
        label.lineBreakMode = .byTruncatingMiddle
        return label
    }()
    
    let subLabel: UILabel = {
        let label = UILabel()
        label.text = "Software Engineer"
        label.font = .futuraBook(10)
        label.textColor = .white
        label.textAlignment = .center
        label.addShadow()
        return label
    }()
    
    let nudgeButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "button-nudge"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.clipsToBounds = true
        return button
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "button-close"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.clipsToBounds = true
        return button
    }()
    
    lazy var stackview: UIStackView = {
        let view = UIStackView(arrangedSubviews: [nudgeButton, cancelButton])
        view.spacing = 12
        view.distribution = .fillEqually
        return view
    }()
    
    private let layerView = UIView()

    private func initSubviews() {
        
        //keep image from going out of bounds
        contentView.addSubview(layerView)
        layerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        layerView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.addSubview(stackview)
        stackview.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(92)
            make.centerY.equalTo(layerView.snp.bottom)
            make.bottom.centerX.equalToSuperview()
        }
        
        contentView.addSubview(subLabel)
        subLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalTo(stackview.snp.top).offset(-5)
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.right.equalTo(subLabel)
            make.bottom.equalTo(subLabel.snp.top)
        }
        
        
        nudgeButton.addTarget(self, action: #selector(nudgeAction), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
    }
    
    private func setImage(_ imageUrl: String?) {
        imageView.kf.setImage(with: URL(string: imageUrl ?? ""), placeholder: #imageLiteral(resourceName: "profile-placeholder"))
        layerView.addShadowLayer()
    }
    
    func setup(_ userData: SparkFlirtUser?) {
        setImage(userData?.images.first?.image)
        nameLabel.text = userData?.getDisplayNameAge()
        subLabel.text = userData?.occupation ?? ""
    }
    
    // MARK: Actions
    @objc func cancelAction() {
        didCancel?()
    }
    
    @objc func nudgeAction() {
        didNudge?()
    }
}
