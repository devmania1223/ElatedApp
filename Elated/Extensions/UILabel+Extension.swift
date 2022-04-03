//
//  UILabel+Extension.swift
//  Elated
//
//  Created by John Lester Celis on 3/24/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

extension UILabel {
    
    func animateText(text: String, characterDelay: TimeInterval = 5.0) {
      self.text = ""
        
      let writingTask = DispatchWorkItem { [weak self] in
        text.forEach { char in
          DispatchQueue.main.async {
            self?.text?.append(char)
          }
          Thread.sleep(forTimeInterval: characterDelay/100)
        }
      }
        
      let queue: DispatchQueue = .init(label: "typespeed", qos: .userInteractive)
      queue.asyncAfter(deadline: .now() + 0.05, execute: writingTask)
    }
    
    func addCharacterSpacing(kernValue: Double) {
        guard let labelText = text, labelText.count > 0  else { return }
        
        let attributedString = NSMutableAttributedString(string: labelText)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length - 1))
        attributedText = attributedString
    }
}
