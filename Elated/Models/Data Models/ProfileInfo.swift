//
//  ProfileInfor.swift
//  Elated
//
//  Created by Marlon on 2021/3/18.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import SwiftyJSON

enum Gender: String {
    case male = "MALE"
    case female = "FEMALE"
    case gay = "GAY"
    case lesbian = "LESBIAN"
    case bisexual = "BISEXUAL"
    case transgender = "TRANSGENDER"
    case other = "OTHER"
    
    func getName() -> String {
        switch self {
        case .male:
            return "profile.editProfile.gender.male".localized
        case .female:
            return "profile.editProfile.gender.female".localized
        case .gay:
            return "profile.editProfile.gender.gay".localized
        case .lesbian:
            return "profile.editProfile.gender.lesbian".localized
        case .bisexual:
            return "profile.editProfile.gender.bisexual".localized
        case .transgender:
            return "profile.editProfile.gender.transgender".localized
        case .other:
            return "profile.editProfile.gender.other".localized
        }
    }
    
}

enum Game: String {
    case basho = "BASHO"
    //case password = "PASSWORD"
    case storyshare = "STORYSHARE"
    case emojigo = "EMOJIGO"
    
    func getTitle() -> String {
        switch self {
        case .basho:
            return "Basho"
        case .storyshare:
            return "StoryShare"
        case .emojigo:
            return "EmojiGo"
        }
    }
    
    func getIconImage() -> String {
        switch self {
        case .basho:
            return "button-basho-circle"
        case .storyshare:
            return "button-storyshare-circle"
        case .emojigo:
            return "button-emojigo-circle"
        }
    }
}

enum Race: String {
    case asian = "ASIAN"
    case arab = "ARAB"
    case americanIndian = "AMERICAN_INDIAN"
    case blackAfrican = "BLACK_AFRICAN"
    case hispanicLatina = "HISPANIC_LATINA"
    case hispanicLatino = "HISPANIC_LATINO"
    case southAsian = "SOUTH_ASIAN"
    case whiteCaucasian = "WHITE_CAUCASIAN"
    case latino = "LATINO"
    case nativeAmerican = "NATIVE_AM"
    case africanAmerican = "AFRICAN_AM"
    case pacificIslander = "PAC_ISLAND"
    case caucasian = "CAUCASIAN"
    case other = "OTHER"
    
    func getName() -> String {
        switch self {
        case .latino:
            return "Latino"
        case .nativeAmerican:
            return "Native American"
        case .asian:
            return "Asian"
        case .africanAmerican:
            return "African American"
        case .pacificIslander:
            return "Pacific Islander"
        case .caucasian:
            return "Caucasian"
        case .other:
            return "Other"
        case .arab:
            return "Arab"
        case .americanIndian:
            return "American Indian"
        case .blackAfrican:
            return "Black/African descent"
        case .hispanicLatina:
            return "Hispanic/Latina"
        case .hispanicLatino:
            return "Hispanic/Latino"
        case .southAsian:
            return "South Asian"
        case .whiteCaucasian:
            return "White/Caucasian"
        }
    }
    
    static func convertToEnum(_ title: String) -> Race {
        switch title {
        case "Latino":
            return .latino
        case "Native American":
            return .nativeAmerican
        case "Asian":
            return .asian
        case "African American":
            return .africanAmerican
        case "Pacific Islander":
            return .pacificIslander
        case "Caucasian":
            return .caucasian
        case "Arab":
            return .arab
        case "American Indian":
            return .americanIndian
        case "Black/African descent":
            return .blackAfrican
        case "Hispanic/Latina":
            return .hispanicLatina
        case "Hispanic/Latino":
            return .hispanicLatino
        case "South Asian":
            return .southAsian
        case "White/Caucasian":
            return .whiteCaucasian
        default:
            return .other
        }
    }
    
}

enum Religion: String {
    case christian = "CHRISTIAN"
    case catholic = "CATHOLIC"
    case muslim = "MUSLIM"
    case hindu = "HINDU"
    case buddhist = "BUDDHIST"
    case agnostic = "AGNOSTIC"
    case atheist = "ATHIEST"
    case none = "NONE"
    case other = "OTHER"
    case spiritual = "SPIRITUAL"
}

enum PoliticalStance: String {
    case liberal = "LIBERAL"
    case conservative = "CONSERVATIVE"
    case democratic = "DEMOCRATIC"
    case blocQuebecois = "BLOC_QUEBECOIS"
    case greenParty = "GREEN_PARTY"
}

enum MaritalStatus: String {
    case single = "SINGLE"
    case divorced = "DIVORCED"
    case divorcedWithKids = "DIVORCED_W_KIDS"
    case widowed = "WIDOWED"
    case married = "MARRIED"
    case other = "OTHER"
    
    func getName() -> String {

        switch self {
        case .single:
            return "profile.editProfile.status.single".localized
        case .divorced:
            return "profile.editProfile.status.separated".localized
        case .divorcedWithKids:
            return "profile.editProfile.status.separatedWithKids".localized
        case .widowed:
            return "profile.editProfile.status.widowed".localized
        case .other:
            return "profile.editProfile.status.other".localized
        case .married:
            return "profile.editProfile.status.married".localized
        }
    }
}

enum DistanceType: String {
    case miles = "MILES"
    case kilometeres = "KILOMETERS"
    
    func getAbbreviation() -> String {
        switch self {
        case .miles:
            return "settings.distance.miles.abbreviation".localized
        case .kilometeres:
            return "settings.distance.kilometers.abbreviation".localized
        }
    }
}

enum CPProgress: Int {
    //TODO: Get the proper naming
    case progress0
    case progress1
    case progress2
    case progress3
    case progress4
    case progress5
}

