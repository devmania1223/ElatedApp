//
//  MenuBasePageViewController.swift
//  Elated
//
//  Created by Marlon on 2021/3/5.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import SideMenu
import RxSwift

class MenuBasePageViewController: UIPageViewController {
    
    internal let disposeBag = DisposeBag()
    internal lazy var menu = self.createMenu(SideMenuViewController.shared)
    internal let menuButton = UIBarButtonItem.createMenuButton()
    
    internal func initSubviews() {
        
        view.backgroundColor = .white
        self.navigationItem.leftBarButtonItem = menuButton
        menuButton.tintColor = .white
        self.setupNavigationBar(.white,
                                font: .futuraMedium(20),
                                tintColor: .white,
                                backgroundImage: #imageLiteral(resourceName: "background-header"),
                                additionalBarHeight: true)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubviews()
    }

}
