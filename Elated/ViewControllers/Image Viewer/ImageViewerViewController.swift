//
//  ImageViewerViewController.swift
//  Elated
//
//  Created by Marlon on 5/7/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import Kingfisher

class ImageViewerViewController: BaseViewController {

    init(_ image: UIImage?, url: URL? = nil) {
        super.init(nibName: nil, bundle: nil)
        if let img = image {
            profileImageView.image = img
        }
        
        if let imgUrl = url {
            profileImageView.imageView.kf.setImage(with: imgUrl)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let back: UIButton  = {
        let view = UIButton()
        view.setImage(#imageLiteral(resourceName: "icon-close-circle-small"), for: .normal)
        return view
    }()
    
    private let profileImageView: ZoomImageScrollView  = {
        let view = ZoomImageScrollView(nil)
        view.imageView.contentMode = .scaleAspectFit
        view.imageView.clipsToBounds = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        view.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.height.equalTo(25)
        }
        
        view.addSubview(back)
        back.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.left.equalToSuperview().inset(16)
        }
        
    }
    
    override func bind() {
        super.bind()
        
        back.rx.tap.bind { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }.disposed(by: disposeBag)
    }

}
