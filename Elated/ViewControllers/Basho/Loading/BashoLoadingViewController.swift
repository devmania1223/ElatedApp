//
//  BashoLoadingViewController.swift
//  Elated
//
//  Created by Marlon on 4/9/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import Lottie

class BashoLoadingViewController: BaseViewController {
    
    private let viewModel = BashoLoadingViewModel()
    
    private lazy var animationFeatherView: AnimationView = {
        let view = AnimationView(name: "basho-loading-feather")
        view.contentMode = .scaleAspectFit
        view.animationSpeed = 2
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
    
    private let topImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "graphic-basho-flowers"))
        imageView.contentMode = .scaleAspectFit
        imageView.layer.opacity = 0.5
        return imageView
    }()
    
    private let bgImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "Basho BG"))
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "common.loading".localized;
        label.font = .futuraMedium(14)
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(-2)
            make.right.equalToSuperview().offset(2)
        }
        
        view.addSubview(topImageView)
        topImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(204)
        }
        
        view.addSubview(animationCircleView)
        animationCircleView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(100)
        }
        
        animationCircleView.addSubview(animationFeatherView)
        animationFeatherView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(95)
        }
        
        view.addSubview(loadingLabel)
        loadingLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(animationCircleView.snp.bottom)
        }
        
    }
    
    override func bind() {
        
        viewModel.info.subscribe(onNext: { [weak self] info in
            if info.gameStatus == .completed {
                self?.show(BashoGameCompletedViewController(info, fallbackViewController: self?.fallbackViewController), sender: self)
                return
            }
            self?.show(BashoLinesViewController(info), sender: self)
        }).disposed(by: disposeBag)
        
    }

}
