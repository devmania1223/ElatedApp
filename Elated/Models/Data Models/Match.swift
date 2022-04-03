//
//  Match.swift
//  Elated
//
//  Created by Marlon on 2021/3/18.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import SwiftyJSON

enum MatchState: String {
    case created = "Created"
    case shown = "Shown"
    case matched = "Matched"
    case rejected = "Rejected"
}

enum MatchStateInt: Int {
    case created = 0
    case shown = 1
    case matched = 2
    case rejected = 3
}

enum MatchType: String {
    case best = "Best Matches"
    case recent  = "Recent Matches"
}

struct Match {
    var id: Int?
    var matchPercentage: Int?
    var matchedWith: MatchWith?
    var isFavorite: Bool?
    var isAfan: Bool?
    var matchType: MatchType?
    var state: MatchState?
    var createdAt: String?
    
    init(_ json: JSON) {
        id = json["id"].intValue
        matchPercentage = json["match_percentage"].int
        matchedWith = MatchWith(json["matched_with"])
        isFavorite = json["is_favorite"].boolValue
        isAfan = json["is_a_fan"].boolValue
        matchType = MatchType(rawValue:json["match_type"].stringValue)
        state = MatchState(rawValue: json["state"].stringValue)
        createdAt = json["created_at"].stringValue
    }
}

struct MatchWith {
    var userId: Int?
    var username: String?
    var firstName: String?
    var lastName: String?
    var fullName: String?
    var occupation: String?
    var birthdate: String?
    var images = [ProfileImage]()
    
    init(_ json: JSON) {
        userId = json["user_id"].intValue
        username = json["username"].stringValue
        firstName = json["first_name"].stringValue
        lastName = json["last_name"].stringValue
        fullName = json["full_name"].stringValue
        occupation = json["occupation"].stringValue
        birthdate = json["birthdate"].stringValue
        images = json["images"].arrayValue.map { ProfileImage($0) }
    }
    
    init(userInfoShort: UserInfoShort) {
        userId = userInfoShort.id
        username = userInfoShort.username
        firstName = userInfoShort.firstName
        lastName = userInfoShort.lastName
        fullName = ""
        occupation = ""
        birthdate = ""
        if let avatar =  userInfoShort.avatar {
            let profileImage = ProfileImage(avatar: avatar)
            images.append(profileImage)
        }
    }
    
    func getDisplayName() -> String {
        return "\(firstName ?? "") \((lastName?.first ?? " ").uppercased())."
    }
    
    func getDisplayNameAge() -> String {
        return "\(firstName ?? "") \((lastName?.first ?? " ").uppercased())., \(getAgeString())"
    }
    
    func getAge() -> Int? {
        return birthdate?.stringToBdayDate().age
    }
    
    func getAgeString() -> String {
        return birthdate?.stringToBdayDate().age == nil ? "" : "\(birthdate?.stringToBdayDate().age ?? 0)"
    }
    
}
