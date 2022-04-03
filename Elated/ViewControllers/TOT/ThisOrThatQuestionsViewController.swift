//
//  ThisOrThatViewController.swift
//  Elated
//
//  Created by John Lester Celis on 4/8/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class ThisOrThatQuestionsViewController: ScrollViewController {
    let viewModel = ThisOrThatViewModel()
    internal let bottomBackground = UIImageView(image: #imageLiteral(resourceName: "lower_background"))
    var pages: [ThisOrThatQuestionView] = []
    private let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.pageIndicatorTintColor = .pageTintColor
        control.currentPageIndicatorTintColor = .currentPageColor
        return control
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
    
    var bubbles = EL_BubblesView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getThisOrThatQuestions()
        self.scrollView.delegate = self
        self.scrollView.isScrollEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(10)
            make.centerX.equalToSuperview()
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
        
        view.bringSubviewToFront(pageControl)
        view.bringSubviewToFront(heartButton)
        view.bringSubviewToFront(closeButton)
        scrollView.snp.remakeConstraints { make in
            make.top.left.bottom.right.equalToSuperview()
        }
    }
    
    override func bind() {
        super.bind()
        pageControl.rx.controlEvent(.valueChanged).subscribe(onNext:  { [weak self] in
            guard let self = self else { return }
            self.scrollView.scrollToPage(index: self.pageControl.currentPage, animated: true, after: 0)
        }).disposed(by: disposeBag)

        
        viewModel.totData.subscribe(onNext:  { [weak self] thisorthat in
            guard let self = self else { return }
            self.pages = self.createPage(thisorthat)
            self.setupSlideScrollView(pages: self.pages)
            self.pageControl.numberOfPages = self.pages.count
            self.pageControl.currentPage = 0
        }).disposed(by: disposeBag)
        
        
        viewModel.presentAlert.subscribe( onNext: { [weak self] args in
            let (title, message) = args
            self?.presentAlert(title: title, message: message)
        }).disposed(by: disposeBag)
    }
    
    func createPage(_ item: [ThisOrThat]) -> [ThisOrThatQuestionView] {
        var questionPage: [ThisOrThatQuestionView] = []
        for thisorthat in item {
            let page: ThisOrThatQuestionView = Bundle.main.loadNibNamed("ThisOrThatQuestionView", owner: self, options: nil)?.first as! ThisOrThatQuestionView
            page.questionLabel.text = thisorthat.question
            page.choices = thisorthat.totChoices
            page.otherChoices = thisorthat.totOtherChoice
            page.delegate = self
            page.setupView()
            questionPage.append(page)
        }
        
        return questionPage
    }
    
    func setupSlideScrollView(pages: [ThisOrThatQuestionView]) {
      self.scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(pages.count), height: view.frame.height)
      self.scrollView.isPagingEnabled = true

      for i in 0..<pages.count {
        pages[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
        self.scrollView.addSubview(pages[i])
      }
    }
    
    func hideHeartButton() {
        self.heartButton.snp.remakeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(77)
            make.right.equalToSuperview().inset(-77)
        }
        self.view.layoutIfNeeded()
    }
    
    func hideCloseButton() {
        self.closeButton.snp.remakeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(77)
            make.left.equalToSuperview().inset(-77)
        }
        self.view.layoutIfNeeded()
    }
    
    func animateBothHide() {
        UIView.animate(withDuration: 0.5) {
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
    
    
    func animateHeartButton(_ bubbleView: EL_BubbleView) {
        UIView.animate(withDuration: 0.1) {
            self.heartButton.snp.remakeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.height.width.equalTo(77)
                make.right.equalToSuperview().inset(0)
            }
            self.view.layoutIfNeeded()
        } completion: { (finished: Bool) in
            if finished {
                UIView.animate(withDuration: 0.3, animations: {
                    self.bubbles.explodeBubble(bubbleView, trigger: .flickRight)
                    self.view.layoutIfNeeded()
                }, completion: { (finished: Bool) in
                    if finished {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.hideHeartButton()
                        }
                    }
                })
            }
        }
    }

    func animateCloseButton(_ bubbleView: EL_BubbleView) {
        UIView.animate(withDuration: 0.5) {
            self.closeButton.snp.remakeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.height.width.equalTo(77)
                make.left.equalToSuperview().inset(0)
            }
            self.view.layoutIfNeeded()
        } completion: { (finished: Bool) in
            if finished {
                UIView.animate(withDuration: 0.3, animations: {
                    self.bubbles.explodeBubble(bubbleView, trigger: .flickLeft)
                    self.view.layoutIfNeeded()
                }, completion: { (finished: Bool) in
                    if finished {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.hideCloseButton()
                        }
                    }
                })
            }
        }
    }
}


extension ThisOrThatQuestionsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
      let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
      self.pageControl.currentPage = Int(pageIndex)
    }
}

extension ThisOrThatQuestionsViewController: ThisOrThatQuestionViewDelegate {
    func didSelectBubble(_ bubbleView: EL_BubbleView?, with position: CGFloat, bubbles: EL_BubblesView) {
        self.bubbles = bubbles
        if position >= 350 {
            animateHeartButton(bubbleView!)
        } else if position <= 65 {
            animateCloseButton(bubbleView!)
        } else {
            animateBothHide()
        }
    }
    
    func nextPage() {
        let def = UserDefaults.standard
        
        if let pages = def.object(forKey: UserDefaults.Key.totPages) as? Int, pages == self.pageControl.currentPage {
            def.setValue(pages + 10, forKey: UserDefaults.Key.totPages)
            let vc = ThisOrThatMoreQuestionsPopupViewController()
            vc.modalPresentationStyle = .fullScreen
            self.show(vc, sender: nil)
            return
        }
        
        if self.pages.count * Int(0.35) == self.pageControl.currentPage, !def.bool(forKey: UserDefaults.Key.isShowNextTOT)  {
            def.setValue(self.pages.count * Int(0.35) + 10, forKey: UserDefaults.Key.totPages)
            def.setValue(true, forKey: UserDefaults.Key.isShowNextTOT)
            let vc = ThisOrThatMoreQuestionsPopupViewController()
            vc.modalPresentationStyle = .fullScreen
            self.show(vc, sender: nil)
            return
        }
        
        self.scrollView.scrollToPage(index: self.pageControl.currentPage + 1, animated: true, after: 0)
    }
}
