//
//  LaunchViewController.swift
//  Elated
//
//  Created by Marlon on 2021/2/22.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import Lottie

class LaunchViewController: BaseViewController {

    @IBOutlet weak var animationView: AnimationView!
    let viewModel = LaunchViewModel()
    @IBOutlet weak var elatedLabel: UILabel! {
        didSet {
            elatedLabel.font = .comfortaaMedium(34)
        }
    }
    var displayLink: CADisplayLink?
    @IBOutlet weak var animationViewXConstraints: NSLayoutConstraint!
    
    //TODO: Perform animations
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLottie()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.gradientBackground(from: .lavanderFloral,
                                to: .darkOrchid,
                                direction: .topToBottom)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 1, animations: {
            self.animationViewXConstraints.constant = -60
            self.view.layoutIfNeeded()
        }) { _ in
            self.elatedLabel.animateText(text: "elated", characterDelay: 15)
            let _ = Timer.scheduledTimer(timeInterval: 2,
                                         target: self,
                                         selector: #selector(self.checkUserStatus),
                                         userInfo: nil,
                                         repeats: false)
        }
    }
    
    func setupLottie() {
      self.setupAnimationView()
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
    
    func setupAnimationView() {
      self.animationView.animation = Animation.named("circle")
      self.animationView.contentMode = .scaleAspectFit
      self.animationView.backgroundBehavior = .pauseAndRestore

      let redValueProvider = ColorValueProvider(Color(r: 1, g: 0.2, b: 0.3, a: 1))
      animationView.setValueProvider(redValueProvider, keypath: AnimationKeypath(keypath: "Switch Outline Outlines.**.Fill 1.Color"))
      self.animationView.setValueProvider(redValueProvider, keypath: AnimationKeypath(keypath: "Checkmark Outlines 2.**.Stroke 1.Color"))
    }
    
    @objc func animationCallback() {
      if self.animationView.isAnimationPlaying {}
    }

    @objc func checkUserStatus() {
        viewModel.initializeUserState()
    }
    
    override func bind() {
        super.bind()
        
        viewModel.logined.subscribe(onNext: { [weak self] user in
            guard let self = self else { return }
            if let user = user {
                if user.isActive == false {
                    
                    self.goToEmailVerification(email: user.email ?? "")
                    
                } else if user.profile?.profileComplete == false {
                    
                    self.gotoOnboarding()
                 
                // TODO: Add this when BE ToT Onboarding qustions is ready for consumption (REY) Need more testing is ToTComplete is properly set
                } else if user.profile?.ToTComplete == false {
                    
                    if !UserDefaults.standard.showOnboardingTOT {
                        
                        self.gotoToTOnboardingTutorial()
                        
                    } else {
                        
                        self.gotoToTOnboardingQuestions()
                        
                    }
                    
                }
                else if user.profile?.phoneNoVerified == false {
                    
                    self.goToOTP()
                    
                } else {
                    
                    self.gotoMenu()
                    
                }
            } else {
                self.gotoLogin()
            }
        }).disposed(by: disposeBag)
        
    }
    
    private func goToOTP() {
        let otpNav = UINavigationController(rootViewController: MobileOTPViewController())
        otpNav.modalPresentationStyle = .fullScreen
        self.present(otpNav, animated: true, completion: nil)
    }
    
    private func gotoLogin() {
        let landingNav = UINavigationController(rootViewController: LandingViewController())
        landingNav.modalPresentationStyle = .fullScreen
        self.present(landingNav, animated: true, completion: nil)
    }

    private func goToEmailVerification(email: String) {
        let landingNav = UINavigationController(rootViewController: SignupConfirmationViewController(email, resend: true))
        landingNav.modalPresentationStyle = .fullScreen
        self.present(landingNav, animated: true, completion: nil)
    }

    private func gotoOnboarding() {
        let landingNav = UINavigationController(rootViewController: CreateProfilePageViewController(addBooks: viewModel.addBooks.value, addMusic: true))
        landingNav.modalPresentationStyle = .fullScreen
        self.present(landingNav, animated: true, completion: nil)
    }

    private func gotoMenu() {
        let landingNav = UINavigationController(rootViewController: MenuTabBarViewController())
        landingNav.modalPresentationStyle = .fullScreen
        self.present(landingNav, animated: true, completion: nil)
    }
    
    private func gotoToTOnboardingTutorial() {
        let landingNav = UINavigationController(rootViewController: ThisOrThatWelcomePageViewController(onboarding: true))
        landingNav.modalPresentationStyle = .fullScreen
        self.present(landingNav, animated: true, completion: nil)
    }
    
    private func gotoToTOnboardingQuestions() {
        //Show the ToT Onboarding questions
        let vc = MenuTabBarViewController([.fromOnboarding])
        vc.selectedIndex = MenuTabBarViewController.MenuIndex.thisOrThat.rawValue
        let landingNav = UINavigationController(rootViewController: vc)
        Util.setRootViewController(landingNav)
    }
    
}

