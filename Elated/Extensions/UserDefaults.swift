//
//  UserDefaults.swift
//  Elated
//
//  Created by Marlon on 2021/2/20.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    //list static keys here
    struct Key {
        static let token = "TOKEN"
        static let language = "LANGUAGE"
        static let totChoices = "TOT_CHOICES"
        static let totPages = "TOT_PAGES"
        static let isShowNextTOT = "SHOW_NEXT_TOT"
        static let isMatchesScreenViewFirstTime = "MATCHES_VIEWED_FIRST_TIME"
        static let showOnboardingTOT = "showOnboardingToTTutorial"
    }
    
    func clearUserData() {
        UserDefaults.standard.removeObject(forKey: UserDefaults.Key.token)
        UserDefaults.standard.removeObject(forKey: UserDefaults.Key.language)
        UserDefaults.standard.removeObject(forKey: UserDefaults.Key.totChoices)
        UserDefaults.standard.removeObject(forKey: UserDefaults.Key.totPages)
        UserDefaults.standard.removeObject(forKey: UserDefaults.Key.isShowNextTOT)
        UserDefaults.standard.removeObject(forKey: UserDefaults.Key.isMatchesScreenViewFirstTime)
        
        #warning("Remove Call to TooltipManager.shared.forgetAll() once we go to production, this if for testing only")
        TooltipManager.shared.forgetAll()
        
        //keep track of my online status
        if let id = MemCached.shared.userInfo?.id {
            FirebaseChat.shared.updateMyOnlineStatus(id: id, isOnline: false)
        }
    }
    
    var isLoggedIn : Bool {
        return token != nil
    }
    
    var language: String? {
        get {
            return self.string(forKey: Key.language)
        }
        set {
            self.set(newValue, forKey: Key.language)
        }
    }
    
    var token: String? {
        get {
            return self.string(forKey: Key.token)
        }
        set {
            self.set(newValue, forKey: Key.token)
        }
    }
    
    var showOnboardingTOT: Bool {
        get {
            return self.bool(forKey: Key.showOnboardingTOT)
        }
        set {
            self.set(newValue, forKey: Key.showOnboardingTOT)
        }
    }

    var isShowNextTOT: Bool {
        get {
            return self.bool(forKey: Key.isShowNextTOT)
        }
        set {
            self.set(newValue, forKey: Key.isShowNextTOT)
        }
    }
    
    var totChoices: [String] {
        get {
            return self.array(forKey: Key.totChoices) as? [String] ?? []
        }
        set {
            self.set(newValue, forKey: Key.totChoices)
        }
    }
    
}
