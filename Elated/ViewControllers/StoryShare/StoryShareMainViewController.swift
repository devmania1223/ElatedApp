//
//  StoryShareMainViewController.swift
//  Elated
//
//  Created by Rey Felipe on 6/30/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class StoryShareMainViewController: BaseViewController {
    
    private let ssBackground = UIImageView(image: #imageLiteral(resourceName: "background-storyshare"))
    
    private let typeWriterBackground: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "asset-storyshare-typewriter-menu"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .chestnut
        label.font = .courierPrimeRegular(22)
        label.text = "storyshare.title".localized
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton.createCommonBottomButton("common.next")
        button.backgroundColor = .umber
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.hideNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hideNavBar()
    }
    
    override func initSubviews() {
        super.initSubviews()
        guard let typeWriterImage = typeWriterBackground.image else { return }
        
        view.backgroundColor = .white
        
        view.addSubview(ssBackground)
        ssBackground.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }

        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.left.right.equalToSuperview().inset(33)
            make.bottom.equalToSuperview().offset(-40)
        }
    
        // scale the type writer  image based on screen width
        let oldWidth = typeWriterImage.size.width
        let scaleFactor = view.bounds.width / oldWidth
        let newHeight = typeWriterImage.size.height * scaleFactor
        let newWidth = oldWidth * scaleFactor
        view.addSubview(typeWriterBackground)
        typeWriterBackground.snp.makeConstraints { make in
            make.width.equalTo(newWidth)
            make.height.equalTo(newHeight)
            make.bottom.equalTo(nextButton.snp.top).offset(-10)
        }
        
        bind()
    }
    
    override func bind() {
        super.bind()
        nextButton.rx.tap.bind { [weak self] in
            //TODO: update this later, for now juts go back to the How to screen
            let landingNav = UINavigationController(rootViewController: HowToUseViewController())
            Util.setRootViewController(landingNav)
        }.disposed(by: disposeBag)
    }
}
