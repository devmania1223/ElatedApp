//
//  MatchesLoadingViewController.swift
//  Elated
//
//  Created by Rey Felipe on 9/14/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import Lottie

class MatchesLoadingViewController: BaseViewController {
    
    var timer: Timer?
    
    private let bgView = UIImageView(image: #imageLiteral(resourceName: "elated-background-gradient-color"))
    
    private var loadingAnimationView: AnimationView = {
        let view = AnimationView(name: "circle")
        view.contentMode = .scaleAspectFit
        view.backgroundBehavior = .pauseAndRestore
        view.animationSpeed = 3
        view.loopMode = .loop
        view.play()
        return view
    }()
    
    private let elatedImage: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "elated_logo"))
        return imageView
    }()
    
    private let loadingLabel: UILabel = {
        let label = UILabel()
        label.font = .futuraBook(16)
        label.text = "matches.loading".localized
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //TODO: Update the code below to trigger match (if needed) REY
        timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(showMatches), userInfo: nil, repeats: false)
    }

    override func initSubviews() {
        super.initSubviews()
        
        view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(-10)
            make.right.equalToSuperview().offset(10)
            make.top.bottom.equalToSuperview()
        }
                
        view.addSubview(loadingAnimationView)
        loadingAnimationView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(10)
            make.height.width.equalTo(100)
        }
        
        loadingAnimationView.addSubview(elatedImage)
        elatedImage.snp.makeConstraints { make in
            make.height.width.equalTo(30)
            make.center.equalToSuperview()
        }
    
        view.addSubview(loadingLabel)
        loadingLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(loadingAnimationView.snp.bottom)
        }
        
    }
    
    override func bind() {
        super.bind()
    }
    
    @objc private func showMatches() {
        let vc = MenuTabBarViewController()
        vc.selectedIndex = MenuTabBarViewController.MenuIndex.matches.rawValue
        let landingNav = UINavigationController(rootViewController: vc)
        Util.setRootViewController(landingNav)
    }
}
