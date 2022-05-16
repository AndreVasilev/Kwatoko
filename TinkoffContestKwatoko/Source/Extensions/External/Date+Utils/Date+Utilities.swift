import Foundation

// Thanks: AshFurrow, sstreza, Scott Lawrence, Kevin Ballard, NoOneButMe, Avi`, August Joki, Lily Vulcano, jcromartiej, Blagovest Dachev, Matthias Plappert,  Slava Bushtruk, Ali Servet Donmez, Ricardo1980, pip8786, Danny Thuerin, Dennis Madsen, Greg Titus, Jim Morrison, aclark, Marcin Krzyzanowski, dmitrydims, Sebastian Celis, Seyithan Teymur,

/// Shared static properties
extension Date {
    /// Returns common shared calendar, user's preferred calendar
    /// This calendar tracks changes to user’s preferred calendar identifier
    /// unlike `current`.
    static var sharedCalendar = Calendar.autoupdatingCurrent
    /// Returns the current time
    static var now: Date { return Date() }
}


/// Inherent date properties / component retrieval
/// Some of these are entirely pointless but I have included all components
extension Date {
    
    /// Returns date's time interval since reference date
    var interval: TimeInterval { return self.timeIntervalSinceReferenceDate }
    
    
    // MARK: YMD
    
    /// Returns instance's year component
    var year: Int { return Date.sharedCalendar.component(.year, from: self) }
    /// Returns instance's month component
    var month: Int { return Date.sharedCalendar.component(.month, from: self) }
    /// Returns instance's day component
    var day: Int { return Date.sharedCalendar.component(.day, from: self) }
    /// Returns instance's hour component
    
    
    // MARK: HMS
    
    var hour: Int { return Date.sharedCalendar.component(.hour, from: self) }
    /// Returns instance's minute component
    var minute: Int { return Date.sharedCalendar.component(.minute, from: self) }
    /// Returns instance's second component
    var second: Int { return Date.sharedCalendar.component(.second, from: self) }
    /// Returns instance's nanosecond component
    var nanosecond: Int { return Date.sharedCalendar.component(.nanosecond, from: self) }
    
    // MARK: Weeks
    
    /// Returns instance's weekday component
    var weekday: Int { return Date.sharedCalendar.component(.weekday, from: self) }
    /// Returns instance's weekdayOrdinal component
    var weekdayOrdinal: Int { return Date.sharedCalendar.component(.weekdayOrdinal, from: self) }
    /// Returns instance's weekOfMonth component
    var weekOfMonth: Int { return Date.sharedCalendar.component(.weekOfMonth, from: self) }
    /// Returns instance's weekOfYear component
    var weekOfYear: Int { return Date.sharedCalendar.component(.weekOfYear, from: self) }
    /// Returns instance's yearForWeekOfYear component
    var yearForWeekOfYear: Int { return Date.sharedCalendar.component(.yearForWeekOfYear, from: self) }
    
    // MARK: Other
    
    /// Returns instance's quarter component
    var quarter: Int { return Date.sharedCalendar.component(.quarter, from: self) }
    /// Returns instance's (meaningless) era component
    var era: Int { return Date.sharedCalendar.component(.era, from: self) }
    /// Returns instance's (meaningless) calendar component
    var calendar: Int { return Date.sharedCalendar.component(.calendar, from: self) }
    /// Returns instance's (meaningless) timeZone component.
    var timeZone: Int { return Date.sharedCalendar.component(.timeZone, from: self) }
}

// Date characteristics
extension Date {
    /// Returns true if date falls before current date
    var isPast: Bool { return self < Date() }
    
    /// Returns true if date falls after current date
    var isFuture: Bool { return self > Date() }
    
    /// Returns true if date falls on typical weekend
    var isTypicallyWeekend: Bool {
        return Date.sharedCalendar.isDateInWeekend(self)
    }
    /// Returns true if date falls on typical workday
    var isTypicallyWorkday: Bool { return !self.isTypicallyWeekend }
}

// Date distances
extension Date {
    /// Returns the time interval between two dates
    static func interval(_ date1: Date, _ date2: Date) -> TimeInterval {
        return date2.interval - date1.interval
    }
    
    /// Returns a time interval between the instance and another date
    func interval(to date: Date) -> TimeInterval {
        return Date.interval(self, date)
    }
    
