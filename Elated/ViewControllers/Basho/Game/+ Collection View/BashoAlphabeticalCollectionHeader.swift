//
//  BashoAlphabeticalCollectionHeaderCollectionReusableView.swift
//  Elated
//
//  Created by Marlon on 8/13/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import SnapKit

class BashoAlphabeticalCollectionHeader: UICollectionReusableView {
    
    static let identifier = "BashoAlphabeticalCollectionHeader"
    
    let label: UILabel = {
        let label = UILabel()
        label.font = .futuraMedium(16)
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubviews() {
        
        addSubview(label)
        label.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview().inset(8)
        }
        
    }
    
}

