//
//  GalleryCollectionViewCell.swift
//  Elated
//
//  Created by Marlon on 2021/3/19.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import Kingfisher

class GalleryCollectionViewCell: UICollectionViewCell {

    static let identifier = "GalleryCollectionViewCell"

    var didDelete: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var frameEditButton: UIButton = {
        let view = UIButton()
        view.setImage(#imageLiteral(resourceName: "icon-remove"), for: .normal)
        view.contentMode = .scaleAspectFill
        return view
    }()

    private func initSubViews() {
        
        backgroundColor = .clear
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalToSuperview()
        }
        
        contentView.addSubview(frameEditButton)
        frameEditButton.snp.makeConstraints { make in
            make.bottom.right.equalToSuperview()
        }
        
        contentView.bringSubviewToFront(frameEditButton)
    }
    
    func setData(_ image: URL?, hideDeleteFrame: Bool, type: GalleryCollectionView.CollectionType) {
        
        if let url = image {
            imageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "profile-placeholder"))
        } else {
            imageView.image = #imageLiteral(resourceName: "add-photo")
        }

        let viewing = (type == .view || type == .pureView || hideDeleteFrame)
        
        imageView.layer.cornerRadius = viewing ? 0 :  self.frame.height / 2
        imageView.layer.borderWidth = viewing ? 0 : 3
        imageView.layer.borderColor = viewing ? nil : UIColor.elatedPrimaryPurple.cgColor
        frameEditButton.isHidden = viewing
        
        frameEditButton.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func deleteAction() {
        didDelete?()
    }

}
