//
//  StoryShareTurnBubble.swift
//  Elated
//
//  Created by Marlon on 10/7/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class StoryShareTurnBubble: UIView {
    
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "icon_triangle_reversed").withRenderingMode(.alwaysTemplate)
        return imageView
    }()
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.cornerRadius = 15
        imageView.clipsToBounds = true
        return imageView
    }()

    private let label: PaddingLabel = {
        let label = PaddingLabel()
        label.text = "storyshare.your.turn".localized
        label.paddingLeft = 10
        label.paddingRight = 10
        label.paddingTop = 10
        label.paddingBottom = 10
        label.textColor = .white
        label.font = .courierPrimeBold(12)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 6
        label.numberOfLines = 0
        return label
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.cornerRadius = 6
        return view
    }()
    
    @objc func dismiss() {
        self.removeFromSuperview()
    }
    
    init(dismissable: Bool) {
        
        super.init(frame: .zero)
        
        if dismissable {
            addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
        }
        
        initSubviews()
    }
    
    func updateAppearance(text: String, color: UIColor, avatar: URL?) {
        label.text = text
        containerView.backgroundColor = color
        arrowImageView.tintColor = color
        avatarImageView.kf.setImage(with: avatar, placeholder: #imageLiteral(resourceName: "profile-placeholder"))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initSubviews() {
        
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        containerView.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.height.width.equalTo(30)
            make.left.equalToSuperview().inset(8)
            make.top.bottom.equalToSuperview().inset(12)
        }
        
        containerView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.bottom.equalTo(avatarImageView)
            make.left.equalTo(avatarImageView.snp.right).offset(2)
            make.right.equalToSuperview().inset(25)
        }
        
        addSubview(arrowImageView)
        arrowImageView.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom)
            make.centerX.bottom.equalToSuperview()
            make.height.equalTo(8)
            make.width.equalTo(14)
        }
        
        
    }
    
}
