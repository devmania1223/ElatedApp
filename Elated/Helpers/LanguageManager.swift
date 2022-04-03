//
//  LanguageManager.swift
//  Elated
//
//  Created by Marlon on 2021/2/20.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum Language: String {
    
    //for now english is the only supported language
    case en = "en"
    
    func resourceName() -> String {
        switch self {
        case .en:
            return "en"
        }
    }
    
    func displayName() -> String {
        switch self {
        case .en:
            return "English (US)"
        }
    }
    
    func apiValue() -> String {
        switch self {
        case .en:
            return "en"
        }
    }
    
    init(langId: Int) {
        switch langId {
        default:
            //0
            self = .en
        }
    }
    
}

class LanguageManager {
    
    static let shared = LanguageManager()
    
    var currentLanguage: String {
        didSet {
            if Language.init(rawValue: currentLanguage) == nil {
                currentLanguage = Language.en.rawValue
            }
            UserDefaults.standard.language = currentLanguage
            UserDefaults.standard.synchronize()
            changeBundle()
        }
    }
        
    private var bundle: Bundle = Bundle.main
    
    private init() {
        if let lang = UserDefaults.standard.value(forKey: UserDefaults.Key.language) as? String {
            self.currentLanguage = lang
        } else {
            //let language = Locale.preferredLanguages.first!
            let languageForServer = "en"
            
            /*
                Put other language support here
             */
            
            self.currentLanguage = languageForServer
            UserDefaults.standard.language = currentLanguage
            UserDefaults.standard.synchronize()
        }
        
        changeBundle()
    }
    
    private func changeBundle() {
        let language = Language.init(rawValue: currentLanguage)!
        print(language.resourceName())
        let path = Bundle.main.path(forResource: language.resourceName(), ofType: "lproj")!
        bundle = Bundle.init(path: path)!
    }
    
    func localizedString(_ key: String, _ tableName: String? = nil) -> String {
        return NSLocalizedString(key, tableName: tableName, bundle: bundle, comment: "")
    }
    
    func getLanguageList() -> [Language] {
        return [.en]
    }
    
    func errorMessage(for code: Int, params: [CVarArg] = []) -> String {
        /* other laguage condition here */
        return apiErrorCodesEn["\(code)"] ?? "Error: \(code)".localizedFormat(params)
    }
    
    //List down error codes here together with the message
    private let apiErrorCodesEn: [String: String] = [
        "1000000000": "Invalid Username or Password",
        "-1": "Failure",
        "1": "Success",
        "10001": "Token Expired",
        "10003": "Invalid OTP",
        "10004": "Expired OTP",
        "1001": "This email is already being used.",
        "1002": "User does not exist",
        "1003": "User has insufficient balance",
        "1004": "Invalid Username or Password",
        "1005": "Email does not exist",
        "1006": "Phone number does not exist",
        "1007": "Email already exist",
        "2001": "Instagram session expired. Please login your account.",
        
        //new error format
        
        //USER
        "100001": "Invalid username or password.",
        "100002": "Username already exists.",
        "100003": "This email is already being used.",
        "100004": "Username is required.",
        "100005": "Email is required.",
        "100006": "Password is required.",
        "100007": "Confirmation code doesn’t match.",
        "100008": "Email does not exists.",
        "100009": "One-Time Password (OTP) expired.",

        //SMS
        "203001": "Phone number does not exists.",
        "203002": "Number already been used by a different account.",
        "203003": "One-Time Password expired",
        
        //OTP
        "202001": "Email verification is expired.",
        "202002": "One-Time password is expired.",
        
        //SparkFlirt
        "300001": "User is unauthorized to update SparkFlirt Account.",
        "300002": "SparkFlirt account update error.",
        "300003": "Unable to get expired sparkflirts",
        "300004": "Unable to update sparkflirt at the moment.",
        "300005": "Unable to view incoming sparkflirts at the moment.",
        "300006": "Unable to view active sparkflirts at the moment.",
        "300007": "Unable to view sent sparkflirts at the moment.",
        "300008": "Unable to view completed sparkflirts at the moment.",
        "300009": "Unable to view sparkflirt history at the moment.",
        "300010": "User does not have enough sparkflirt.",
        "300011": "Unable to invite user at the moment.",
        "300012": "User cannot send invite to self.",
        "300013": "Unable to view sparkflirts at the moment.",
        "300014": "User already invited.",
        "300015": "Sparkflirt does not exist",
        "300016": "Unable to start game at the moment.",
        "300017": "Unable to accept invite at the moment.",
        "300018": "Unable to update sparkflirt account at the moment.",
        "300019": "Unable to view unused sparkflirts at the moment.",
        "300020": "Unbale to generate sparkflirt at the moment.",
        
        //Coupon
        "303001": "Invalid coupon code.",
        
        //In-App Purchase
        "400001": "Unable to process payment. Invalid apple receipt.",
        "400002": "Unable to process payment at the moment. Please try again later.",
        "400003": "Unable to view order history at the moment. Please try again later.",
        
        //Favorites
        "401001": "User already in favorites.",
        "401002": "Unable to unfavorite user at this time.",
        "401003": "Unable to view favorite user at this time.",
        "401004": "Unable to view users who favorited you at this time.",
        "401005": "Use SparkFlirt to see person.",
        
        //Nudges
        "501001": "Unable to nudge user at the moment",
        "501002": "Already nudged back at user.",
        "501003": "Unable to nudge back user at the moment.",
        "501004": "Unable to send nudge notification at the moment.",
        
        //Social Media
        "600001": "Invalid authorization code",
        "600002": "Invalid access token",
        "600003": "Email or user id does not exists.",
        "600004": "Unable to send email at this time.",
        "600005": "Email already exists",
        "600006": "Invalid One-Time Password (OTP)",
        "600007": "One-Time Password (OTP) expired.",
        
        //Chat
        "601001": "Unable to view conversation at the moment.",
        "601002": "Unable to view chats at the moment.",
        "601003": "Unable to view favorite user at this time.",
        "601004": "Unable to view users who favorited you at this time.",
        "601005": "Use sparkflirt to see person.",
        
        //Other Social
        "700001": "File must be less than or equal to 5mb.",
        "700002": "Unable to upload file at the moment.",
        
        //Inquiries
        "900001": "Unable to send inquiry at the moment."
    ]

}
