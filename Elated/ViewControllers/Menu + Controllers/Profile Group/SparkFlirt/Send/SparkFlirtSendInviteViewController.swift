//
//  SparkFlirtSendInviteViewController.swift
//  Elated
//
//  Created by Rey Felipe on 7/23/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import Lottie

class SparkFlirtSendInviteViewController: BaseViewController {
    
    enum BottleIdleKeyFrames: CGFloat {
      case start = 0
      case end = 60
    }

    enum BottlePulldownKeyFrames: CGFloat {
      case start = 89
      case end = 129
    }

    enum BottleRattleKeyFrames: CGFloat {
      case start = 135
      case end = 181
    }

    enum BottleReleaseKeyFrames: CGFloat {
      case start = 250
      case end = 275
    }

    let accountsViewModel = SparkFlirtSettingsBalanceViewModel()
    let viewModel = SparkFlirtCommonViewModel()
    
    private var userInfo: Match?
    private let bottomBackground = UIImageView(image: #imageLiteral(resourceName: "lower_background"))
    
    private let sendButtonSize: CGFloat = 80
    private let sliderHeight: CGFloat = 130
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .eerieBlack
        label.font = .futuraMedium(22)
        label.text = ""
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let subLabel: UILabel = {
        let label = UILabel()
        label.textColor = .sonicSilver
        label.font = .futuraBook(14)
        label.textAlignment = .center
        label.text = "sparkFlirt.send.invite.note".localized
        label.numberOfLines = 0
        return label
    }()
    
    private let bottleAnimationView: AnimationView = {
        let animation = AnimationView(name: "bottle-pulldown-and-release")
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .loop
        animation.backgroundBehavior = .pauseAndRestore
        animation.play()
        return animation
    }()
    
    private let remainingLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .eerieBlack
        label.font = .futuraMedium(16)
        return label
    }()
    
    private let creditStack: UIStackView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "buttons-sparkflirtyellow-circle"))
        image.contentMode = .scaleAspectFit
        let stackView = UIStackView(arrangedSubviews: [image])
        image.snp.makeConstraints { make in
            make.width.height.equalTo(20)
        }
        stackView.spacing = 5
        stackView.alignment = .center
        return stackView
    }()
    
    private let buttonDragView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let pullDownButton: AnimationView = {
        let animation = AnimationView(name: "button-arrow-down")
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .loop
        animation.backgroundBehavior = .pauseAndRestore
        animation.play()
        return animation
    }()
    
    private var buttonCenter: CGPoint = .zero
    private var shouldSendInvite: Bool = false
    
    init(userInfo: Match) {
        super.init(nibName: nil, bundle: nil)
        self.userInfo = userInfo
        titleLabel.text = "sparkFlirt.send.invite.to".localizedFormat(userInfo.matchedWith?.getDisplayName() ?? "")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.setupNavigationBar(.elatedPrimaryPurple,
                                font: .futuraMedium(20),
                                tintColor: .elatedPrimaryPurple,
                                backgroundColor: .white,
                                backgroundImage: nil,
                                addBackButton: true)
        accountsViewModel.getSparkFlirtAvailableCredit()
    }
    
    override func initSubviews() {
        super.initSubviews()
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Util.heigherThanIphone6 ? 10 : 0)
            make.left.right.equalToSuperview().inset(Util.heigherThanIphone6 ? 40 : 30)
        }
        
        view.addSubview(subLabel)
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(Util.heigherThanIphone6 ? 43 : 33)
        }
        
        view.addSubview(bottomBackground)
        bottomBackground.snp.makeConstraints { make in
            make.height.equalTo(135)
            make.left.equalToSuperview().offset(-2)
            make.right.bottom.equalToSuperview().offset(2)
        }
        
        view.addSubview(buttonDragView)
        buttonDragView.snp.makeConstraints { make in
            make.height.equalTo(sliderHeight)
            make.width.equalTo(sendButtonSize)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(sliderHeight - (sendButtonSize / 2))
        }
        
        buttonDragView.addSubview(pullDownButton)
        pullDownButton.snp.makeConstraints { make in
            make.height.width.equalTo(sendButtonSize)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }

        creditStack.addArrangedSubview(remainingLabel)
        view.addSubview(creditStack)
        creditStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(buttonDragView.snp.top)
        }
        
        view.addSubview(bottleAnimationView)
        bottleAnimationView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(40)
            make.top.equalTo(subLabel.snp.bottom)
            make.bottom.equalTo(creditStack.snp.top)
        }
        
        bottleIdleAnimation()
    }
    
    override func bind() {
        super.bind()
        
        viewModel.presentAlert.subscribe( onNext: { [weak self] args in
            let (title, message) = args
            self?.presentAlert(title: title, message: message)
        }).disposed(by: disposeBag)
        
        accountsViewModel.availableCredits.bind { [weak self] credits in
            guard let self = self else { return }
            self.remainingLabel.text = "profile.sparkFlirt.balance.remaining".localizedFormat("\(credits)")
            self.remainingLabel.textColor = credits > 0 ? .elatedPrimaryPurple : .danger
        }
        
        let pan = PanDirectionGestureRecognizer(direction: .vertical(.down),
                                                target: self,
                                                action: #selector(panButton(_:)))
        pan.cancelsTouchesInView = false
        pullDownButton.addGestureRecognizer(pan)
    }
    
    override func prepareTooltips() {
        TooltipManager.shared.reInit()
        let tip = TooltipInfo(tipId: .sparkFlirtPullDownRelease,
                              direction: .down,
                              parentView: self.view,
                              maxWidth: 150,
                              inView: view,
                              fromRect: buttonDragView.frame,
                              offset: -50,
                              duration: 2.5)
        TooltipManager.shared.addTip(tip)
        TooltipManager.shared.showIfNeeded()
    }
}

