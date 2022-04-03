//
//  MenuTabBarViewController.swift
//  Elated
//
//  Created by Marlon on 2021/3/5.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class MenuTabBarViewController: UITabBarController {
    
    enum PredefinedAction {
        case fromOnboarding
        case navigateSparkFlirtInvite
        case navigateToChat
    }
    
    enum MenuIndex: Int {
        case profile
        case matches
        case sparkFlirt
        case favorite
        case thisOrThat
    }
    
    private var fromOnboarding: Bool = false
    private var navigateSparkFlirtInvite: Bool = false
    private var navigateToChat: Bool = false
    
    init(_ actions: [PredefinedAction] = []) {
        super.init(nibName: nil, bundle: nil)
        
        self.fromOnboarding = actions.contains(.fromOnboarding)
        self.navigateSparkFlirtInvite = actions.contains(.navigateSparkFlirtInvite)
        self.navigateToChat = actions.contains(.navigateToChat)
        
        viewControllers = getViewControllers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubview()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        //keep me on online status
        if let id = MemCached.shared.userInfo?.id {
            FirebaseChat.shared.updateMyOnlineStatus(id: id, isOnline: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func initSubview() {
        view.backgroundColor = .white
        tabBar.isTranslucent = false
        tabBar.barTintColor = .white
    }
    
    func bind() {
        
    }
    
    func getViewControllers() -> [UIViewController] {
        
        let profilePageTab = ProfilePageViewController("menu.tabview.tab.profile".localized, viewUserID: nil)
        profilePageTab.tabBarItem = UITabBarItem(title: "",
                                           image: #imageLiteral(resourceName: "icons-me").withRenderingMode(.alwaysOriginal),
                                           selectedImage: #imageLiteral(resourceName: "icons-me-active").withRenderingMode(.alwaysOriginal))
        
        let matchesPageTab = MatchesPageViewController("menu.tabview.tab.matches".localized)
        matchesPageTab.tabBarItem = UITabBarItem(title: "",
                                                 image: #imageLiteral(resourceName: "icons-matches").withRenderingMode(.alwaysOriginal),
                                                 selectedImage: #imageLiteral(resourceName: "icons-matches-active").withRenderingMode(.alwaysOriginal))
        
        let sparkFlirtPageTab = SparkFlirtPageViewController("menu.tabview.tab.sparkFlirt".localized,
                                                             initialTab: navigateToChat ? .chat : .invites)
        sparkFlirtPageTab.tabBarItem = UITabBarItem(title: "",
                                                    image: #imageLiteral(resourceName: "icons-sparkflirt").withRenderingMode(.alwaysOriginal),
                                                    selectedImage: #imageLiteral(resourceName: "icons-sparkflirt-active").withRenderingMode(.alwaysOriginal))
        
        let favoritePageTab = FavoritesPageViewController("menu.tabview.tab.favorites".localized) //BashoInvitesViewController() 
        favoritePageTab.tabBarItem = UITabBarItem(title: "",
                                                        image: #imageLiteral(resourceName: "icons-favorites").withRenderingMode(.alwaysOriginal),
                                                        selectedImage: #imageLiteral(resourceName: "icons-favorites-active").withRenderingMode(.alwaysOriginal))
        
        
        //ThisOrThatTutorial
        let thisOrThat = ThisOrThatWelcomePageViewController()
        thisOrThat.tabBarItem = UITabBarItem(title: "",
                                             image: #imageLiteral(resourceName: "icons-thisorthat").withRenderingMode(.alwaysOriginal),
                                             selectedImage: #imageLiteral(resourceName: "icon-list-thisorthat").withRenderingMode(.alwaysOriginal))
        
        let thisOrThatOnboarding = ThisOrThatOnboardingViewController("menu.tabview.tab.thisOrThat".localized)
        thisOrThatOnboarding.tabBarItem = UITabBarItem(title: "",
                                                       image: #imageLiteral(resourceName: "icons-thisorthat").withRenderingMode(.alwaysOriginal),
                                                       selectedImage: #imageLiteral(resourceName: "icon-list-thisorthat").withRenderingMode(.alwaysOriginal))
        
        
        return [
            UINavigationController(rootViewController: profilePageTab),
            UINavigationController(rootViewController: matchesPageTab),
            UINavigationController(rootViewController: sparkFlirtPageTab),
            UINavigationController(rootViewController: favoritePageTab),
            //UINavigationController(rootViewController: thisOrThat)
            // TODO: Call this when BE's ToT Onboarding endpoint is ready (REY)
            UINavigationController(rootViewController: fromOnboarding ? thisOrThat : thisOrThatOnboarding)
        ]
    }

}
