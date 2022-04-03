//
//  UIStoryboard+Extensions.swift
//  Elated
//
//  Created by admin on 6/9/20.
//  Copyright © 2020 elatedteam. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    static let thisorthat = UIStoryboard(name: "thisorthat", bundle: nil)
    static let sparkflirt = UIStoryboard(name: "sparkflirt", bundle: nil)
    
    func getVC(name: String) -> UIViewController {
        return self.instantiateViewController(withIdentifier: name)
    }
}