    /// Returns the distance between two dates
    /// using the user's preferred calendar
    /// e.g.
    /// ```
    /// let date1 = Date.shortDateFormatter.date(from: "1/1/16")!
    /// let date2 = Date.shortDateFormatter.date(from: "3/13/16")!
    /// Date.distance(date1, to: date2, component: .day) // 72
    /// ```
    /// - Warning: Returns 0 for bad components rather than crashing
    static func distance(_ date1: Date, to date2: Date, component: Calendar.Component) -> Int {
        return Date.sharedCalendar.dateComponents([component], from: date1, to: date2)[component] ?? 0
    }
    
    /// Returns the distance between the instance and another date
    /// using the user's preferred calendar
    /// e.g.
    /// ```
    /// let date1 = Date.shortDateFormatter.date(from: "1/1/16")!
    /// let date2 = Date.shortDateFormatter.date(from: "3/13/16")!
    /// date1.distance(to: date2, component: .day) // 72
    /// ```
    /// - Warning: Returns 0 for bad components rather than crashing
    func distance(to date: Date, component: Calendar.Component) -> Int {
        return Date.sharedCalendar.dateComponents([component], from: self, to: date)[component] ?? 0
    }
    
    /// Returns the number of days between the instance and a given date. May be negative
    func days(to date: Date) -> Int { return distance(to: date, component: .day) }
    /// Returns the number of hours between the instance and a given date. May be negative
    func hours(to date: Date) -> Int { return distance(to: date, component: .hour) }
    /// Returns the number of minutes between the instance and a given date. May be negative
    func minutes(to date: Date) -> Int { return distance(to: date, component: .minute) }
    /// Returns the number of seconds between the instance and a given date. May be negative
    func seconds(to date: Date) -> Int { return distance(to: date, component: .second) }
    
    /// Returns a (days, hours, minutes, seconds) tuple representing the
    /// time remaining between the instance and a target date.
    /// Not for exact use. For example:
    ///
    /// ```
    /// let test = Date().addingTimeInterval(5.days + 3.hours + 2.minutes + 10.seconds)
    /// print(Date().offsets(to: test))
    /// // prints (5, 3, 2, 10 or possibly 9 but rounded up)
    /// ```
    ///
    /// - Warning: returns 0 for any error when fetching component
    func offsets(to date: Date) -> (days: Int, hours: Int, minutes: Int, seconds: Int) {
        let components = Date.sharedCalendar
            .dateComponents([.day, .hour, .minute, .second],
                            from: self, to: date.addingTimeInterval(0.5)) // round up
        return (
            days: components[.day] ?? 0,
            hours: components[.hour] ?? 0,
            minutes: components[.minute] ?? 0,
            seconds: components[.second] ?? 0
        )
    }
}

// Utility
extension Date {
    /// Return the nearest hour using a 24 hour clock
    var nearestHour: Int { return (self.offset(.minute, 30)).hour }
    
    /// Return the nearest minute
    var nearestMinute: Int { return (self.offset(.second, 30)).minute }
}

// Canonical dates
extension Date {
    
    /// Returns a date representing midnight at the start of this day
    var startOfDay: Date {
        let midnight = DateComponents(year: components.year, month: components.month, day: components.day)
        // If offset is not possible, return unmodified date
        return Date.sharedCalendar.date(from: midnight) ?? self
    }
    /// Returns a date representing midnight at the start of this day.
    /// Is synonym for `startOfDay`.
    var today: Date { return self.startOfDay }
    /// Returns a date representing midnight at the start of tomorrow
    var tomorrow: Date { return self.today.offset(.day, 1) }
    /// Returns a date representing midnight at the start of yesterday
    var yesterday: Date { return self.today.offset(.day, -1) }
    
    /// Returns today's date at the midnight starting the day
    static var today: Date { return Date().startOfDay }
    /// Returns tomorrow's date at the midnight starting the day
    static var tomorrow: Date { return Date.today.offset(.day, 1) }
    /// Returns yesterday's date at the midnight starting the day
    static var yesterday: Date { return Date.today.offset(.day, -1) }
    
    /// Returns a date representing a second before midnight at the end of the day
    var endOfDay: Date { return self.tomorrow.startOfDay.offset(.second, -1) }
    /// Returns a date representing a second before midnight at the end of today
    static var endOfToday: Date { return Date().endOfDay }
    
    /// Determines whether two days share the same date
    static func sameDate(_ date1: Date, _ date2: Date) -> Bool {
        return Date.sharedCalendar.isDate(date1, inSameDayAs: date2)
    }
    
