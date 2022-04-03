//
//  InstagramImagePickerViewController.swift
//  Elated
//
//  Created by Marlon on 6/3/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class InstagramImagePickerViewController: BaseViewController {
    
    let viewModel = InstagramImagePickerViewModel()
    let collectionView = InstagramMediaPickerView()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBar(.white,
                       font: .futuraMedium(20),
                       tintColor: .white,
                       backgroundImage: #imageLiteral(resourceName: "background-header"),
                       addBackButton: true)
        self.title = "Instagram"
        self.viewModel.getMedia()
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    override func bind() {
        super.bind()
        
        viewModel.data.bind(to: collectionView.data).disposed(by: disposeBag)
        
        collectionView.didSelect.subscribe(onNext: { [weak self] data in
            if let nav = self?.navigationController {
                nav.popViewController(animated: true)
            } else {
                self?.dismiss(animated: true, completion: nil)
            }
        }).disposed(by: disposeBag)
        
    }
    
}
