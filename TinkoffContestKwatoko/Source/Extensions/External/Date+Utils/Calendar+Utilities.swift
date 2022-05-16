import Foundation

// Acknowlegements in Date+Utilities.swift

// Calendar functionality for date component retrieval
// Some of these are entirely pointless but I have included all components
extension Calendar {
    /// Returns instance's year component
    func year(of date: Date) -> Int { return component(.year, from: date) }
    /// Returns instance's month component
    func month(of date: Date) -> Int { return component(.month, from: date) }
    /// Returns instance's day component
    func day(of date: Date) -> Int { return component(.day, from: date) }
    /// Returns instance's hour component
    func hour(of date: Date) -> Int { return component(.hour, from: date) }
    /// Returns instance's minute component
    func minute(of date: Date) -> Int { return component(.minute, from: date) }
    /// Returns instance's second component
    func second(of date: Date) -> Int { return component(.second, from: date) }
    
    /// Returns instance's weekday component
    func weekday(of date: Date) -> Int { return component(.weekday, from: date) }
    /// Returns instance's weekdayOrdinal component
    func weekdayOrdinal(of date: Date) -> Int { return component(.weekdayOrdinal, from: date) }
    /// Returns instance's weekOfMonth component
    func weekOfMonth(of date: Date) -> Int { return component(.weekOfMonth, from: date) }
    /// Returns instance's weekOfYear component
    func weekOfYear(of date: Date) -> Int { return component(.weekOfYear, from: date) }
    
    /// Returns instance's yearForWeekOfYear component
    func yearForWeekOfYear(of date: Date) -> Int { return component(.yearForWeekOfYear, from: date) }
    
    /// Returns instance's quarter component
    func quarter(of date: Date) -> Int { return component(.quarter, from: date) }
    
    /// Returns instance's nanosecond component
    func nanosecond(of date: Date) -> Int { return component(.nanosecond, from: date) }
    /// Returns instance's (meaningless) era component
    func era(of date: Date) -> Int { return component(.era, from: date) }
    /// Returns instance's (meaningless) calendar component
    func calendar(of date: Date) -> Int { return component(.calendar, from: date) }
    /// Returns instance's (meaningless) timeZone component.
    func timeZone(of date: Date) -> Int { return component(.timeZone, from: date) }
    
    /// Extracts common date components for date
    func commonComponents(of date: Date) -> DateComponents { return dateComponents(Date.commonComponents, from: date) }
    /// Extracts all date components for date
    func allComponents(of date: Date) -> DateComponents { return dateComponents(Date.allComponents, from: date) }
}

