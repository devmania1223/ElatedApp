//
//  FavoritesPageViewController.swift
//  Elated
//
//  Created by Marlon on 2021/3/5.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift

class FavoritesPageViewController: MenuBasePageViewController {

    enum TabIndex : Int {
        case myFavorites
        case peopleWhoFavedMe
    }
    
    let viewModel = MenuPageViewModel()
    private var viewControllerList = [UIViewController]()
    
    private let myFavoritesTab = LineTabView.createCommonTabView("menu.tabview.tab.favorites.subtab.myFavorites",
                                                                 selected: true)
    private let peopleWhoFavedMeTab = LineTabView.createCommonTabView("menu.tabview.tab.favorites.subtab.peopleWhoFaved")
    
    //this will be stretched end to end
    private let blankView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    init(_ title: String) {
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
        viewControllerList = [FavoritesMyViewController(),
                              FavoritesFavedViewController()]
        setViewControllers([viewControllerList[0]], direction: .forward, animated: true, completion: nil)
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        blankView.addShadowLayer()
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        let tabView = UIView()
        tabView.addSubview(myFavoritesTab)
        tabView.addSubview(peopleWhoFavedMeTab)
        view.addSubview(tabView)
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
        
        myFavoritesTab.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
        }
        
        peopleWhoFavedMeTab.snp.makeConstraints { make in
            make.left.equalTo(myFavoritesTab.snp.right)
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
        }
        
    }
    
    func bind() {
        
        myFavoritesTab.selected.map { $0 ? TabIndex.myFavorites.rawValue : nil }
            .bind(to: viewModel.selectedTabIndex)
            .disposed(by: disposeBag)
        
        peopleWhoFavedMeTab.selected.map { $0 ? TabIndex.peopleWhoFavedMe.rawValue : nil }
            .bind(to: viewModel.selectedTabIndex)
            .disposed(by: disposeBag)

        viewModel.selectedTabIndex.subscribe(onNext: { [weak self] index in
            guard let self = self, let index = index else { return }

            switch index {
            case TabIndex.myFavorites.rawValue:
                self.peopleWhoFavedMeTab.selected.accept(false)
                break
            case TabIndex.peopleWhoFavedMe.rawValue:
                self.myFavoritesTab.selected.accept(false)
                break
            default:
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
        
    }

}

extension FavoritesPageViewController: UIPageViewControllerDataSource {
    
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

