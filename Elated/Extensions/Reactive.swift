//
//  Reactive.swift
//  Elated
//
//  Created by Marlon on 2021/2/28.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import WARangeSlider

extension Reactive where Base: UILabel {
    
    /// Bindable sink for `textColor` property.
    public var textColor: Binder<UIColor> {
        return Binder(self.base) { label, textColor in
            label.textColor = textColor
        }
    }
}

extension Reactive where Base: UIButton {
    public var titleColor: Binder<UIColor> {
        return Binder(self.base) { button, titleColor in
            button.setTitleColor(titleColor, for: .normal)
        }
    }
}

extension Reactive where Base: UITextField {
    public var placeholder: Binder<String?> {
        return Binder(self.base) { textField, placeholder in
            textField.placeholder = placeholder
        }
    }
}

extension Reactive where Base: CALayer {
    public var borderColor: Binder<UIColor?> {
        return Binder(self.base) { layer, color in
            layer.borderColor = color?.cgColor
        }
    }
    
    public var borderWidth: Binder<CGFloat?> {
        return Binder(self.base) { layer, width in
            layer.borderWidth = width ?? 0
        }
    }
}

extension Reactive where Base: UIImageView {
    public var tintColor: Binder<UIColor?> {
        return Binder(self.base) { imageView, color in
            imageView.tintColor = color
        }
    }
}

extension Reactive where Base: RangeSlider {
    public var lowerValue: Binder<Double> {
        return Binder(self.base) { slider, value in
            slider.lowerValue = value
        }
    }
    
    public var upperValue: Binder<Double> {
        return Binder(self.base) { slider, value in
            slider.upperValue = value
        }
    }
}
