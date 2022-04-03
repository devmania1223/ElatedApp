//
//  MatchPreference.swift
//  Elated
//
//  Created by Marlon on 2021/3/18.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import SwiftyJSON

enum FamilyPreference: String {
    case kids = "KIDS"
    case noKids = "NO_KIDS"
    case maybe = "MAYBE"
    case fineExisting = "FINE_EXISTING"
    case other = "OTHER"
    
    func getName() -> String {
        switch self {
        case .kids:
            return "profile.editProfile.wantKids.interested".localized
        case .noKids:
            return "profile.editProfile.wantKids.noWay".localized
        case .maybe:
            return "profile.editProfile.wantKids.maybe".localized
        case .fineExisting:
            return "profile.editProfile.wantKids.imFine".localized
        case .other:
            return ""
        }
    }
}

enum SmokingPreference: String {
    case notOpen = "NOT_OPEN"
    case never = "NEVER"
    case four20 = "FOUR20"
    case ocational = "OCCASIONAL"
    case fine = "FINE"
    case often = "OFTEN"
    case welcome = "WELCOME"
    case other = "OTHER"

    func getName() -> String {
        switch self {
        case .notOpen:
            return "profile.editProfile.smoking.notOpen".localized
        case .never:
            return "profile.editProfile.smoking.never".localized
        case .four20:
            return "profile.editProfile.smoking.four20".localized
        case .ocational:
            return "profile.editProfile.smoking.ocational".localized
        case .fine:
            return "profile.editProfile.smoking.fine".localized
        case .often:
            return "profile.editProfile.smoking.often".localized
        case .welcome:
            return "profile.editProfile.smoking.welcome".localized
        case .other:
            return ""
        }
    }
}

enum DrinkingPreference: String {
    case never = "NEVER"
    case rarely = "RARELY"
    case socialy = "SOCIALLY"
    case often = "OFTEN"
}

enum MatchPrefLocationType: String {
    case nearMe = "NEAR_ME"
    case other = "OTHER"
    
    func getName() -> String {
        switch self {
        case .nearMe:
            return "settings.location.nearme" .localized
        case .other:
            return "common.other".localized
        }
    }
}

struct MatchPreference {

    var id: Int?
    var genderPref: Gender?
    var relationshipPref: DatingPreference?
    var ageMin: Int?
    var ageMax: Int?
    var familyPref: FamilyPreference?
    var smokePref = [SmokingPreference]()
    var drinkPref: DrinkingPreference?
    var maxDistance: Int?
    var distanceType: DistanceType?
    var location: Location?
    var locationType: MatchPrefLocationType?

    init(_ json: JSON) {
        id = json["id"].intValue
        genderPref = Gender(rawValue: json["gender_pref"].stringValue)
        relationshipPref = DatingPreference(rawValue: json["relationship_pref"].stringValue)
        ageMin = json["age_min"].intValue
        ageMax = json["age_max"].intValue
        familyPref = FamilyPreference(rawValue: json["family_pref"].stringValue)
        smokePref = json["smoking_pref"].arrayValue.map { ( SmokingPreference(rawValue: $0.stringValue) ?? .other ) }
        drinkPref = DrinkingPreference(rawValue: json["drink_pref"].stringValue)
        maxDistance = json["max_distance"].intValue
        distanceType = DistanceType(rawValue: json["distance_type"].stringValue)
        location = Location(JSON(json["location"]))
        locationType = MatchPrefLocationType(rawValue: json["location_type"].stringValue)
    }
    
}
