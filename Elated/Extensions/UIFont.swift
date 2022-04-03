//
//  UIFont.swift
//  Elated
//
//  Created by Marlon on 2021/2/22.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

extension UIFont {
  open class func futuraBook(_ size: CGFloat) -> UIFont {
    return UIFont(name: "FuturaBT-Book", size: size) ?? .systemFont(ofSize: size)
  }

  open class func futuraBold(_ size: CGFloat) -> UIFont {
    return UIFont(name: "Futura-Bold", size: size) ?? .boldSystemFont(ofSize: size)
  }

  open class func futuraMedium(_ size: CGFloat) -> UIFont {
    return UIFont(name: "Futura-Medium", size: size) ?? .systemFont(ofSize: size)
  }

  open class func futuraLight(_ size: CGFloat) -> UIFont {
    return UIFont(name: "Futura-Light", size: size) ?? .systemFont(ofSize: size)
  }

  open class func europaBold(_ size: CGFloat) -> UIFont {
    return UIFont(name: "Europa-Bold", size: size) ?? .boldSystemFont(ofSize: size)
  }

  open class func sfProSemibold(_ size: CGFloat) -> UIFont {
    return UIFont(name: "SFPro-Semibold", size: size) ?? .boldSystemFont(ofSize: size)
  }

  open class func playFairDisplayBold(_ size: CGFloat) -> UIFont {
    return UIFont(name: "PlayfairDisplay-Bold", size: size) ?? .boldSystemFont(ofSize: size)
  }

  open class func courierPrimeRegular(_ size: CGFloat) -> UIFont {
    return UIFont(name: "CourierPrime-Regular", size: size) ?? .boldSystemFont(ofSize: size)
  }

  open class func courierPrimeItalic(_ size: CGFloat) -> UIFont {
    return UIFont(name: "CourierPrime-Italic", size: size) ?? .boldSystemFont(ofSize: size)
  }

  open class func courierPrimeBold(_ size: CGFloat) -> UIFont {
    return UIFont(name: "CourierPrime-Bold", size: size) ?? .boldSystemFont(ofSize: size)
  }

  open class func courierPrimeBoldItalic(_ size: CGFloat) -> UIFont {
    return UIFont(name: "CourierPrime-BoldItalic", size: size) ?? .boldSystemFont(ofSize: size)
  }

  open class func comfortaaRegular(_ size: CGFloat) -> UIFont {
    return UIFont(name: "Comfortaa-Regular", size: size) ?? .boldSystemFont(ofSize: size)
  }

  open class func comfortaaLight(_ size: CGFloat) -> UIFont {
    return UIFont(name: "Comfortaa-Light", size: size) ?? .boldSystemFont(ofSize: size)
  }

  open class func comfortaaMedium(_ size: CGFloat) -> UIFont {
    return UIFont(name: "Comfortaa-Medium", size: size) ?? .boldSystemFont(ofSize: size)
  }

  open class func comfortaaSemiBold(_ size: CGFloat) -> UIFont {
    return UIFont(name: "Comfortaa-SemiBold", size: size) ?? .boldSystemFont(ofSize: size)
  }

  open class func comfortaaBold(_ size: CGFloat) -> UIFont {
    return UIFont(name: "Comfortaa-Bold", size: size) ?? .boldSystemFont(ofSize: size)
  }
}
