//
//  SparkFlirtPageViewController.swift
//  Elated
//
//  Created by Marlon on 2021/3/5.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift

class SparkFlirtPageViewController: MenuBasePageViewController {

    enum TabIndex : Int {
        case invites
        case sent
        case sparkFlirt
        case chat
    }

    let viewModel = MenuPageViewModel()
    let notificationViewModel = InAppNotificationsViewModel()
    private var viewControllerList = [UIViewController]()
    
    private let invitesTab = LineTabView.createCommonTabView("menu.tabview.tab.sparkFlirt.subtab.invites")
    private let sentTab = LineTabView.createCommonTabView("menu.tabview.tab.sparkFlirt.subtab.sent")
    private let sparkFlirtTab = LineTabView.createCommonTabView("menu.tabview.tab.sparkFlirt.subtab.sparkFlirt")
    private let chatTab = LineTabView.createCommonTabView("menu.tabview.tab.sparkFlirt.subtab.chat")
    
    //TODO: chance to white icon once PR: 274 is merged
    private let notificationButton = UIBarButtonItem.createNotificationButton()
    
    //this will be stretched end to end
    private let blankView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    init(_ title: String, initialTab: TabIndex) {
        super.init(transitionStyle: .scroll,
                   navigationOrientation: .horizontal,
                   options: nil)
        viewControllerList = [SparkFlirtInvitesViewController(),
                              SparkFlirtSentViewController(),
                              SparkFlirtActiveViewController(),
                              SparkFlirtChatRoomCollectionViewController()]
        setViewControllers([viewControllerList[initialTab.rawValue]],
                           direction: .forward, animated: true, completion: nil)
        
        invitesTab.selected.accept(initialTab == .invites)
        sentTab.selected.accept(initialTab == .sent)
        sparkFlirtTab.selected.accept(initialTab == .sparkFlirt)
        chatTab.selected.accept(initialTab == .chat)
        self.title = title
        
        self.navigationItem.rightBarButtonItem = notificationButton
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
        
        notificationViewModel.getTotalUnreadNotificationCounter()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        blankView.addShadowLayer()
    }
    
    override func initSubviews() {
        super.initSubviews()
        
        let tabView = UIView()
        tabView.addSubview(invitesTab)
        tabView.addSubview(sentTab)
        tabView.addSubview(sparkFlirtTab)
        tabView.addSubview(chatTab)
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
        
        invitesTab.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
        }
        
        sentTab.snp.makeConstraints { make in
            make.left.equalTo(invitesTab.snp.right)
            make.top.bottom.equalToSuperview()
        }
        
        sparkFlirtTab.snp.makeConstraints { make in
            make.left.equalTo(sentTab.snp.right)
            make.top.bottom.equalToSuperview()
        }
        
        chatTab.snp.makeConstraints { make in
            make.left.equalTo(sparkFlirtTab.snp.right)
            make.top.bottom.equalToSuperview()
        }
        
    }
    
    func bind() {
        
        invitesTab.selected.map { $0 ? TabIndex.invites.rawValue : nil }
            .bind(to: viewModel.selectedTabIndex)
            .disposed(by: disposeBag)
        sentTab.selected.map { $0 ? TabIndex.sent.rawValue : nil }
            .bind(to: viewModel.selectedTabIndex)
            .disposed(by: disposeBag)
        sparkFlirtTab.selected.map { $0 ? TabIndex.sparkFlirt.rawValue : nil }
            .bind(to: viewModel.selectedTabIndex)
            .disposed(by: disposeBag)
        chatTab.selected.map { $0 ? TabIndex.chat.rawValue : nil }
            .bind(to: viewModel.selectedTabIndex)
            .disposed(by: disposeBag)

        viewModel.selectedTabIndex.subscribe(onNext: { [weak self] index in
            guard let self = self, let index = index else { return }
            
            switch index {
            case TabIndex.invites.rawValue:
                self.sentTab.selected.accept(false)
                self.sparkFlirtTab.selected.accept(false)
                self.chatTab.selected.accept(false)
                break
            case TabIndex.sent.rawValue:
                self.invitesTab.selected.accept(false)
                self.sparkFlirtTab.selected.accept(false)
                self.chatTab.selected.accept(false)
                break
            case TabIndex.sparkFlirt.rawValue:
                self.invitesTab.selected.accept(false)
                self.sentTab.selected.accept(false)
                self.chatTab.selected.accept(false)
                break
            default:
                self.invitesTab.selected.accept(false)
                self.sentTab.selected.accept(false)
                self.sparkFlirtTab.selected.accept(false)
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
        
        notificationButton.rx.tap.bind { [weak self] in
            guard let self = self else { return }
            let vc = InAppNotificationsViewController()
            vc.hidesBottomBarWhenPushed = true
            self.show(vc, sender: nil)
        }.disposed(by: disposeBag)
        
        notificationViewModel.unreadNotifs.subscribe( onNext: { [weak self] counter in
            let counterString = counter <= 0 ? "" : counter > 9 ? "9+" : "\(counter)"
            self?.notificationButton.setBadge(text: counterString, color: .danger, fontSize: 8)
        }).disposed(by: disposeBag)
    }

}

extension SparkFlirtPageViewController: UIPageViewControllerDataSource {
    
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
