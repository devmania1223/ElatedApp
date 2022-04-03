//
//  Settings.swift
//  Elated
//
//  Created by Marlon on 2021/3/18.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Settings {
    
    var id: Int?
    var active: Bool?
    var showOnlineStatus: Bool?
    var soundOn: Bool?
    var vibrateOn: Bool?
    var showOnscreenNotification: Bool?
    var user: Int?
    var notificationFrequency: NotificationFrequency?
    
    init(_ json: JSON) {
        id = json["id"].intValue
        active = json["active"].boolValue
        showOnlineStatus = json["show_online_status"].boolValue
        soundOn = json["sound_on"].boolValue
        vibrateOn = json["vibrate_on"].boolValue
        showOnscreenNotification = json["show_onscreen_notification"].boolValue
        user = json["user"].intValue
        notificationFrequency =  NotificationFrequency(rawValue: json["notification_frequency"].stringValue)
    }


}
