//
//  BaseViewController.swift
//  Elated
//
//  Created by Marlon on 2021/2/20.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import RxSwift
import RxCocoa

class BaseViewController: UIViewController {

    internal let disposeBag = DisposeBag()

    internal var manageActivityIndicator = PublishRelay<Bool>()

    private var activityIndicator : NVActivityIndicatorView = {
        
        let screenWidth  = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        let frame = CGRect(x: (screenWidth/2) - (50/2),
                           y: (screenHeight/2) - (50/2),
                           width: 50,
                           height: 50)
        
        let activityIndicator = NVActivityIndicatorView(frame: frame,
                                                        type: .ballSpinFadeLoader,
                                                        color: .white)
        
        return activityIndicator
    }()
    
    private lazy var bgView: UIView = {
        let frame = UIScreen.main.bounds
        let view = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.addSubview(activityIndicator)
        return view
    }()
    
    internal func initSubviews() {}
    internal func prepareTooltips() {}
    
    internal func bind() {
        manageActivityIndicator.subscribe(onNext: { [weak self] animate in
            guard let self = self else { return }
            if animate {
                let keyWindow = UIApplication.shared.connectedScenes
                        .filter({$0.activationState == .foregroundActive})
                        .map({$0 as? UIWindowScene})
                        .compactMap({$0})
                        .first?.windows
                        .filter({$0.isKeyWindow}).first
                 
                keyWindow?.addSubview(self.bgView)
                self.activityIndicator.startAnimating()
                self.view.isUserInteractionEnabled = false
                self.navigationController?.navigationBar.isUserInteractionEnabled = false
            } else {
                self.bgView.removeFromSuperview()
                self.activityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
                self.navigationController?.navigationBar.isUserInteractionEnabled = true
            }
        }).disposed(by: disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setNeedsStatusBarAppearanceUpdate()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        view.backgroundColor = .white
        edgesForExtendedLayout = []
        initSubviews()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        prepareTooltips()
    }

}
