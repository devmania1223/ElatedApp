//
//  Environment.swift
//  Elated
//
//  Created by Marlon on 2021/2/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation

public enum Environment {
    // MARK: - Keys
    enum Keys {
        enum Plist {
            static let rootURL = "ROOT_URL"
            static let version = "CFBundleShortVersionString"
            static let build = "CFBundleVersion"
            static let bundleName = "CFBundleName"
            static let env = "ENV"
            static let intagramClientID = "INSTAGRAM_CLIENT_ID"
            static let intagramSecret = "INSTAGRAM_SECRET"
            static let intagramURLScheme = "INSTAGRAM_URL_SCHEME"
            static let fbURLScheme = "FB_URL_SCHEME"
        }
    }

    // MARK: - Plist
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()

    // MARK: - Plist values
    static var rootURLString: String = {
        guard let urlStr = Environment.infoDictionary[Keys.Plist.rootURL] as? String else {
            fatalError("Root URL not set in plist for this environment")
        }
        return urlStr
    }()
    
    static var appVersion: String {
        guard let version = Environment.infoDictionary[Keys.Plist.version] as? String else {
            fatalError("Version not set in plist for this environment")
        }
        return version
    }
    
    static var appBuild: String {
        guard let build = Environment.infoDictionary[Keys.Plist.build] as? String else {
            fatalError("Version not set in plist for this environment")
        }
        return build
    }
    
    static var appEnv: String {
        guard let env = Environment.infoDictionary[Keys.Plist.env] as? String else {
            fatalError("Version not set in plist for this environment")
        }
        if env == "DEVELOP" { return " - Development" }
        if env == "STAGING" { return " - Staging" }
        if env == "PRODUCTION" { return "" }
        return " - \(env)"
    }
    
    static var bundleName: String {
        guard let name = Environment.infoDictionary[Keys.Plist.bundleName] as? String else {
            fatalError("Bundle Name not set in plist for this environment")
        }
        return name
    }
    
    static var env: String {
        guard let env = Environment.infoDictionary[Keys.Plist.env] as? String else {
            fatalError("Env not set in plist for this environment")
        }
        return env
    }
    
    static var instagramClientID: String {
        guard let env = Environment.infoDictionary[Keys.Plist.intagramClientID] as? String else {
            fatalError("Env not set in plist for this environment")
        }
        return env
    }
    
    static var instagramSecret: String {
        guard let env = Environment.infoDictionary[Keys.Plist.intagramSecret] as? String else {
            fatalError("Env not set in plist for this environment")
        }
        return env
    }
    
    static var instagramURLScheme: String {
        guard let env = Environment.infoDictionary[Keys.Plist.intagramURLScheme] as? String else {
            fatalError("Env not set in plist for this environment")
        }
        return env
    }
    
    static var fbURLScheme: String {
        guard let env = Environment.infoDictionary[Keys.Plist.fbURLScheme] as? String else {
            fatalError("Env not set in plist for this environment")
        }
        return env
    }
    
}
