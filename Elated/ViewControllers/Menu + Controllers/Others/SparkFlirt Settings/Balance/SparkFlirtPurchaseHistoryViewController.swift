//
//  SparkFlirtPurchaseHistoryViewController.swift
//  Elated
//
//  Created by Rey Felipe on 9/8/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class SparkFlirtPurchaseHistoryViewController: BaseViewController {
    
    let viewModel = SparkFlirtSettingsBalanceViewModel()

    let tableView = SparkFlirtPurchaseHistoryTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "profile.sparkFlirt.purchase.history".localized
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.setupNavigationBar(.white,
                                font: .futuraMedium(20),
                                tintColor: .white,
                                backgroundImage: #imageLiteral(resourceName: "background-header"),
                                additionalBarHeight: true,
                                addBackButton: true)
        
        viewModel.getSparkFlirtPurchaseHistory(initialPage: true)
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalToSuperview()
        }
        
    }
    
    override func bind() {
        super.bind()

        viewModel.manageActivityIndicator.bind(to: manageActivityIndicator).disposed(by: disposeBag)
        
        viewModel.purchases.bind(to: tableView.data).disposed(by: disposeBag)
        
        viewModel.presentAlert.subscribe( onNext: { [weak self] args in
            let (title, message) = args
            self?.presentAlert(title: title, message: message)
        }).disposed(by: disposeBag)
        
        tableView.getMoreResults.subscribe(onNext: { [weak self] index in
            guard let self = self else { return }
            self.viewModel.getSparkFlirtPurchaseHistory()
        }).disposed(by: disposeBag)
    }

}