    /// Returns true if this date is the same date as today for the user's preferred calendar
    var isToday: Bool { return Date.sharedCalendar.isDateInToday(self) }
    /// Returns true if this date is the same date as tomorrow for the user's preferred calendar
    var isTomorrow: Bool { return Date.sharedCalendar.isDateInTomorrow(self) }
    /// Returns true if this date is the same date as yesterday for the user's preferred calendar
    var isYesterday: Bool { return Date.sharedCalendar.isDateInYesterday(self) }
    
    /// Returns the start of the instance's week of year for user's preferred calendar
    var startOfWeek: Date {
        let components = self.allComponents
        let startOfWeekComponents = DateComponents(weekOfYear: components.weekOfYear, yearForWeekOfYear: components.yearForWeekOfYear)
        // If offset is not possible, return unmodified date
        return Date.sharedCalendar.date(from: startOfWeekComponents) ?? self
    }
    /// Returns the start of the current week of year for user's preferred calendar
    static var thisWeek: Date {
        return Date().startOfWeek
    }
    
    /// Returns the start of next week of year for user's preferred calendar
    var nextWeek: Date { return self.offset(.weekOfYear, 1) }
    /// Returns the start of last week of year for user's preferred calendar
    var lastWeek: Date { return self.offset(.weekOfYear, -1) }
    /// Returns the start of next week of year for user's preferred calendar relative to date
    static var nextWeek: Date { return Date().offset(.weekOfYear, 1) }
    /// Returns the start of last week of year for user's preferred calendar relative to date
    static var lastWeek: Date { return Date().offset(.weekOfYear, -1) }
    
    /// Returns true if two weeks likely fall within the same week of year
    /// in the same year, or very nearly the same year
    static func sameWeek(_ date1: Date, _ date2: Date) -> Bool {
        return date1.startOfWeek == date2.startOfWeek
    }
    
    /// Returns true if date likely falls within the current week of year
    var isThisWeek: Bool { return Date.sameWeek(self, Date.thisWeek) }
    /// Returns true if date likely falls within the next week of year
    var isNextWeek: Bool { return Date.sameWeek(self, Date.nextWeek) }
    /// Returns true if date likely falls within the previous week of year
    var isLastWeek: Bool { return Date.sameWeek(self, Date.lastWeek) }
    
    /// Returns the start of month for the user's preferred calendar
    static var thisMonth: Date {
        let components = Date().components
        let themonth = DateComponents(year: components.year, month: components.month)
        // If offset is not possible, return unmodified date
        return Date.sharedCalendar.date(from: themonth) ?? Date()
    }
    /// Returns the start of next year for the user's preferred calendar
    static var nextMonth: Date { return thisMonth.offset(.month, 1) }
    /// Returns the start of previous year for the user's preferred calendar
    static var lastMonth: Date { return thisMonth.offset(.month, -1) }
    
    /// Returns true if two dates share the same month component
    static func sameMonth(_ date1: Date, _ date2: Date) -> Bool {
        return (date1.allComponents.year == date2.allComponents.year) &&
            (date1.allComponents.month == date2.allComponents.month)
    }
    
    /// Returns true if date falls within this month for the user's preferred calendar
    var isThisMonth: Bool { return Date.sameMonth(self, Date.thisMonth) }
    /// Returns true if date falls within next month for the user's preferred calendar
    var isNextMonth: Bool { return Date.sameMonth(self, Date.nextMonth) }
    /// Returns true if date falls within previous month for the user's preferred calendar
    var isLastMonth: Bool { return Date.sameMonth(self, Date.nextMonth) }
    
    /// Returns the start of year for the user's preferred calendar
    static var thisYear: Date {
        let components = Date().components
        let theyear = DateComponents(year: components.year)
        // If offset is not possible, return unmodified date
        return Date.sharedCalendar.date(from: theyear) ?? Date()
    }
    /// Returns the start of next year for the user's preferred calendar
    static var nextYear: Date { return thisYear.offset(.year, 1) }
    /// Returns the start of previous year for the user's preferred calendar
    static var lastYear: Date { return thisYear.offset(.year, -1) }
    
    /// Returns true if two dates share the same year component
    static func sameYear(_ date1: Date, _ date2: Date) -> Bool {
        return date1.allComponents.year == date2.allComponents.year
    }
    
    /// Returns true if date falls within this year for the user's preferred calendar
    var isThisYear: Bool { return Date.sameYear(self, Date.thisYear) }
    /// Returns true if date falls within next year for the user's preferred calendar
    var isNextYear: Bool { return Date.sameYear(self, Date.nextYear) }
    /// Returns true if date falls within previous year for the user's preferred calendar
    var isLastYear: Bool { return Date.sameYear(self, Date.lastYear) }
}
