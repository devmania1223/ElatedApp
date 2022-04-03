//
//  ThisOrThatOrderedChoicesViewController.swift
//  Elated
//
//  Created by Rey Felipe on 8/11/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

enum ThisOrThatOrderedChoicesPreference: String, CaseIterable {
    // DBG purpose only
    case rock = "Rock"
    case country = "Country"
    case reggae = "Raggae"
    case pop = "Pop"
    case jazz = "Jazz"
}

class ThisOrThatOrderedChoicesViewController: MenuBasePageViewController {
    
    //TODO: use data model once BE endpoint is implemented
    let selectionSize = BehaviorRelay<Int>(value: 3)
    var data = BehaviorRelay<[ThisOrThatOrderedChoicesPreference]>(value: [])
    
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
        label.text = "What's your music preference?" // "Title here..."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.layer.opacity = 0
        return label
    }()
    
    private let subLabel: UILabel = {
        let label = UILabel()
        label.textColor = .sonicSilver
        label.font = .futuraMedium(12)
        label.text = "What's your #1? Rank them down to your least fav." //"Note here..."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.layer.opacity = 0
        return label
    }()
    
    private let orderedChoicesView: OrderedChoicesCollectionView = {
        let collectionView = OrderedChoicesCollectionView()
        collectionView.layer.opacity = 0
        return collectionView
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
    
    internal let doneButton: UIButton = {
        let button = UIButton.createCommonBottomButton("common.done".localized)
        button.isHidden = true
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
//        data.accept([ToTAnswer(text: "Pop", id: 1),
//                     ToTAnswer(text: "Country", id: 2),
//                     ToTAnswer(text: "Motown", id: 3)])
        selectionSize.accept(5)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bubblesView.dataSource = self
        bubblesView.delegate = self
        bubblesView.initializeBubblesView(tutorialMode: true)
        bubblesView.springAnimation(duration: 1.0, depth: 258)
        
        titleLabel.fadeTransition(1)
        titleLabel.layer.opacity = 1
        subLabel.fadeTransition(1)
        subLabel.layer.opacity = 1
        orderedChoicesView.fadeTransition(1)
        orderedChoicesView.layer.opacity = 1
        
        prepareTooltips()
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
        
        view.addSubview(subLabel)
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(30)
        }
        
        view.addSubview(orderedChoicesView)
        orderedChoicesView.snp.makeConstraints { make in
            make.top.equalTo(subLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(OrderedChoicesCollectionView.cellWidthHeight)
        }
        view.addInteraction(UIDropInteraction(delegate: orderedChoicesView))
        
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
        bubblesView.snp.makeConstraints { make in
            make.top.equalTo(orderedChoicesView.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(bottomBackground.snp.top).offset(10)
        }
        
        view.addSubview(doneButton)
        doneButton.snp.makeConstraints { make in
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
        
        data.bind(to: orderedChoicesView.data).disposed(by: disposeBag)
        selectionSize.bind(to: orderedChoicesView.selectionSize).disposed(by: disposeBag)
        
        orderedChoicesView.didRemove.subscribe(onNext: { [weak self] index in
            guard let self = self else { return }
            self.showDoneButton(false)
            //Restore the bubble here
            self.data.accept(self.orderedChoicesView.data.value)
            let item = self.data.value[index]
            self.data.remove(at: index)
            let _ = self.bubblesView.addOneBubble(bubble: MDL_Bubble(identifier: item.rawValue, title: item.rawValue))
            self.pageControl.currentPage = self.data.value.count - 1
            
        }).disposed(by: disposeBag)
        
        doneButton.rx.tap.bind { [weak self] in
            //TODO: add proper screene here, show profile tab screen for now
            let vc = MenuTabBarViewController()
            vc.selectedIndex = MenuTabBarViewController.MenuIndex.profile.rawValue
            let landingNav = UINavigationController(rootViewController: vc)
            Util.setRootViewController(landingNav)
        }.disposed(by: disposeBag)
    }
}

extension ThisOrThatOrderedChoicesViewController: EL_BubblesViewDataSource, EL_BubblesViewDelegate {
    
    func getBubbles() -> MDL_Bubbles {
        var bubbles = MDL_Bubbles(identifier: "",
                                  text: "",
                                  bubbles: [MDL_Bubble](),
                                  triggers: [.tap])
        for mPreference in ThisOrThatOrderedChoicesPreference.allCases {
            if(!data.value.contains(mPreference)) {
                bubbles.bubbles.append(MDL_Bubble(identifier: mPreference.rawValue, title: mPreference.rawValue))
            }
        }
        return bubbles
    }
    
    func selectedBubble(bubble: MDL_Bubble?, trigger: EL_BubblesView.BubbleTrigger) {
        //TODO: add code here to handle bubble selection
        if let bubble = bubble, let mPreference = ThisOrThatOrderedChoicesPreference(rawValue: bubble.identifier), !data.value.contains(mPreference) {
            data.append(mPreference)
            
            if data.value.count == 1 {
                let tip = TooltipInfo(tipId: .totInstructionShuffle,
                                      direction: .down,
                                      parentView: self.view,
                                      maxWidth: 250,
                                      inView: self.view,
                                      fromRect: orderedChoicesView.frame,
                                      offset: 5,
                                      duration: 3.5)
                TooltipManager.shared.addTip(tip)
                TooltipManager.shared.showIfNeeded()
            }
            pageControl.currentPage = data.value.count - 1

            if data.value.count == selectionSize.value {
                //TODO: User has completed the question
                print("ORDERING COMPLETED BY USER")
                showDoneButton(true)
            }
            
        } else {
            print(">>> Something went wrong with music preference id: ", bubble?.identifier ?? "Unkonwn bubble")
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

// MARK: - Private Functions
extension ThisOrThatOrderedChoicesViewController {
    
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
    
    private func showDoneButton(_ show: Bool) {
        guard doneButton.isHidden == show else { return }
        doneButton.fadeTransition(0.75)
        doneButton.isHidden = !show
    }
    
    private func prepareTooltips() {
        TooltipManager.shared.reInit()
        let tip = TooltipInfo(tipId: .totInstructionReminder,
                              direction: .up,
                              parentView: self.view,
                              maxWidth: 250,
                              inView: self.view,
                              fromRect: bubblesView.frame,
                              offset: -25,
                              duration: 3.5)
        TooltipManager.shared.addTip(tip)
        TooltipManager.shared.showIfNeeded()
    }
}
