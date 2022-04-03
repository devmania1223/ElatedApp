//
//  SparkFlirtPageSettingsViewController.swift
//  Elated
//
//  Created by Marlon on 2021/3/9.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import SideMenu

class SparkFlirtPageSettingsViewController: MenuBasePageViewController {
    
    enum TabIndex : Int {
        case balance
        case history
    }
    
    private let viewModel = MenuPageViewModel()
    private var viewControllerList = [UIViewController]()
        
    private let balanceTab = LineTabView.createCommonTabView("menu.item.sparkFlirt.subtab.balance", selected: true)
    private let historyTab = LineTabView.createCommonTabView("menu.item.sparkFlirt.subtab.history")
    
    //this will be stretched end to end
    private let blankView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    init() {
        super.init(transitionStyle: .scroll,
                   navigationOrientation: .horizontal,
                   options: nil)
        self.title = "menu.item.sparkFlirt.title".localized
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllerList = [SparkFlirtSettingsMenuViewController(),
                              SparkFlirtSettingsHistoryViewController()]
        setViewControllers([viewControllerList[0]], direction: .forward, animated: true, completion: nil)
        self.bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.leftBarButtonItem = menuButton
        menuButton.tintColor = .white
        self.setupNavigationBar(.white,
                                font: .futuraMedium(20),
                                tintColor: .white,
                                backgroundImage: #imageLiteral(resourceName: "background-header"))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //TODO: Investigate why this doesnt work on viewWillAppear
        blankView.addShadowLayer()
    }
    
    
    override func initSubviews() {
        super.initSubviews()
        
        view.backgroundColor = .white
        
        let tabView = UIView()
        tabView.addSubview(balanceTab)
        tabView.addSubview(historyTab)
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
        
        balanceTab.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
        }
        
        historyTab.snp.makeConstraints { make in
            make.left.equalTo(balanceTab.snp.right)
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
        }
    
    }
    
    func bind() {
        
        balanceTab.selected.map { $0 ? TabIndex.balance.rawValue : nil }
            .bind(to: viewModel.selectedTabIndex)
            .disposed(by: disposeBag)
        historyTab.selected.map { $0 ? TabIndex.history.rawValue : nil }
            .bind(to: viewModel.selectedTabIndex)
            .disposed(by: disposeBag)

        viewModel.selectedTabIndex.subscribe(onNext: { [weak self] index in
            guard let self = self, let index = index else { return }
            switch index {
            case TabIndex.balance.rawValue:
                self.historyTab.selected.accept(false)
                break
            case TabIndex.history.rawValue:
                self.balanceTab.selected.accept(false)
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