// MARK: - Bottle Animations
extension SparkFlirtSendInviteViewController {
    
    func bottleIdleAnimation() {
        bottleAnimationView.play(fromFrame: BottleIdleKeyFrames.start.rawValue, toFrame: BottleIdleKeyFrames.end.rawValue, loopMode: .loop)
    }
    
    func bottlePulldownAnimation(progress: CGFloat) {
        let progressRange = BottlePulldownKeyFrames.end.rawValue - BottlePulldownKeyFrames.start.rawValue
        let progressFrame = progressRange * progress
        let currentFrame = progressFrame + BottlePulldownKeyFrames.start.rawValue
          
        bottleAnimationView.currentFrame = currentFrame
    }
    
    func bottleRattleAnimation() {
        bottleAnimationView.play(fromFrame: BottleRattleKeyFrames.start.rawValue, toFrame: BottleRattleKeyFrames.end.rawValue, loopMode: .loop)
    }
    
    func bottleReleaseAnimation() {

        bottleAnimationView.play(fromFrame: BottleReleaseKeyFrames.start.rawValue, toFrame: BottleReleaseKeyFrames.end.rawValue, loopMode: .playOnce) { [weak self] _ in
            guard let self = self,
                  let userInfo = self.userInfo
            else { return }
            // show success screen
            let vc = SparkFlirtInviteSentViewController(userInfo: userInfo)
            vc.dismissHandler = {
                self.navigationController?.popToRootViewController(animated: false)
            }
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func bottleResetAnimation() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut, animations: {
            self.bottleAnimationView.snp.updateConstraints{ make in
                make.bottom.equalTo(self.creditStack.snp.top)
                make.top.equalTo(self.subLabel.snp.bottom)
            }
            self.creditStack.alpha = 1.0
            self.pullDownButton.alpha = 1.0
            self.titleLabel.alpha = 1.0
            self.subLabel.alpha = 1.0
            self.pullDownButton.center = self.buttonCenter // restore button center
        }, completion: { [weak self] _ in
            guard let self = self else { return }
            self.bottleIdleAnimation()
        })
    }
        
}

// MARK: - Actions
extension SparkFlirtSendInviteViewController {
    
    private func sendInvite() {
        guard let user = userInfo else {
            bottleResetAnimation()
            return
        }
        
        viewModel.sendSparkFlirtInvite(user) { [weak self] success in
            guard let self = self else { return }
            if success { // release the bottle
                self.bottleReleaseAnimation()
            } else {
                // On error reset the screen to idle
                self.bottleIdleAnimation()
                self.bottleResetAnimation()
            }
        }
    }

    @objc func panButton(_ pan: UIPanGestureRecognizer) {
        switch pan.state {
        case .began:
            buttonCenter = pullDownButton.center // store old button center
            
            // Hide the Credit label
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                self.creditStack.alpha = 0.0
            }, completion: nil)
        case .cancelled, .failed, .ended:
            
            if shouldSendInvite {
                
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                    self.creditStack.alpha = 0.0
                    self.pullDownButton.alpha = 0.0
                    self.titleLabel.alpha = 0.0
                    self.subLabel.alpha = 0.0
                }, completion: { _ in
                    self.sendInvite()
                })
                
            } else {
                
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                    self.creditStack.alpha = 1.0
                    self.pullDownButton.center = self.buttonCenter // restore button center
                    self.bottlePulldownAnimation(progress: 0)
                    self.bottleAnimationView.snp.updateConstraints{ make in
                        make.bottom.equalTo(self.creditStack.snp.top)
                        make.top.equalTo(self.subLabel.snp.bottom)
                    }
                }, completion: { _ in
                    self.bottleIdleAnimation()
                })
            }
        default:
            let location = pan.location(in: buttonDragView) // get pan location
            let halfButtonSize =  sendButtonSize / 2
            var distance = location.y - buttonCenter.y
            
            shouldSendInvite = false
            
            print("height(\(buttonDragView.frame.height))) at location.y(\(location.y))")
            print("Current distance(\(distance))")
            
            if distance > (sliderHeight - halfButtonSize)  {
                // reached the bottom limit
                distance = sliderHeight - halfButtonSize
                pullDownButton.center.y = sliderHeight
                shouldSendInvite = true
                bottleRattleAnimation()
                
            } else if distance <= 0 {
                // reached the top limit
                distance = 0
                pullDownButton.center.y = buttonCenter.y
                bottleIdleAnimation()
                
            } else {
                
                let progress = ( distance / ( sliderHeight - halfButtonSize ) )
                pullDownButton.center.y = location.y // set button to where finger is
                bottlePulldownAnimation(progress: progress)
                
            }
            bottleAnimationView.snp.updateConstraints{ make in
                make.bottom.equalTo(creditStack.snp.top).offset(distance)
                make.top.equalTo(subLabel.snp.bottom).offset(-distance)
            }
            
        }
    }
}
