//
//  EmojiGoLoadingViewController.swift
//  Elated
//
//  Created by Marlon on 9/10/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import Lottie

class EmojiGoLoadingViewController: BaseViewController {

    let viewModel = EmojiGoLoadingViewModel()
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "emojiGoBackground"))
        return imageView
    }()
    
    private lazy var animationEmojiView: AnimationView = {
        let view = AnimationView(name: "emoji-go-loading-logo")
        view.contentMode = .scaleAspectFit
        view.animationSpeed = 1
        view.loopMode = .loop
        view.play()
        return view
    }()
    
    private lazy var animationCircleView: AnimationView = {
        let view = AnimationView(name: "loading-circle-generic")
        view.contentMode = .scaleAspectFit
        view.animationSpeed = 1
        view.loopMode = .loop
        view.play()
        return view
    }()
    
    private let loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "common.loading".localized;
        label.font = .comfortaaBold(14)
        label.textColor = .white
        return label
    }()
    
    private var fallbackViewController: AnyClass? = nil
    
    init(_ id: Int, fallbackViewController: AnyClass? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.fallbackViewController = fallbackViewController
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [weak self] in
            self?.viewModel.getInfo(id)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.hideNavBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(-2)
            make.right.equalToSuperview().offset(2)
        }
    
        view.addSubview(animationCircleView)
        animationCircleView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(100)
        }
        
        animationCircleView.addSubview(animationEmojiView)
        animationEmojiView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(90)
        }
        
        view.addSubview(loadingLabel)
        loadingLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(animationCircleView.snp.bottom)
        }
        
    }
    
    override func bind() {
        super.bind()
        
        viewModel.info.subscribe(onNext: { [weak self] info in
            if info.gameStatus == .completed {
                self?.show(EmojiGoGameCompletedViewController(info, fallbackViewController: self?.fallbackViewController), sender: self)
                return
            }
            self?.show(EmojiGoGameViewController(info), sender: self)
        }).disposed(by: disposeBag)
        
    }

}