enum Zodiac: String {
    case aries = "Aries"
    case taurus = "Taurus"
    case gemini = "Gemini"
    case cancer = "Cancer"
    case leo = "Leo"
    case virgo = "Virgo"
    case libra = "Libra"
    case scorpio = "Scorpio"
    case sagitarius = "Sagitarius"
    case capricorn = "Capricorn"
    case aquarius = "Aquarius"
    case pisces = "Pisces"
    
    func getIconName() -> String {
        return "icon-\(self.rawValue.lowercased())"
    }
}

enum DatingPreference: String {
    case casual = "CASUAL"
    case soulMate = "SOULMATE"
    case notSure = "NOT_SURE"
    case other = "OTHER"

    func getName() -> String {
        switch self {
        case .casual:
            return "profile.editProfile.datingPref.casual".localized
        case .soulMate:
            return "profile.editProfile.datingPref.soulmate".localized
        case .notSure:
            return "profile.editProfile.datingPref.notSure".localized
        case .other:
            return "".localized
        }
    }
    
}

enum HaveKids: String {
    case none = "NO"
    case companions = "CONSTANT_COMPANION"
    case minions = "NOT_LIVING_WITH_THEM"
    case halfHalf = "JOINT_CUSTODY"
    
    func getName() -> String {
        switch self {
        case .none:
            return "profile.editProfile.haveKids.nope" .localized
        case .companions:
            return "profile.editProfile.haveKids.companions".localized
        case .minions:
            return "profile.editProfile.haveKids.minions".localized
        case .halfHalf:
            return "profile.editProfile.haveKids.halfHalf".localized
        }
    }
}

enum NotificationFrequency: String {
    
    case forAnHour = "HOUR"
    case untilThisEvening = "EVENING"
    case untilMorning = "MORNING"
    case forAWeek = "WEEK"
    
    func getName() -> String {
        switch self {
        case .forAnHour:
            return "notification.frequency.forAnHour".localized
        case .untilThisEvening:
            return "notification.frequency.untilEvening".localized
        case .untilMorning:
            return "notification.frequency.untilMorning".localized
        case .forAWeek:
            return "notification.frequency.forAWeek".localized
        }
    }

}

enum HeightType: String {
    case feet = "HEIGHT_FEET"
    case cm = "HEIGHT_CM"
    
    func getName() -> String {
        switch self {
        case .feet:
            return "height.feet".localized
        case .cm:
            return "height.meter".localized
        }
    }
    
}

struct ProfileInfo {
    
    var id: Int?
    var gender: Gender?
    var birthdate: String?
    var favoriteGame: Game?
    var heightInches: Double?
    var heightFeet: String?
    var heightCm: Double?
    var race: Race?
    var raceDisplay: String?
    var otherRace: String?
    var otherReligion: String?
    var occupation: String?
    var college: String?
    var religion: Religion?
    var religionDisplay: String?
    var politicalStance: PoliticalStance?
    var maritalStatus: MaritalStatus?
    var smoke: SmokingPreference?
    var drink: DrinkingPreference?
    var bio: String?
    var playerId: Int?
    var distanceType: DistanceType?
    var cpProgress: CPProgress?
    var ToTComplete = false
    var phoneNoVerified = false
    var profileComplete = false
    var languages = [String]()
    var haveKids: HaveKids?
    var zodiac: Zodiac?
    var likes = [String]()
    var dislikes = [String]()
    var heightType: HeightType?

    init(_ json: JSON) {
        id = json["id"].intValue
        gender = Gender(rawValue: json["gender"].stringValue)
        birthdate = json["birthdate"].stringValue
        favoriteGame = Game(rawValue: json["favorite_game"].stringValue)
        heightInches = json["height_inches"].double
        heightFeet = json["height_feet"].stringValue == "0'0" ? nil : json["height_feet"].stringValue 
        heightCm = json["height_cm"].double
        race = Race(rawValue: json["race"].stringValue)
        otherRace = json["other_race"].stringValue
        religion = Religion(rawValue: json["religion"].stringValue)
        college = json["college"].stringValue
        occupation = json["occupation"].stringValue
        otherReligion = json["other_religion"].stringValue
        politicalStance = PoliticalStance(rawValue: json["political_stance"].stringValue)
        maritalStatus = MaritalStatus(rawValue: json["marital_status"].stringValue)
        smoke = SmokingPreference(rawValue: json["smoke"].stringValue)
        drink = DrinkingPreference(rawValue: json["drink"].stringValue)
        bio = json["bio"].stringValue
        playerId = json["player_id"].int
        distanceType = DistanceType(rawValue: json["distance_type"].stringValue)
        cpProgress = CPProgress(rawValue: json["cp_progress"].intValue)
        ToTComplete = json["tot_complete"].boolValue
        phoneNoVerified = json["phone_no_verified"].boolValue
        profileComplete = json["profile_complete"].boolValue
        languages = (json["languages"].arrayValue.map({ $0.string ?? "" })).filter { !$0.isEmpty }
        haveKids = HaveKids(rawValue: json["have_kids"].stringValue)
        zodiac = Zodiac(rawValue: json["zodiac"].stringValue)
        likes = json["likes"].arrayValue.map { "\($0)" }
        dislikes = json["dislikes"].arrayValue.map { "\($0)" }
        religionDisplay = json["religion_display"].stringValue
        raceDisplay = json["race_display"].stringValue
        heightType = HeightType(rawValue: json["height_type"].stringValue) 
    }
    
    func getAge() -> Int? {
        return birthdate?.stringToBdayDate().age
    }
    
    func getAgeString() -> String {
        return birthdate?.stringToBdayDate().age == nil ? "" : "\(birthdate?.stringToBdayDate().age ?? 0)"
    }
    
}
