//
//  AppDelegate.swift
//  Elated
//
//  Created by admin on 5/12/20.
//  Copyright © 2020 elatedteam. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import FBSDKCoreKit
import GoogleSignIn
import Firebase
import SpotifyLogin
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    var floatingChatButton: ChatFloatingViewController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        if #available(iOS 13, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.shadowColor = nil
            appearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont.futuraBook(17)]
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            UINavigationBar.appearance().isTranslucent = false
            UINavigationBar.appearance().tintColor = .elatedPrimaryPurple
            UINavigationBar.appearance().shadowImage = UIImage()
            UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        } else {
            UINavigationBar.appearance().shadowImage = UIImage()
            UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
            UINavigationBar.appearance().isTranslucent = false
            UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.futuraBook(17)], for: UIControl.State.normal)
            UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.futuraBook(17)], for: UIControl.State.focused)
            UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.futuraBook(17)], for: UIControl.State.highlighted)
            UIBarButtonItem.appearance().tintColor = .elatedPrimaryPurple
        }
        
        // Override point for customization after application launch.
        let redirectURL: URL = URL(string: "elated://returnafterlogin")!
        SpotifyLogin.shared.configure(clientID: "9ab808eb26d749658baf218899a54652",
                                      clientSecret: "1c972d259ac847b4ab017af130ca374b",
                                      redirectURL: redirectURL)

        self.window = UIWindow(frame: UIScreen.main.bounds)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = LaunchViewController.xib()
        window?.makeKeyAndVisible()
        
        //App Atest for security
//        let providerFactory = FirebaseAppCheckProviderFactory()
//        AppCheck.setAppCheckProviderFactory(providerFactory)
        
        let firebasePlistFileName = "GoogleService-Info-\((Environment.env).lowercased())"
        if let firebasePlist = Bundle.main.path(forResource: firebasePlistFileName, ofType: "plist"),
          let option = FirebaseOptions(contentsOfFile: firebasePlist) {
          FirebaseApp.configure(options: option)
        } else {
          FirebaseApp.configure()
        }
        
        //old code
        //GIDSignIn.sharedInstance.authentication.clientID = FirebaseApp.app()?.options.clientID
        //let signInConfig = GIDConfiguration.init(clientID: FirebaseApp.app()?.options.clientID ?? "")
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )

        // Get all In-App Purchase Product IDs
        IAPManager.shared.fetchProducts()

        //Global chat floating button
        initfloatingChatButton()
        
        NotificationCenter.default.rx.notification(.userLoggedIn)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.updateFloatingChatButtonState(hide: false)
            }).disposed(by: rx.disposeBag)
        
        NotificationCenter.default.rx.notification(.userLogout)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.updateFloatingChatButtonState(hide: true)
            }).disposed(by: rx.disposeBag)
        
        return true
    }
    
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        if let url = userActivity.webpageURL {
            let handled = DynamicLinks.dynamicLinks().handleUniversalLink(url) { [weak self] dynamiclink, error in
                #if DEBUG
                print("Dynamiclink \(dynamiclink?.url?.absoluteString ?? "")")
                #endif
                if let link = dynamiclink {
                    self?.handleDynamicLink(dynamicLink: link)
                }
            }
            return handled
        }
        
        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            handleDynamicLink(dynamicLink: dynamicLink)
            return true
        }
        
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        
        let handled = SpotifyLogin.shared.applicationOpenURL(url) { _ in }
        return handled
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
          handleDynamicLink(dynamicLink: dynamicLink)
          return true
        }
        
        return GIDSignIn.sharedInstance.handle(url)

    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        //keep track of my online status
        if let id = MemCached.shared.userInfo?.id {
            FirebaseChat.shared.updateMyOnlineStatus(id: id, isOnline: false)
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        //keep track of my online status
        if let id = MemCached.shared.userInfo?.id {
            FirebaseChat.shared.updateMyOnlineStatus(id: id, isOnline: true)
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        //keep track of my online status
        if let id = MemCached.shared.userInfo?.id {
            FirebaseChat.shared.updateMyOnlineStatus(id: id, isOnline: false)
        }
    }
    
    private func handleDynamicLink(dynamicLink: DynamicLink) {
        if let url = dynamicLink.url,
           let components = URLComponents(string: url.absoluteString),
           let first = components.queryItems?.first,
           let second = components.queryItems?.last {
            
            if let uid = first.name == "uid" ? first.value : second.value,
               let token = second.name == "token" ? second.value : first.value {
                let vc = SetPasswordViewController(uid: uid, token: token)
                Util.setRootViewController(vc)
            }
        }
    }
    
}
    
//MARK: Notification
extension AppDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenChars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
        var tokenString = ""
        for i in 0..<deviceToken.count {
          tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        if let uuid = UIDevice.current.identifierForVendor?.uuidString,
           MemCached.shared.userInfo?.id != nil {
            ApiProvider.shared.request(NotificationService.registerDevice(uuid: uuid, token: tokenString))
                .subscribe(onSuccess: { res in
                    #if DEBUG
                        print("Success Registration of Notification Token: \(tokenString)")
                    #endif
            }, onError: { err in
                #if DEBUG
                    print("Error Registration of Notification Token: \(err)")
                #endif
            }).disposed(by: rx.disposeBag)
        }
        
        #if DEBUG
            print("Received token data! \(tokenString)")
        #endif
    }
        
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        #if DEBUG
            print("Couldn't register: \(error)")
        #endif
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        #if DEBUG
            print("Message received.")
        #endif
      if let aps = userInfo[AnyHashable("aps")] as? [AnyHashable: Any] {
          if let alert = aps[AnyHashable("alert")] as? String {
              let alertController = UIAlertController(title: "Incoming Notification", message: alert, preferredStyle: .alert)
              let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
              alertController.addAction(defaultAction)
              self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
          }
      }
    }
    
}

//MARK: Chat Floating Button --

extension AppDelegate {
    @objc func initfloatingChatButton() {
        self.floatingChatButton = ChatFloatingViewController()
        self.floatingChatButton?.chatButton.isHidden = MemCached.shared.userInfo == nil
        self.floatingChatButton?.chatButton.addTarget(self,
                                                      action: #selector(self.floatingChatButtonWasTapped),
                                                      for: .touchUpInside)
    }
    
    @objc func floatingChatButtonWasTapped() {
        //show chatViewController
        self.updateFloatingChatButtonState(hide: true)
        let vc = UINavigationController(rootViewController: SparkFlirtChatRoomCollectionViewController(showBackButton: true))
        vc.modalPresentationStyle = .fullScreen
        UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
    }
    
    func updateFloatingChatButtonState(hide: Bool) {
        if hide {
            floatingChatButton?.window.isHidden = hide
            floatingChatButton = nil
        } else {
            self.initfloatingChatButton()
        }
    }
}
