//
//  SparkFlirtInviteSentViewController.swift
//  Elated
//
//  Created by Rey Felipe on 8/2/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class SparkFlirtInviteSentViewController: ScrollViewController {
    
    private let actionButton = UIButton.createCommonBottomButton("common.continue")
    private let bottomBackground = UIImageView(image: #imageLiteral(resourceName: "lower_background"))
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .eerieBlack
        label.font = .futuraMedium(22)
        label.text = "sparkFlirt.first.invite.sent.success.title".localized
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let subLabel: UILabel = {
        let label = UILabel()
        label.textColor = .sonicSilver
        label.font = .futuraBook(14)
        label.textAlignment = .center
        label.text = ""
        label.numberOfLines = 0
        return label
    }()
    
    private let matchImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "profile-placeholder"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 60
        imageView.layer.borderWidth = 0
        return imageView
    }()

    private let sfImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "buttons-sparkflirtyellow-circle"))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.layer.borderWidth = 5
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    public var dismissHandler: (() -> Void)?
    
    init(userInfo: Match) {
        super.init(nibName: nil, bundle: nil)
        
        guard let match = userInfo.matchedWith,
              let me = MemCached.shared.userInfo
        else { return }
        subLabel.text = "sparkFlirt.invite.sent.success.note".localizedFormat(match.getDisplayName())
        
        if !me.firstSparkFlirtSent {
            MemCached.shared.userInfo?.firstSparkFlirtSent = true
        } else {
            titleLabel.text = "sparkFlirt.invite.sent.success.title".localizedFormat(match.getDisplayName())
        }
        
        guard let image = match.images.first?.image else { return }
        let imageUrl = URL(string: image)
        matchImageView.kf.setImage(with: imageUrl)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(40)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(30)
        }
        
        contentView.addSubview(subLabel)
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(40)
        }
        
        contentView.addSubview(matchImageView)
        matchImageView.snp.makeConstraints { make in
            make.top.equalTo(subLabel.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(120)
        }
        
        contentView.addSubview(sfImageView)
        sfImageView.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(matchImageView)
            make.height.width.equalTo(40)
        }
        
        contentView.addSubview(actionButton)
        actionButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(173)
            make.top.equalTo(matchImageView.snp.bottom).offset(40)
            make.bottom.equalToSuperview().offset(-25)
        }
        
        view.addSubview(bottomBackground)
        bottomBackground.snp.makeConstraints { make in
            make.height.equalTo(135)
            make.left.equalToSuperview().offset(-2)
            make.right.equalToSuperview().offset(2)
            make.bottom.equalToSuperview().offset(Util.heigherThanIphone6 ? 2 : 100)
        }
        
        view.bringSubviewToFront(scrollView)
        
        centerContentViewIfNeeded(offset: Util.heigherThanIphone6 ? 133 : 35)
    }
    
    override func bind() {
        super.bind()
        
        actionButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
            self.dismissHandler?()
        }.disposed(by: disposeBag)
    }

}
