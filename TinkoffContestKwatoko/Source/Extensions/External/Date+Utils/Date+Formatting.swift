import Foundation

// Acknowlegements in Date+Utilities.swift

// Formatters and Strings
extension Date {
    /// Returns an ISO 8601 formatter set to locale
    /// Thanks, Daniel Marques, https://github.com/erica/SwiftDates/issues/2
    static var iso8601Formatter: ISO8601DateFormatter = {
        $0.timeZone = TimeZone.autoupdatingCurrent
        return $0 }(ISO8601DateFormatter())
    /// Returns a short style date formatter
    static var shortDateFormatter: DateFormatter = {
        $0.dateStyle = .short; return $0 }(DateFormatter())
    /// Returns a medium style date formatter
    static var mediumDateFormatter: DateFormatter = {
        $0.dateStyle = .medium; return $0 }(DateFormatter())
    /// Returns a long style date formatter
    static var longDateFormatter: DateFormatter = {
        $0.dateStyle = .long; return $0 }(DateFormatter())
    /// Returns a full style date formatter
    static var fullDateFormatter: DateFormatter = {
        $0.dateStyle = .full; return $0 }(DateFormatter())
    /// Returns a short style time formatter
    static var shortTimeFormatter: DateFormatter = {
        $0.timeStyle = .short; return $0 }(DateFormatter())
    /// Returns a medium style time formatter
    static var mediumTimeFormatter: DateFormatter = {
        $0.timeStyle = .medium; return $0 }(DateFormatter())
    /// Returns a long style time formatter
    static var longTimeFormatter: DateFormatter = {
        $0.timeStyle = .long; return $0 }(DateFormatter())
    /// Returns a full style time formatter
    static var fullTimeFormatter: DateFormatter = {
        $0.timeStyle = .full; return $0 }(DateFormatter())
    
    /// Represents date as ISO8601 string
    var iso8601String: String { return Date.iso8601Formatter.string(from: self) }
    
    /// Returns date components as short string
    var shortDateString: String { return Date.shortDateFormatter.string(from:self) }
    /// Returns date components as medium string
    var mediumDateString: String { return Date.mediumDateFormatter.string(from:self) }
    /// Returns date components as long string
    var longDateString: String { return Date.longDateFormatter.string(from:self) }
    /// Returns date components as full string
    var fullDateString: String { return Date.fullDateFormatter.string(from:self) }
    
    /// Returns time components as short string
    var shortTimeString: String { return Date.shortTimeFormatter.string(from:self) }
    /// Returns time components as medium string
    var mediumTimeString: String { return Date.mediumTimeFormatter.string(from:self) }
    /// Returns time components as long string
    var longTimeString: String { return Date.longTimeFormatter.string(from:self) }
    /// Returns time components as full string
    var fullTimeString: String { return Date.fullTimeFormatter.string(from:self) }
    
    /// Returns date and time components as short string
    var shortString: String { return "\(self.shortDateString) \(self.shortTimeString)" }
    /// Returns date and time components as medium string
    var mediumString: String { return "\(self.mediumDateString) \(self.mediumTimeString)" }
    /// Returns date and time components as long string
    var longString: String { return "\(self.longDateString) \(self.longTimeString)" }
    /// Returns date and time components as full string
    var fullString: String { return "\(self.fullDateString) \(self.fullTimeString)" }
    
    func string(format:String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
