//
//  SparkFlirtIceBrokenViewController.swift
//  Elated
//
//  Created by Marlon on 8/14/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import Lottie

class SparkFlirtIceBrokenViewController: BaseViewController {
    
    private let viewModel = SparkFlirtIceBrokenViewModel()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icon-back").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .elatedPrimaryPurple
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "sparkFlirt.iceBroken".localized
        label.font = .futuraMedium(22)
        label.textColor = .eerieBlack
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private var animationViewSuccess: AnimationView = {
        let view = AnimationView(name: "lock-to-unlock")
        view.contentMode = .scaleAspectFit
        view.backgroundBehavior = .pauseAndRestore
        view.loopMode = .loop
        view.animationSpeed = 2
        view.play()
        return view
    }()
    
    private let subLabel: UILabel = {
        let label = UILabel()
        label.text = "sparkFlirt.iceBroken.subtitle".localized
        label.font = .futuraBook(14)
        label.textColor = .sonicSilver
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let bottomBackground = UIImageView(image: #imageLiteral(resourceName: "lower_background"))
    
    init(gameDetail: Any) {
        super.init(nibName: nil, bundle: nil)
        viewModel.gameDetail.accept(gameDetail)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: { [weak self] in
            guard let self = self else { return }
            self.view.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                  action: #selector(self.gotToChat)))
        })
        
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(12)
            make.left.equalToSuperview().inset(8)
            make.height.width.equalTo(35)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(40)
            make.left.right.equalToSuperview().inset(32)
        }
                
        view.addSubview(animationViewSuccess)
        animationViewSuccess.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.width.equalToSuperview().offset(-64)
            make.height.equalTo(view.snp.width).offset(-64)
            make.centerX.equalToSuperview()
        }
        
        view.addSubview(subLabel)
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(animationViewSuccess.snp.bottom).offset(18)
            make.left.right.equalTo(animationViewSuccess).inset(22)
        }
        
        view.addSubview(bottomBackground)
        bottomBackground.snp.makeConstraints { make in
            make.height.equalTo(135) //including offset 2
            make.left.equalToSuperview().offset(-2)
            make.right.bottom.equalToSuperview().offset(2)
        }

    }
    
    override func bind() {
        super.bind()
        
        backButton.rx.tap.bind {
//            if let nav = self?.navigationController {
//                nav.popViewController(animated: true)
//            } else {
//                self?.dismiss(animated: true, completion: nil)
//            }
            let vc = MenuTabBarViewController([.navigateToChat])
            vc.selectedIndex = MenuTabBarViewController.MenuIndex.sparkFlirt.rawValue
            let landingNav = UINavigationController(rootViewController: vc)
            Util.setRootViewController(landingNav)
        }.disposed(by: disposeBag)
        
    }
    
    @objc private func gotToChat() {
        
        guard let gameDetail = viewModel.gameDetail.value else { return }
        
        if let basho = gameDetail as? BashoGameDetail {
            self.show(BashoGameCompletedViewController(basho), sender: nil)
        } else if let storyShare = gameDetail as? StoryShareGameDetail {
            self.show(StoryShareGameCompletedViewController(storyShare), sender: nil)
        } else if let emojiGo = gameDetail as? EmojiGoGameDetail {
            self.show(EmojiGoGameCompletedViewController(emojiGo), sender: nil)
        }
        
    }
    
}

