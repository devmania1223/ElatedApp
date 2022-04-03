//
//  ProfileViewController.swift
//  Elated
//
//  Created by Marlon on 2021/3/2.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift

class ProfilePageViewController: MenuBasePageViewController {

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
    
    private let editButton = UIBarButtonItem.createEditButton(.white)

    //this will be stretched end to end
    private let blankView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    init(_ title: String, viewUserID: Int?) {
        super.init(transitionStyle: .scroll,
                   navigationOrientation: .horizontal,
                   options: nil)
        
        viewModel.viewUserId.accept(viewUserID)
        viewControllerList = [ProfileAboutViewController(userId: viewUserID),
                              ProfileGalleryViewController(userId: viewUserID)]
        
        if viewUserID != nil {
            //viewing
            //hide interest since there's no exposed api to get other user's interests
            interestsTab.alpha = 0
            interestsTab.isUserInteractionEnabled = false
        } else {
            viewControllerList.append(ProfileInterestViewController(userId: viewUserID))
            self.navigationItem.rightBarButtonItem = editButton
        }

        setViewControllers([viewControllerList[0]], direction: .forward, animated: true, completion: nil)
        self.title = title

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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //TODO: Investigate why this doesnt work on viewWillAppear
        blankView.addShadowLayer()
        
        prepareTooltips()
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        if viewModel.viewUserId.value != nil {
            //viewing
            self.setupNavigationBar(.white,
                                    font: .futuraMedium(20),
                                    tintColor: .white,
                                    backgroundImage: #imageLiteral(resourceName: "background-header"),
                                    addBackButton: true)
        }
        
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
        
        menuButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            self.present(self.menu, animated: true, completion: nil)
        }.disposed(by: disposeBag)
        
        editButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            let vc = EditProfileViewController()
            vc.hidesBottomBarWhenPushed = true
            self.show(vc, sender: nil)
        }.disposed(by: disposeBag)
        
    }
    
}

extension ProfilePageViewController: UIPageViewControllerDataSource {
    
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
extension ProfilePageViewController {
    
    private func prepareTooltips() {
        guard let frame = editButton.frame,
              let view = navigationItem.rightBarButtonItem?.view
        else { return }
    
        TooltipManager.shared.reInit()
        let tip = TooltipInfo(tipId: .profileEdit,
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
