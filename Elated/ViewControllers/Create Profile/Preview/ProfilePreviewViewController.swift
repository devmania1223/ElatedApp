//
//  ProfilePreviewViewController.swift
//  Elated
//
//  Created by Rey Felipe on 10/29/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift

class ProfilePreviewViewController: MenuBasePageViewController {

    enum TabIndex : Int {
        case about
        case gallery
        case interests
    }
    
    private let viewModel = MenuPageViewModel()
    private var viewControllerList = [UIViewController]()
        
    private let aboutTab = LineTabView.createCommonTabView("menu.tabview.tab.profile.subtab.about", selected: true)
    private let galleryTab = LineTabView.createCommonTabView("menu.tabview.tab.profile.subtab.gallery")
    private let interestsTab = LineTabView.createCommonTabView("menu.tabview.tab.profile.subtab.interests".localized)
    
    private let editButton = UIBarButtonItem.createEditButton(.elatedPrimaryPurple)

    //this will be stretched end to end
    private let blankView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let bottomBackground = UIImageView(image: #imageLiteral(resourceName: "lower_background"))
    private let nextButton = UIButton.createCommonBottomButton("common.next")
    
    init() {
        super.init(transitionStyle: .scroll,
                   navigationOrientation: .horizontal,
                   options: nil)
        
        viewModel.viewUserId.accept(nil)
        viewControllerList = [ProfileAboutViewController(isOnboarding: true),
                              ProfileGalleryViewController(isOnboarding: true),
                              ProfileInterestViewController(isOnboarding: true)]
        
        
        self.navigationItem.rightBarButtonItem = editButton
        
        setViewControllers([viewControllerList[0]], direction: .forward, animated: true, completion: nil)
        self.title = "profile.preview".localized

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupNavigationBar(.elatedPrimaryPurple,
                                font: .futuraMedium(20),
                                tintColor: .elatedPrimaryPurple,
                                backgroundColor: .white,
                                backgroundImage: nil,
                                addBackButton: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //TODO: Investigate why this doesnt work on viewWillAppear
        blankView.addShadowLayer()
        
        prepareTooltips()
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        self.navigationItem.leftBarButtonItem = nil
        self.setupNavigationBar(.elatedPrimaryPurple,
                                font: .futuraMedium(20),
                                tintColor: .elatedPrimaryPurple,
                                backgroundColor: .white,
                                backgroundImage: nil,
                                addBackButton: false)
        
        let tabView = UIView()
        tabView.addSubview(aboutTab)
        tabView.addSubview(galleryTab)
        tabView.addSubview(interestsTab)
        view.addSubview(blankView)
        blankView.addSubview(tabView)

        blankView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        tabView.snp.makeConstraints { make in
            make.top.height.equalToSuperview()
            make.left.right.equalToSuperview().inset(29.5)
        }
        
        aboutTab.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
        }
        
        galleryTab.snp.makeConstraints { make in
            make.left.equalTo(aboutTab.snp.right)
            make.top.bottom.equalToSuperview()
        }
        
        interestsTab.snp.makeConstraints { make in
            make.left.equalTo(galleryTab.snp.right)
            make.top.bottom.equalToSuperview()
        }
        
        view.addSubview(bottomBackground)
        bottomBackground.snp.makeConstraints { make in
            make.height.equalTo(135)
            make.left.equalToSuperview().offset(-2)
            make.right.bottom.equalToSuperview().offset(2)
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.centerY.equalTo(bottomBackground)
            make.left.right.equalToSuperview().inset(33)
            make.height.equalTo(50)
        }
    }
    
    func bind() {
        
        aboutTab.selected.map { $0 ? TabIndex.about.rawValue : nil }
            .bind(to: viewModel.selectedTabIndex)
            .disposed(by: disposeBag)
        galleryTab.selected.map { $0 ? TabIndex.gallery.rawValue : nil }
            .bind(to: viewModel.selectedTabIndex)
            .disposed(by: disposeBag)
        interestsTab.selected.map { $0 ? TabIndex.interests.rawValue : nil }
            .bind(to: viewModel.selectedTabIndex)
            .disposed(by: disposeBag)
        
        viewModel.selectedTabIndex.subscribe(onNext: { [weak self] index in
            guard let self = self, let index = index else { return }
            switch index {
            case TabIndex.about.rawValue:
                self.galleryTab.selected.accept(false)
                self.interestsTab.selected.accept(false)
                break
            case TabIndex.gallery.rawValue:
                self.aboutTab.selected.accept(false)
                self.interestsTab.selected.accept(false)
                break
            default:
                self.aboutTab.selected.accept(false)
                self.galleryTab.selected.accept(false)
                break
            }
            self.setViewControllers([self.viewControllerList[index]],
                                    direction: index >= self.viewModel.previousTabIndex.value
                                        ? .forward
                                        : .reverse,
                                    animated: true,
                                    completion: { [weak self] _ in
                                        self?.viewModel.previousTabIndex.accept(index)
                                    })
        }).disposed(by: disposeBag)
        
        editButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            let vc = EditProfileViewController()
            vc.hidesBottomBarWhenPushed = true
            self.show(vc, sender: nil)
        }.disposed(by: disposeBag)
        
        nextButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            //Proceed Success Screen
            self.show(CreateProfileSuccessViewController(), sender: nil)
        }
        
    }
    
}

extension ProfilePreviewViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex =  viewControllerList.firstIndex(of: viewController)!
        let priviousIndex = currentIndex - 1
        return priviousIndex < 0 ? nil : viewControllerList[priviousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let currentIndex = viewControllerList.firstIndex(of: viewController)!
        let nextIndex = currentIndex + 1
        return nextIndex > viewControllerList.count - 1 ? nil : viewControllerList[nextIndex]
    }
    
}

//MARK: - Private Methods
extension ProfilePreviewViewController {
    
    private func prepareTooltips() {
        guard let frame = editButton.frame,
              let view = navigationItem.rightBarButtonItem?.view
        else { return }
        
        TooltipManager.shared.reInit()
        let tip = TooltipInfo(tipId: .profilePreviewEdit,
                              direction: .down,
                              parentView: self.view,
                              maxWidth: 150,
                              inView: view,
                              fromRect: frame,
                              offset: 0,
                              duration: 2.5)
        TooltipManager.shared.addTip(tip)
        TooltipManager.shared.showIfNeeded()
    }
    
}
