//
//  StoryShareLoadingViewController.swift
//  Elated
//
//  Created by Rey Felipe on 6/29/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import Lottie

class StoryShareLoadingViewController: BaseViewController {
   
    private let viewModel = StoryShareLoadingViewModel()
    
    private let ssBackground = UIImageView(image: #imageLiteral(resourceName: "background-storyshare"))
    
    private let typeWriterBackground: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "asset-storyshare-typewriter-menu"))
        imageView.contentMode = .bottom
        return imageView
    }()
    
    private let loadingAnimationView: AnimationView = {
        let view = AnimationView(name: "storyshare-loading-circle")
        view.contentMode = .scaleAspectFit
        view.loopMode = .loop
        view.backgroundBehavior = .pauseAndRestore
        view.play()
        return view
    }()
    
    private lazy var animationLogoView: AnimationView = {
        let view = AnimationView(name: "storyshare-loading-typewriter")
        view.contentMode = .scaleAspectFit
        view.loopMode = .loop
        view.animationSpeed = 1.5
        view.play()
        return view
    }()
    
    private let loadingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .chestnut
        label.font = .courierPrimeRegular(14)
        label.text = "common.loading".localized
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    init(_ id: Int) {
        super.init(nibName: nil, bundle: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [weak self] in
            self?.viewModel.getInfo(id)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        view.backgroundColor = .white
        
        view.addSubview(ssBackground)
        ssBackground.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        view.addSubview(typeWriterBackground)
        typeWriterBackground.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-25)
        }
        
        view.addSubview(loadingAnimationView)
        loadingAnimationView.snp.makeConstraints { make in
            make.height.width.equalTo(100)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-35)
        }
        
        loadingAnimationView.addSubview(animationLogoView)
        animationLogoView.snp.makeConstraints { make in
            make.height.width.equalTo(80)
            make.center.equalToSuperview()
        }
        
        view.addSubview(loadingLabel)
        loadingLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(loadingAnimationView.snp.bottom).offset(5)
        }
        
    }
    
    override func bind() {
        super.bind()
        
        viewModel.info.subscribe(onNext: { [weak self] info in
            if MemCached.shared.isSelf(id: info.currentPlayerTurn) {
                if (MemCached.shared.isSelf(id: info.inviter?.id) && info.inviterTextColor == nil)
                    || (MemCached.shared.isSelf(id: info.invitee?.id) && info.inviteeTextColor == nil) {
                    self?.navigationController?.show(StoryShareColorPickerViewController(info), sender: nil)
                } else {
                    self?.navigationController?.show(StoryShareGameViewController(info), sender: nil)
                }
            } else {
                self?.navigationController?.show(StoryShareLinesViewController(info), sender: nil)
            }
        }).disposed(by: disposeBag)
        
    }

}
