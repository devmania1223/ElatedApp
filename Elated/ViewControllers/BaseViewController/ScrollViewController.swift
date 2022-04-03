//
//  ScrollViewController.swift
//  Elated
//
//  Created by Marlon on 2021/2/20.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class ScrollViewController: BaseViewController {

    internal let scrollView = UIScrollView()
    internal let contentView = UIView()
    
    override func initSubviews() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints({ make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        })
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints({ make in
            make.top.bottom.centerX.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width)
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    /// Should be called in initSubview
    func centerContentViewIfNeeded(offset: CGFloat, hasNavBar: Bool = true) {
        scrollView.layoutIfNeeded()
        
        guard scrollView.frame.height - offset > scrollView.contentSize.height else { return }
        
        let navBarHeight = hasNavBar ? navigationController?.navigationBar.frame.height ?? 0.0 : 0.0
        
        let yPosition = (scrollView.frame.size.height - offset - navBarHeight - scrollView.contentSize.height) / 2
        
        contentView.snp.updateConstraints { make in
            make.top.equalTo(yPosition)
        }
    }
}

