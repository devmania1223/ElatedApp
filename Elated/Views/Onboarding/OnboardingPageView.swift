//
//  OnboardingPage.swift
//  Elated
//
//  Created by John Lester Celis on 1/25/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import AudioToolbox
import Foundation
import Lottie
import UIKit

protocol OnboardingPageViewDelegate: AnyObject {
  func didPressGetStarted()
}

class OnboardingPageView: UIView {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet var bottomLabel: UILabel!
    @IBOutlet weak var getStartedButton: UIButton!
    
    var animationFile = ""
    var displayLink: CADisplayLink?
    @IBOutlet weak var imageView: UIImageView!
    weak var delegate: OnboardingPageViewDelegate?
    
    override init(frame: CGRect) {
      super.init(frame: frame)
      self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      self.commonInit()
    }

    private func commonInit() {

    }
    
    func setupLottie() {
      self.setupAnimationView(animationFile)
      self.displayLink = CADisplayLink(target: self, selector: #selector(self.animationCallback))
      self.displayLink?.add(
        to: .current,
        forMode: RunLoop.Mode.default
      )

      self.playAnimation()
    }

    func playAnimation() {
      self.animationView.play(
        fromProgress: 0,
        toProgress: 1,
        loopMode: LottieLoopMode.loop,
        completion: { finished in
          if finished {
            print("Animation Finished")
          } else {
            print("Animation Cancelled")
          }
        }
      )
    }

    func setupAnimationView(_ title: String) {
      let animation = Animation.named(title)
      self.animationView.animation = animation
      self.animationView.contentMode = .scaleAspectFit
      self.animationView.backgroundBehavior = .pauseAndRestore

      let redValueProvider = ColorValueProvider(Color(r: 1, g: 0.2, b: 0.3, a: 1))
      animationView.setValueProvider(redValueProvider, keypath: AnimationKeypath(keypath: "Switch Outline Outlines.**.Fill 1.Color"))
      self.animationView.setValueProvider(redValueProvider, keypath: AnimationKeypath(keypath: "Checkmark Outlines 2.**.Stroke 1.Color"))
    }

    @objc func animationCallback() {
      if self.animationView.isAnimationPlaying {}
    }
 
    @IBAction func didPressGetStartedButton(_ sender: Any) {
        self.delegate?.didPressGetStarted()
    }
    
}

extension UIScrollView {
  func scrollToPage(index: Int, animated: Bool, after delay: TimeInterval) {
    let offset = CGPoint(x: CGFloat(index) * frame.size.width, y: 0)
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
      self.setContentOffset(offset, animated: animated)
    }
  }
}
