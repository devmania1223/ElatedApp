//
//  Date+Formatter.swift
//  Elated
//
//  Created by keenan warouw on 21/09/20.
//  Copyright © 2020 elatedteam. All rights reserved.
//

import Foundation

let backendDateFormat: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    return formatter
}()

let chatDateFormat: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    return formatter
}()


extension Date {
    struct Formatter {
        static let BackendFormat: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            return formatter
        }()
    }
    
    var chatTimestamp: String {
        return chatDateFormat.string(from: self)
    }
    
    var timestampAPI: String {
        return backendDateFormat.string(from: self)
    }
    
    func getLocalized(dateStyle: DateFormatter.Style = .short, withTime: Bool = false, timeStyle: DateFormatter.Style = .short) -> String {
        let myFormatter = DateFormatter()
        myFormatter.dateStyle = dateStyle
        if withTime == true {
            myFormatter.timeStyle = timeStyle
        }
        return myFormatter.string(from: self)
    }
    
    var age: Int {
        return Calendar.current.dateComponents([.year], from: self, to: Date()).year!
    }
    
    func dateToString() -> String {
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "yyyy-MM-dd"
        return formatter3.string(from: self)
    }
    
    func dateToMonthDay() -> String {
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "LLLL dd, yyyy"
        return formatter3.string(from: self)
    }
    
}
