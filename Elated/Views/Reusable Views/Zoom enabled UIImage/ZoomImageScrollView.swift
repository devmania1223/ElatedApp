//
//  ZoomImageScrollView.swift
//  Elated
//
//  Created by Marlon on 4/28/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class ZoomImageScrollView: UIScrollView {

    let imageView = UIImageView()
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    init(_ image: UIImage?) {
        super.init(frame: .zero)
        delegate = self
        imageView.image = image
        initSubviews()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubviews() {
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.height.equalToSuperview()
        }
        
        minimumZoomScale = 1
        maximumZoomScale = 3
    }
    
    private func bind() {
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(scaleAutomatic))
        doubleTapGesture.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTapGesture)
        
    }
    
    @objc private func scaleAutomatic() {
        self.setZoomScale(self.zoomScale > 1 ? 1 : 2, animated: true)
    }
    
}

extension ZoomImageScrollView: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
}
