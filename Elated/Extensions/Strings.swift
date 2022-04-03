//
//  Strings.swift
//  Elated
//
//  Created by Marlon on 2021/2/20.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import Foundation
import UIKit

extension String {
    static var empty: String { "" }
    static var emptySpace: String { " " }

    var isEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    static func randomFileName() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return "\(String((0..<8).map{ _ in letters.randomElement()! })).jpeg"
    }

    var localized: String {
        return LanguageManager.shared.localizedString(self)
    }

    func localizedFormat(_ arg: CVarArg...) -> String {
        return String(format: localized, arguments: arg)
    }

    func localizedFormat(_ args: [CVarArg]) -> String {
        return String(format: localized, arguments: args)
    }
    
    func stringToBdayDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: self) ?? Date()
        return date
    }
    
    func stringToBdayDateToReadable() -> String {
        let date = self.stringToBdayDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    func stringToPurchaseDate() -> String {
        let dateFormatter = ISO8601DateFormatter()
        guard let date = dateFormatter.date(from: self) else { return "" }
        return date.getLocalized(dateStyle: .long)
    }
    
    func stringToTimeAgo(_ format: ElatedDateFormat = .chat) -> String {
        var dateFormatter = chatDateFormat
        if format == .backend {
            dateFormatter = backendDateFormat
        }
        guard let date = dateFormatter.date(from: self) else { return "" }
        
//        if #available(iOS 13.0, *) {
//            let formatter = RelativeDateTimeFormatter()
//            formatter.unitsStyle = .full
//            return formatter.localizedString(for: date, relativeTo: Date())
//        }
    
        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date, to: Date())

        if let year = interval.year, year > 0 {
            return year == 1 ? "timeago.year".localizedFormat("\(year)") : "timeago.years".localizedFormat("\(year)")
        } else if let month = interval.month, month > 0 {
            return month == 1 ? "timeago.month".localizedFormat("\(month)") : "timeago.months".localizedFormat("\(month)")
        } else if let day = interval.day, day > 0 {
            return day == 1 ? "timeago.day".localizedFormat("\(day)") : "timeago.days".localizedFormat("\(day)")
        } else if let hour = interval.hour, hour > 0 {
            return hour == 1 ?  "timeago.hour".localizedFormat("\(hour)") : "timeago.hours".localizedFormat("\(hour)")
        } else if let minute = interval.minute, minute > 0 {
            return minute == 1 ? "timeago.minute".localizedFormat("\(minute)") : "timeago.minutes".localizedFormat("\(minute)")
        } else {
            return "timeago.moment".localized
        }
        
    }
}

//MARK: emojis
extension String {
    var isSingleEmoji: Bool { count == 1 && containsEmoji }

    var containsEmoji: Bool { contains { $0.isEmoji } }

    var containsOnlyEmoji: Bool { !isEmpty && !contains { !$0.isEmoji } }

    var emojiString: String { emojis.map { String($0) }.reduce("", +) }
    
    var emojiStringWithSpaces: String { emojis.map { String($0) }.reduce(" ", +) }

    var emojis: [Character] { filter { $0.isEmoji } }

    var emojiScalars: [UnicodeScalar] { filter { $0.isEmoji }.flatMap { $0.unicodeScalars } }
}

extension Character {
    var isSimpleEmoji: Bool {
        guard let firstScalar = unicodeScalars.first else { return false }
        return firstScalar.properties.isEmoji && firstScalar.value > 0x238C
    }

    var isCombinedIntoEmoji: Bool { unicodeScalars.count > 1 && unicodeScalars.first?.properties.isEmoji ?? false }

    var isEmoji: Bool { isSimpleEmoji || isCombinedIntoEmoji }
}

extension String {
    //  Reference: https://stackoverflow.com/questions/5533851/format-uilabel-with-bullet-points
    static func bulletList(stringList: [String],
                           font: UIFont,
                           bullet: String = "•",
                           indentation: CGFloat = 10,
                           lineSpacing: CGFloat = 2,
                           paragraphSpacing: CGFloat = 6,
                           textColor: UIColor = .white,
                           bulletColor: UIColor = .white) -> NSAttributedString {
        
        let textAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: textColor]
        let bulletAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: bulletColor]
        
        let paragraphStyle = NSMutableParagraphStyle()
        let nonOptions = [NSTextTab.OptionKey: Any]()
        paragraphStyle.tabStops = [
            NSTextTab(textAlignment: .left, location: indentation, options: nonOptions)]
        paragraphStyle.defaultTabInterval = indentation
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.paragraphSpacing = paragraphSpacing
        paragraphStyle.headIndent = indentation
        
        let bulletList = NSMutableAttributedString()
        for string in stringList {
            let formattedString = "\(bullet)\t\(string)\(string != stringList.last ? "\n" : "")"
            let attributedString = NSMutableAttributedString(string: formattedString)
            
            attributedString.addAttributes(
                [NSAttributedString.Key.paragraphStyle : paragraphStyle],
                range: NSMakeRange(0, attributedString.length))
            
            attributedString.addAttributes(
                textAttributes,
                range: NSMakeRange(0, attributedString.length))
            
            let string:NSString = NSString(string: formattedString)
            let rangeForBullet:NSRange = string.range(of: bullet)
            attributedString.addAttributes(bulletAttributes, range: rangeForBullet)
            bulletList.append(attributedString)
        }
        
        return bulletList
    }
        
}
