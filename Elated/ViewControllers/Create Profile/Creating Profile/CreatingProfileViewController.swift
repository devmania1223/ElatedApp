//
//  CreatingProfileViewController.swift
//  Elated
//
//  Created by Marlon on 6/9/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import Lottie

class CreatingProfileViewController: BaseViewController {

    let viewModel = CreatingProfileViewModel()
    
    var timer: Timer?
    
    private let bgView = UIImageView(image: #imageLiteral(resourceName: "elated-background-gradient-color"))
    private let elatedImageView = UIImageView(image: #imageLiteral(resourceName: "elated_logo"))
    
    private var loadingAnimationView: AnimationView = {
        let view = AnimationView(name: "loading-circle-generic")
        view.contentMode = .scaleAspectFit
        view.backgroundBehavior = .pauseAndRestore
        view.loopMode = .loop
        view.play()
        return view
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .futuraBook(16)
        label.text = "createProfile.final.message".localized
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.hideNavBar()
        timer = Timer.scheduledTimer(timeInterval: 4, target: viewModel, selector: #selector(viewModel.completeProfile), userInfo: nil, repeats: false)
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
            make.centerY.equalToSuperview().offset(-32)
            make.height.width.equalTo(100)
        }
        
        loadingAnimationView.addSubview(elatedImageView)
        elatedImageView.snp.makeConstraints { make in
            make.width.height.equalTo(35)
            make.center.equalToSuperview()
        }
    
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(loadingAnimationView.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(33)
        }
        
    }
    
    override func bind() {
        super.bind()
        
        viewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)
        viewModel.presentRetry.subscribe(onNext: { [weak self] in
            self?.presentAlert(title: "",
                               message: (!NetworkManager.isConnectedToInternet
                                ? "common.internetError"
                                : "common.error.somethingWentWrong").localized,
                               buttonTitles: ["common.retry".localized],
                               highlightedButtonIndex: 0,
                               completion: { index in
                                self?.viewModel.completeProfile()
                                
            })
        }).disposed(by: disposeBag)
        
        viewModel.success.subscribe(onNext: { _ in

            //Show Profile Preview Screen
            let landingNav = UINavigationController(rootViewController: ProfilePreviewViewController())
            landingNav.modalPresentationStyle = .fullScreen
            landingNav.modalTransitionStyle = .crossDissolve
            Util.setRootViewController(landingNav)

        }).disposed(by: disposeBag)

    }
   
}
