//
//  UserInfo.swift
//  Elated
//
//  Created by Marlon on 2021/3/18.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import SwiftyJSON

struct UserInfo {
    
    var id: Int?
    var username: String?
    var email: String?
    var firstName: String?
    var lastName: String?
    var profile: ProfileInfo?
    var matchPreferences: MatchPreference?
    var settings: Settings?
    var sparkflirtaccount: SparkFlirtAccount?
    var matches = [Match]()
    var socialAuth = [SocialAuth]()
    var profileImages = [ProfileImage]()
    var location: Location?
    var isActive: Bool = false
    var notification: UserNotification?
    var firstSparkFlirtSent = false
    var firstSparkFlirtReceived = false
    var shownMatchesTutorial = false
    var shownSparkFlirtTutorial = false

    init(_ json: JSON) {
        id = json["id"].intValue
        username = json["username"].stringValue
        email = json["email"].stringValue
        firstName = json["first_name"].stringValue
        lastName = json["last_name"].stringValue
        profile = ProfileInfo(json["profile"])
        matchPreferences = MatchPreference(JSON(json["match_preferences"]))
        location = Location(JSON(json["location"]))
        settings = Settings(JSON(json["settings"]))
        sparkflirtaccount = SparkFlirtAccount(JSON(json["sparkflirtaccount"]))
        matches = (json["matches"].array?.map({ Match($0) }) ?? [])
        socialAuth = (json["social_auth"].array?.map({ SocialAuth($0) }) ?? [])
        profileImages =  (json["profile_images"].array?.map({ ProfileImage($0) }) ?? [])
        isActive = json["is_active"].boolValue
        notification = UserNotification(JSON(json["notification"]))
        firstSparkFlirtSent = json["first_sparkflirt_sent"].boolValue
        firstSparkFlirtReceived = json["first_sparkflirt_received"].boolValue
        shownMatchesTutorial = json["first_matches_tutorial"].boolValue
        shownSparkFlirtTutorial = json["first_sparkflirt_tutorial"].boolValue
    }
    
    func getDisplayName() -> String {
        return "\(firstName ?? "") \(String(lastName?.first ?? " ").uppercased())."
    }
    
    func getDisplayNameAge() -> String {
        return "\(firstName ?? "") \(String(lastName?.first ?? " ").uppercased())., \(profile?.getAgeString() ?? "")"
    }
        
}

enum FirstTimeEvent: String {
    case sparkFlirtTutorial = "sparkflirt_tutorial"
    case matchesTutorial = "matches_tutorial"
}
