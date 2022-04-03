//
//  MatchesPageViewController.swift
//  Elated
//
//  Created by Marlon on 2021/3/5.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift

class MatchesPageViewController: MenuBasePageViewController {

    enum TabIndex : Int {
        case bestMatches
        case recentMatches
    }
    
    let viewModel = MenuPageViewModel()
    private var viewControllerList = [UIViewController]()
    
    private let bestMatchesTab = LineTabView.createCommonTabView("menu.tabview.tab.matches.subtab.bestMatches",
                                                                 selected: true)
    private let recentMatchesTab = LineTabView.createCommonTabView("menu.tabview.tab.matches.subtab.recentMatches")
    
    private let tabView = UIView()
    
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

        viewControllerList = [MatchesListViewController(.best), MatchesListViewController(.recent)]
        setViewControllers([viewControllerList[0]], direction: .forward, animated: true, completion: nil)
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        blankView.addShadowLayer()
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        tabView.addSubview(bestMatchesTab)
        tabView.addSubview(recentMatchesTab)
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
        
        bestMatchesTab.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
        }
        
        recentMatchesTab.snp.makeConstraints { make in
            make.left.equalTo(bestMatchesTab.snp.right)
            make.top.bottom.equalToSuperview()
        }
        
    }
    
    func bind() {
        
        bestMatchesTab.selected.map { $0 ? TabIndex.bestMatches.rawValue : nil }
            .bind(to: viewModel.selectedTabIndex)
            .disposed(by: disposeBag)
        recentMatchesTab.selected.map { $0 ? TabIndex.recentMatches.rawValue : nil }
            .bind(to: viewModel.selectedTabIndex)
            .disposed(by: disposeBag)

        viewModel.selectedTabIndex.subscribe(onNext: { [weak self] index in
            guard let self = self, let index = index else { return }

            switch index {
            case TabIndex.bestMatches.rawValue:
                self.recentMatchesTab.selected.accept(false)
                break
            case TabIndex.recentMatches.rawValue:
                self.bestMatchesTab.selected.accept(false)
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

extension MatchesPageViewController: UIPageViewControllerDataSource {
    
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
