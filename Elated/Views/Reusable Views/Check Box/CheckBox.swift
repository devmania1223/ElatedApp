//
//  CheckBox.swift
//  Elated
//
//  Created by Marlon on 2021/2/27.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class CheckBox: UIView {
    
    private let disposeBag = DisposeBag()

    private let imageView: UIImageView = {
        let view = UIImageView()
        view.borderColor = .silver
        view.borderWidth = 0.35
        return view
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let checked = BehaviorRelay<Bool>(value: false)
    
    var font: UIFont? = .futuraBook(13) {
        didSet {
            titleLabel.font = font
        }
    }
    
    var textColor: UIColor = .sonicSilver {
        didSet {
            titleLabel.textColor = textColor
        }
    }
    
    var text: String = "" {
        didSet {
            titleLabel.text = text
        }
    }
    
    var hasChecked: Bool {
        get {
            return checked.value
        }
    }
    
    var boxBackgroundColor: UIColor = .clear {
        didSet {
            imageView.backgroundColor = boxBackgroundColor
        }
    }
    
    private var textLeftOffset : Double = 3.0
    
    @objc func tap() {
        checked.accept(!hasChecked)
    }
    
    private func initSubviews() {
        self.addSubview(imageView)
        imageView.snp.makeConstraints({ make in
            make.top.bottom.equalToSuperview().inset(6)
            make.left.equalToSuperview()
            make.width.height.equalTo(18)
        })
        imageView.contentMode = .scaleAspectFit
        
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints({ make in
            make.left.equalTo(imageView.snp.right).offset(textLeftOffset)
            make.centerY.equalTo(imageView.snp.centerY)
            make.right.equalToSuperview()
        })
        titleLabel.text = text
        titleLabel.font = font
        titleLabel.textColor = textColor
    }
    
    private func bind() {
        let checkedImage = #imageLiteral(resourceName: "icon-check").withRenderingMode(.alwaysTemplate)
        checked.map { $0 ? checkedImage : nil }.bind(to: imageView.rx.image).disposed(by: disposeBag)
        checked.map { $0 ? UIColor.elatedPrimaryPurple : UIColor.clear }
            .bind(to: imageView.rx.backgroundColor)
            .disposed(by: disposeBag)
        imageView.tintColor = checked.value ? .sonicSilver : .white
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
    }
    
    init(_ text: String, textLeftOffset: Double = 12) {
        super.init(frame: .zero)
        self.text = text
        self.textLeftOffset = textLeftOffset
        initSubviews()
        bind()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
