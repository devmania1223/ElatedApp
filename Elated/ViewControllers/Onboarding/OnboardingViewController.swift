//
//  OnboardingViewController.swift
//  Elated
//
//  Created by John Lester Celis on 1/25/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import Lottie

class OnboardingViewController: UIViewController {
    
    var timer: Timer?
    var runCount = 0
    
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    
    static func instantiate() -> OnboardingViewController {
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "OnboardingViewController") as? OnboardingViewController else {
            fatalError("Cannot instantiate OnboardingViewController")
        }
      return controller
    }
    
    @IBOutlet var scrollView: UIScrollView! {
      didSet {
        self.scrollView.delegate = self
      }
    }
    
    @IBAction func didTapPageControl(_ sender: UIPageControl) {
      let selectedPage = sender.currentPage
      self.scrollView.scrollToPage(index: selectedPage, animated: true, after: 0)
    }
    
    @IBOutlet var pageControl: UIPageControl!
    
    var pages: [OnboardingPageView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.pages = self.createPages()
        self.setupSlideScrollView(pages: self.pages)

        self.pageControl.numberOfPages = self.pages.count
        self.pageControl.currentPage = 0
        self.checkPage()
        view.bringSubviewToFront(self.pageControl)
        
        timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        
    }
    
    @objc func fireTimer() {
        print("Timer fired!")
        self.pageControl.currentPage += 1
        self.scrollView.scrollToPage(index: self.pageControl.currentPage, animated: true, after: 0)

        if self.pageControl.currentPage == 3 {
            timer?.invalidate()
        }
        checkPage()
    }
    
    func checkPage() {
        if self.pageControl.currentPage == 0 {
            self.leftButton.isHidden = true
            self.rightButton.isHidden = false
        } else if self.pageControl.currentPage == 3 {
            self.rightButton.isHidden = true
            self.leftButton.isHidden = false
        } else {
            self.rightButton.isHidden = false
            self.leftButton.isHidden = false
        }
    }
    
    @IBAction func didPressButton(_ sender: UIButton) {
        if sender.tag == 1 {
            self.pageControl.currentPage -= 1
            self.scrollView.scrollToPage(index: self.pageControl.currentPage, animated: true, after: 0)
        } else {
            self.pageControl.currentPage += 1
            self.scrollView.scrollToPage(index: self.pageControl.currentPage, animated: true, after: 0)
        }
        checkPage()
        
        if self.pageControl.currentPage == 3 {
            timer?.invalidate()
        }
    }
    
    
    func createPages() -> [OnboardingPageView] {
        
        let page1: OnboardingPageView = Bundle.main.loadNibNamed("OnboardingPageView", owner: self, options: nil)?.first as! OnboardingPageView
        page1.titleLabel.text = "Enjoy discovering each other through creative play!"
        page1.bodyLabel.text = ""
        page1.bottomLabel.text = "“You can learn more about someone in an hour of play than in a year of conversation.”―Plato"
        page1.animationFile = "discover_generic"
        page1.delegate = self
        page1.getStartedButton.isHidden = true
        page1.setupLottie()
        
        let page2: OnboardingPageView = Bundle.main.loadNibNamed("OnboardingPageView", owner: self, options: nil)?.first as! OnboardingPageView
        page2.titleLabel.text = "Meet"
        page2.bodyLabel.text = "Create your profile and start meeting people"
        page2.bottomLabel.text = ""
        page2.animationFile = "onboarding_account_connect1"
        page2.delegate = self
        page2.getStartedButton.isHidden = true
        page2.setupLottie()
        
        let page3: OnboardingPageView = Bundle.main.loadNibNamed("OnboardingPageView", owner: self, options: nil)?.first as! OnboardingPageView
        page3.titleLabel.text = "Play"
        page3.bodyLabel.text = "Play games to get a better understanding of your potential matches."
        page3.bottomLabel.text = ""
        page3.animationFile = "onboarding_account_connect2"
        page3.delegate = self
        page3.getStartedButton.isHidden = true
        page3.setupLottie()
        
        let page4: OnboardingPageView = Bundle.main.loadNibNamed("OnboardingPageView", owner: self, options: nil)?.first as! OnboardingPageView
        page4.titleLabel.text = "Connect"
        page4.bodyLabel.text = "Unlock chat and start talking on a more personal level."
        page4.bottomLabel.text = ""
        page4.animationFile = "onboarding_account_connect3"
        page4.delegate = self
        page4.getStartedButton.isHidden = false
        page4.setupLottie()


      return [page1, page2, page3, page4]
    }

    func setupSlideScrollView(pages: [OnboardingPageView]) {
      self.scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
      self.scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(pages.count), height: view.frame.height)
      self.scrollView.isPagingEnabled = true

      for i in 0..<pages.count {
        pages[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
        self.scrollView.addSubview(pages[i])
      }
    }
}

extension OnboardingViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
    self.pageControl.currentPage = Int(pageIndex)
  }
}

extension OnboardingViewController: OnboardingPageViewDelegate {
    func didPressGetStarted() {
        timer?.invalidate()
        let landingNav = UINavigationController(rootViewController: CreateProfilePageViewController(addBooks: true, addMusic: true))
        Util.setRootViewController(landingNav)
    }
}
