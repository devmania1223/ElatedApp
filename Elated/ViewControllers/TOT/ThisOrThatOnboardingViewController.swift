//
//  ThisOrThatOnboardingViewController.swift
//  Elated
//
//  Created by Rey Felipe on 7/22/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class ThisOrThatOnboardingViewController: MenuBasePageViewController {
    
    private let viewModel = ToTViewModel()
    
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
        label.font = .futuraMedium(18)
        label.text = ""
        label.numberOfLines = 0
        label.textAlignment = .center
        label.layer.opacity = 0
        return label
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
    
    internal let nextQButton: UIButton = {
        let button = UIButton.createCommonBottomButton("common.next".localized)
        button.isHidden = true
        button.isEnabled = false
        return button
    }()
    
    init(_ title: String? = "") {
        super.init(transitionStyle: .scroll,
                   navigationOrientation: .horizontal,
                   options: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard viewModel.currentQ.value == nil else { return }
        
        viewModel.getOnboardingQuestions() { [weak self] success in
            guard let self = self,
                  success
            else { return }
            
            //TODO: REY remove print code DBG purpose only
            print("total questions: \(self.viewModel.totData.value.count)")
            self.pageControl.numberOfPages = self.viewModel.totData.value.count
            self.showNewQuestion()
        }
    }
    
    override func initSubviews() {
        super.initSubviews()
        view.backgroundColor = .white
        
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(6)
            make.left.right.equalToSuperview().inset(33)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.pageControl.snp.bottom).offset(6)
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
            make.bottom.equalToSuperview().offset(100)
        }
        
        view.addSubview(bubblesView)
        bubblesView.delegate = self
        bubblesView.dataSource = self
        bubblesView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(bottomBackground.snp.top).offset(10)
        }
        
        view.addSubview(nextQButton)
        nextQButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.left.right.equalToSuperview().inset(33)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        bind()
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
    
    func bind() {
        menuButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.present(self.menu, animated: true, completion: nil)
        }.disposed(by: disposeBag)
        
        nextQButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.showNextQuestion()
        }
    }
}

extension ThisOrThatOnboardingViewController: EL_BubblesViewDataSource, EL_BubblesViewDelegate {
    
    func getBubbles() -> MDL_Bubbles {
        var bubbles = MDL_Bubbles(identifier: "", text: "",
                                  bubbles: [MDL_Bubble]())
        let choices = viewModel.currentChoices.value
        for mPreference in choices {
            guard let id = mPreference.id,
                  let text = mPreference.text
            else {
                continue
            }
            bubbles.bubbles.append(MDL_Bubble(identifier: "\(id)", title: text))
        }
        return bubbles
    }
    
    func selectedBubble(bubble: MDL_Bubble?, trigger: EL_BubblesView.BubbleTrigger) {
        guard let bubble = bubble,
              let question = viewModel.currentQ.value
        else { return }
        //TODO: REY remove print code DBG purpose only
        print("BUBBLE POPPED: \(bubble.identifier) TRIGGER: \(trigger)")
        // Check if there is a subset option, if so load it
        let bubbleId = bubble.identifier.intValue
        if viewModel.hasSubset(id: bubbleId) {
            // Load subset options
            bubblesView.initializeBubblesView()
            bubblesView.springAnimation(duration: 1.0, depth: 500)
            return
        }
    
        switch question.kind {
        case .unknown:
            return
        case .one:
            viewModel.sendAnswer(answer: bubble.title, trigger: trigger.rawValue) { [weak self] success in
                guard success,
                      let self = self
                else { return }
                self.showNextQuestion()
            }
        case .many:
            // one or more or all
            viewModel.sendAnswer(answer: bubble.title, trigger: trigger.rawValue) { [weak self] success in
                guard success,
                      let self = self
                else { return }
                
                if self.bubblesView.bubbleViews.isEmpty {
                    // user selected all options
                    self.showNextQuestion()
                } else {
                    self.showNextButton(enable: true, show: true)
                }
            }
        case .orderedChoices:
            //TODO: update this part once BE is implemented to handle ordered choices, now now allow the user to skip this question
            if self.bubblesView.bubbleViews.isEmpty {
                // user selected all options
                self.showNextQuestion()
                self.showNextButton(enable: false, show: true)
            } else {
                showNextButton(enable: true, show: true)
            }
        default:
            return
        }
    }
    
    func dragBubble(bubbleView: EL_BubbleView?, with position: CGFloat) {
        
        guard let bubble = bubbleView else { return }

        if position >= EL_BubblesView.flickRightThreshold {
            animateHeartButton(bubble)
        } else if position <= EL_BubblesView.flickLeftThreshold {
            animateCloseButton(bubble)
        } else {
            animateBothHide()
        }
    }
}

// MARK: - Private Funcstions

extension ThisOrThatOnboardingViewController {
    
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
    
    private func showMoreOptionsScreen() {
        let vc = ThisOrThatMoreQuestionsPopupViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }

    private func showMatchesMoreOptionsScreen() {
        let vc = MatchesMoreQuestionsPopupViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
    
    private func showNewQuestion() {
        guard let question = viewModel.currentQ.value else { return }
        pageControl.currentPage = viewModel.currentQIndex.value
        titleLabel.fadeTransition(1.0)
        //TODO: REY remove print code DBG purpose only
        print("QUESTION - \(viewModel.currentQIndex.value) : \(question.question ?? "") Type: \(question.kind)")
        titleLabel.text = question.question
        titleLabel.layer.opacity = 1
        bubblesView.initializeBubblesView()
        bubblesView.springAnimation(duration: 1.0, depth: 500)
        
        switch question.kind {
        case .height, .longText, .list, .shortText, .other:
            nextQButton.fadeTransition(0.75)
            showNextButton(enable: true, show: true)
        case .many, .orderedChoices:
            nextQButton.fadeTransition(0.75)
            showNextButton(enable: false, show: true)
        default:
            nextQButton.fadeTransition(0.75)
            showNextButton(show: false)
            break
        }
    }
    
    private func showNextQuestion() {
        if viewModel.isAtLastQuestion() {
            if viewModel.isWithinTotThreshold() {
                showMoreOptionsScreen()                
            }else {
                showMatchesMoreOptionsScreen()                
            }

            return
        }
        
        viewModel.nextQuestion()
        showNewQuestion()
    }
    
    private func showNextButton(enable: Bool = false, show: Bool = true) {
        nextQButton.isEnabled = enable
        nextQButton.setTitleColor(enable ? .white : .gray, for: .normal)
        nextQButton.isHidden = !show
    }
}
