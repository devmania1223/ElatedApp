//
//  ThisOrThatTutorialAnimationViewController.swift
//  Elated
//
//  Created by John Lester Celis on 3/26/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import AMPopTip
import Lottie

enum ThisOrThatTutorialPreference: String, CaseIterable {
    case like = "I like vegetables"
    case hate = "I hate traffic"
    case cring = "I love caring people"
    case hateCorruption = "I hate corruption"
    case support = "I support LGBT"
}

class ThisOrThatTutorialAnimationViewController: BaseViewController {
    
    enum InstructionTag: Int {
        case flickRight
        case flickLeft
        case tap
        case tapHold
        case tapHoldHold
        
        var animation: String {
            switch self {
            case .flickLeft:
                return "flicking-hand-to-left"
            case .flickRight:
                return "flicking-hand-to-right"
            case .tap:
                return "tap-gesture"
            case .tapHold:
                return "tap-hold-release"
            case .tapHoldHold:
                return "tap-hold-longer-and-release"
            }
        }
    }
    
    private let bottomBackground = UIImageView(image: #imageLiteral(resourceName: "lower_background"))
    
    private let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.numberOfPages = 5
        control.currentPage = 0
        control.pageIndicatorTintColor = .lavanderFloral
        control.currentPageIndicatorTintColor = .elatedPrimaryPurple
        control.isUserInteractionEnabled = false
        if #available(iOS 14.0, *) {
            control.preferredIndicatorImage = UIImage.init(systemName: "capsule.fill")
        }
        return control
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .eerieBlack
        label.font = .futuraMedium(22)
        label.text = "this.or.that.tutorial.animation.title1".localized
        label.numberOfLines = 0
        label.textAlignment = .center
        label.layer.opacity = 0
        return label
    }()
    
    private let instructionAnimationView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let popTip: PopTip = {
        let popTip = PopTip()
        popTip.bubbleColor = .elatedPrimaryPurple
        popTip.textColor = .white
        popTip.padding = 10
        popTip.shouldDismissOnTap = true
        popTip.shouldDismissOnTapOutside = true
        popTip.shouldDismissOnSwipeOutside = true
        popTip.font = .futuraMedium(12)
        return popTip
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "button-close"), for: .normal)
        return button
    }()
    
    private let heartButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icon-thisorthat-heart"), for: .normal)
        return button
    }()
    
    private let bubblesView = EL_BubblesView()
    
    var selectedPreferences = [ThisOrThatTutorialPreference]()
    
    private var instruction: InstructionTag = InstructionTag.flickRight
    
    private var isOnboarding = false
    
    init(_ onboarding: Bool = false) {
        super.init(nibName: nil, bundle: nil)
        self.isOnboarding = onboarding
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bubblesView.dataSource = self
        bubblesView.delegate = self
        bubblesView.initializeBubblesView(tutorialMode: true)
        bubblesView.springAnimation(duration: 1.0, depth: 450)
        
        titleLabel.fadeTransition(1.25)
        titleLabel.layer.opacity = 1
        
        // Show flick right instruction
        showInstructionView("this.or.that.tutorial.instruction.flickright".localized)
    }
    
    override func initSubviews() {
        super.initSubviews()
        view.backgroundColor = .white
        
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(10)
            make.left.right.equalToSuperview().inset(33)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(30)
        }
        
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(77)
            make.left.equalToSuperview().inset(-77)
        }
        
        view.addSubview(heartButton)
        heartButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(77)
            make.right.equalToSuperview().inset(-77)
        }
        
        view.addSubview(bottomBackground)
        bottomBackground.snp.makeConstraints { make in
            make.height.equalTo(135) //including offset 2
            make.left.equalToSuperview().offset(-2)
            make.right.equalToSuperview().offset(2)
            make.bottom.equalToSuperview().offset(Util.heigherThanIphone6 ? 2 : 100)
        }
        
        view.addSubview(bubblesView)
        bubblesView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(bottomBackground.snp.top).offset(10)
        }
        
        view.addSubview(instructionAnimationView)
        instructionAnimationView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalToSuperview()
        }
        instructionAnimationView.layer.opacity = 0
    }
    
    func hideHeartButton() {
        heartButton.snp.remakeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(77)
            make.right.equalToSuperview().inset(-77)
        }
        view.layoutIfNeeded()
    }
    
    func hideCloseButton() {
        closeButton.snp.remakeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(77)
            make.left.equalToSuperview().inset(-77)
        }
        view.layoutIfNeeded()
    }
    
    func animateBothHide() {
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            
            self.heartButton.snp.remakeConstraints { (make) in
                make.right.equalToSuperview().inset(-77)
                make.centerY.equalToSuperview()
                make.height.width.equalTo(77)
            }
            
            self.closeButton.snp.remakeConstraints { (make) in
                make.left.equalToSuperview().inset(-77)
                make.centerY.equalToSuperview()
                make.height.width.equalTo(77)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    override func bind() {
        super.bind()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         if let touch = touches.first,
            touch.view == instructionAnimationView {
            popTip.hide()
        }
    }
    
    private func dismissInstructions() {
        UIView.animate(withDuration: 0.5, animations: {
            self.instructionAnimationView.layer.opacity = 0

            guard let bubble = self.bubblesView.bubbleViews.last else { return }
            bubble.subviews.filter { $0.isMember(of: AnimationView.self) }
                .forEach { $0.isHidden = true }
            
        }, completion: { _ in
            
            if self.instruction == InstructionTag.flickRight {
                self.instruction = InstructionTag.flickLeft
            } else if self.instruction == InstructionTag.flickLeft {
                self.instruction = InstructionTag.tap
            } else if self.instruction == InstructionTag.tap {
                self.instruction = InstructionTag.tapHold
            } else if self.instruction == InstructionTag.tapHold {
                self.instruction = InstructionTag.tapHoldHold
            } else {
                self.instructionAnimationView.removeFromSuperview()
            }
        })
    }
}

extension ThisOrThatTutorialAnimationViewController: EL_BubblesViewDataSource, EL_BubblesViewDelegate {
    
    func getBubbles() -> MDL_Bubbles {
        var bubbles = MDL_Bubbles(identifier: "", text: "",
                                  bubbles: [MDL_Bubble](),
                                  triggers: [.flick])
        for mPreference in ThisOrThatTutorialPreference.allCases {
            if(!selectedPreferences.contains(mPreference)) {
                bubbles.bubbles.append(MDL_Bubble(identifier: mPreference.rawValue, title: mPreference.rawValue))
            }
        }
        return bubbles
    }
    
    func selectedBubble(bubble: MDL_Bubble?, trigger: EL_BubblesView.BubbleTrigger) {
        if let bubble = bubble, let mPreference = ThisOrThatTutorialPreference(rawValue: bubble.identifier), !self.selectedPreferences.contains(mPreference) {
            selectedPreferences.append(mPreference)
            
            if selectedPreferences.count == 1 {
                // Show flick left instruction
                showInstructionView("this.or.that.tutorial.instruction.flickleft".localized)
                pageControl.currentPage = 1
                
            } else if selectedPreferences.count == 2 {
                titleLabel.fadeTransition(0.5)
                titleLabel.text = "this.or.that.tutorial.animation.title2".localized
                UIView.animate(withDuration: 0.5) {
                    self.view.layoutIfNeeded()
                }
                bubblesView.bubbles.triggers = [.tap]
                
                // Show tap instruction
                showInstructionView("this.or.that.tutorial.instruction.tap".localized)
                pageControl.currentPage = 2
                
            } else if selectedPreferences.count == 3 {
                titleLabel.fadeTransition(0.5)
                titleLabel.text = "this.or.that.tutorial.animation.title3".localized
                UIView.animate(withDuration: 0.5) {
                    self.view.layoutIfNeeded()
                }
                bubblesView.bubbles.triggers = [.hold]
                
                // Show tap instruction
                showInstructionView("this.or.that.tutorial.instruction.taphold".localized)
                pageControl.currentPage = 3
                
            } else if selectedPreferences.count == 4 {
                titleLabel.fadeTransition(0.5)
                titleLabel.text = "this.or.that.tutorial.animation.title4".localized
                UIView.animate(withDuration: 0.5) {
                    self.view.layoutIfNeeded()
                }
                bubblesView.bubbles.triggers = [.hold]
                
                // Show tap instruction
                showInstructionView("this.or.that.tutorial.instruction.tapholdhold".localized)
                pageControl.currentPage = 4
                
            } else if selectedPreferences.count == 5 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    let vc = ThisOrThatTutorialDoneViewController(self.isOnboarding)
                    vc.modalPresentationStyle = .fullScreen
                    self.show(vc, sender: nil)
                }
            }
            
        } else {
            print(">>> Something went wrong with music preference id: ", bubble?.identifier ?? "Unkonwn bubble")
        }
    }
    
    func dragBubble(bubbleView: EL_BubbleView?, with position: CGFloat) {
        
        guard bubblesView.bubbles.triggers.contains(.flick),
              !instructionAnimationView.layer.isOpaque,
              let bubble = bubbleView
        else { return }

        if position >= EL_BubblesView.flickRightThreshold &&
            instruction == InstructionTag.flickLeft {
            animateHeartButton(bubble)
        } else if position <= EL_BubblesView.flickLeftThreshold && instruction == InstructionTag.tap {
            animateCloseButton(bubble)
        } else {
            animateBothHide()
        }
    }
    
    private func showInstructionView(_ text: String) {
        
        guard let bubble = bubblesView.bubbleViews.last else { return }
        
        bubble.subviews.filter { $0.isMember(of: AnimationView.self) } .forEach {
            guard let animation = $0 as? AnimationView else { return }
            animation.isHidden = false
            animation.animation = AnimationView(name: instruction.animation).animation
            animation.play()
        }
        
        instructionAnimationView.fadeTransition(1.25)
        instructionAnimationView.layer.opacity = 1
        popTip.offset = Util.heigherThanIphone6 ? 25 : -75
        popTip.arrowSize = CGSize(width: 1, height: 0)
        popTip.dismissHandler = { [weak self] popTip in
            guard let self = self else { return }
            self.dismissInstructions()
        }
        popTip.show(text: text,
                    direction: .down,
                    maxWidth: 200,
                    in: view,
                    from: bubblesView.frame,
                    duration: 2.5)
            
    }
}


extension ThisOrThatTutorialAnimationViewController {
    
    func animateHeartButton(_ bubbleView: EL_BubbleView) {
        bubblesView.explodeBubble(bubbleView, trigger: .flickRight)
        UIView.animate(withDuration: 0.1) {  [weak self] in
            guard let self = self else { return }
            self.heartButton.snp.remakeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.height.width.equalTo(77)
                make.right.equalToSuperview().inset(0)
            }
            self.view.layoutIfNeeded()
        } completion: { (finished: Bool) in
            if finished {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.hideHeartButton()
                }
            }
        }
    }
    
    func animateCloseButton(_ bubbleView: EL_BubbleView) {
        bubblesView.explodeBubble(bubbleView, trigger: .flickLeft)
        UIView.animate(withDuration: 0.1) { [weak self] in
            guard let self = self else { return }
            self.closeButton.snp.remakeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.height.width.equalTo(77)
                make.left.equalToSuperview().inset(0)
            }
            self.view.layoutIfNeeded()
        } completion: { (finished: Bool) in
            if finished {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.hideCloseButton()
                }
            }
        }
    }
}
