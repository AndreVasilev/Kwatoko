//
//  DateFormatter+formats.swift
//  Pay.Travel-Billfold
//
//  Created by  User on 24/10/2019.
//  Copyright © 2019 Andrey Vasilev. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    static let full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone.current//TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    static let ddMMM: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone.current//TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.shortMonthSymbols = ["Янв", "Фев", "Мар", "Апр", "Мая", "Июн", "Июл", "Авг", "Сен", "Окт", "Ноя", "Дек"]
        return formatter
    }()
    
    static let hoursAndMinutes: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone.current//TimeZone(abbreviation: "UTC")
        return formatter
    }()
    
    static let hoursAndMinutesAndSeconds: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        formatter.timeZone = TimeZone.current//TimeZone(abbreviation: "UTC")
        return formatter
    }()
    

    static let ddMMMM: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone.current//TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    static let ddMMMyyyy: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy "
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone.current//TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()

    static let relativeDate: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.autoupdatingCurrent // Using system locale
        dateFormatter.doesRelativeDateFormatting = true // Enabling relative date formatting
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
    
    static let serverDate: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter
    }()
    
    func sortServerDatesToFindNewest(firstDate: String?, secondDate: String?) -> Bool? {
        guard let unFD = firstDate, let unSD = secondDate else { return nil }
        guard let fDate = self.date(from: unFD), let sDate = self.date(from: unSD) else { return nil }
        return fDate.timeIntervalSince(sDate) >= 0
    }
    
    static func getServerDateDayMonth(stringDate: String?) -> String {
        guard let sD = stringDate, let date = DateFormatter.full.date(from: sD) else { return "Error" }
        let dateFormatter = DateFormatter.ddMMM
        if Calendar.current.component(.day, from: date) < 10 { dateFormatter.dateFormat = "d MMM" }
        return dateFormatter.string(from: date)
    }
    
    static func getServerDateTime(stringDate: String?) -> String {
        guard let sD = stringDate, let date = DateFormatter.full.date(from: sD) else { return "Error" }
        return DateFormatter.hoursAndMinutes.string(from: date)
        
    }
}

