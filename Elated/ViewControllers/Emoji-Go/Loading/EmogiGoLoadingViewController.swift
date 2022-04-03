//
//  EmogiGoLoadingViewController.swift
//  Elated
//
//  Created by Marlon on 9/10/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import Lottie

class EmogiGoLoadingViewController: BaseViewController {

    let viewModel = Emojigam
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "emojiGoBackground"))
        return imageView
    }()
    
    private lazy var animationView: AnimationView = {
        let view = AnimationView(name: "basho-loading-feather")
        view.contentMode = .scaleAspectFit
        view.animationSpeed = 3
        view.loopMode = .loop
        view.play()
        return view
    }()
    
    private let loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "common.loading.dot.dot".localized;
        label.font = .courierPrimeBoldItalic(16)
        label.textColor = .white
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

        // Do any additional setup after loading the view.
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
            make.edges.equalToSuperview()
        }
        
        view.addSubview(animationView)
        animationView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(200)
        }
        
        view.addSubview(loadingLabel)
        loadingLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(animationView.snp.bottom).inset(40)
        }
        
    }
    
    override func bind() {
        super.bind()
        
        viewModel.info.subscribe(onNext: { [weak self] info in
            self?.show(EmojiGoGameViewController(info), sender: self)
        }).disposed(by: disposeBag)
        
    }

}
