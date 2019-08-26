//
//  Date.swift
//  FoodyPOS
//
//  Created by Tutist Dev on 10/08/18.
//  Copyright © 2018 com.tutist. All rights reserved.
//

import Foundation
///Format of date
let dateFormat = "MM/dd/yyyy"
extension Date {
    
    /// Get today's date in proper date format in "MM/dd/yyyy" using Date and DateFormatter class which is pre defined class. The date is returned in String format.
    static var todayDate:String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter.string(from: date)
    }
    
    /// Format date according to given format as string using DateFormatter class which is pre defined class
    func getDateString(format:String = dateFormat) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    /// Get formatted date from string (which is passed) in format MM/dd/yyyy using DateFormatter class which is pre defined class
    static func getDate(fromString string:String, format:String = dateFormat) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: string)
    }
}

extension Date {

    ///Returns today's date as Date type
    static func today() -> Date {
        return Date()
    }
    
    /// Find next occourance of a weekday from current date without considering today's date
    func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
        return get(.Next,
                   weekday,
                   considerToday: considerToday)
    }
    
    /// Find previous occourance of a weekday from current date considering today's date. 
    func previous(_ weekday: Weekday, considerToday: Bool = true) -> Date {
        return get(.Previous,
                   weekday,
                   considerToday: considerToday)
    }
    
    /// Find next or previous occourance of a weekday from current or a particular date. Used find previous occurance of Monday. This all belongs to Calendar functionlity
    func get(_ direction: SearchDirection,
             _ weekDay: Weekday,
             considerToday consider: Bool = false) -> Date {
        
        let dayName = weekDay.rawValue
        
        let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }
        
        assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")
        
        let searchWeekdayIndex = weekdaysName.index(of: dayName)! + 1
        
        let calendar = Calendar(identifier: .gregorian)
        
        if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
            return self
        }
        
        var nextDateComponent = DateComponents()
        nextDateComponent.weekday = searchWeekdayIndex
        
        
        let date = calendar.nextDate(after: self,
                                     matching: nextDateComponent,
                                     matchingPolicy: .nextTime,
                                     direction: direction.calendarSearchDirection)
        
        return date!
    }
    
    /// Get start date of current month
    static func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: Date())))!
    }
    
    
    /// Get End date of current month
    static func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    /**
    Get start date of current year. Get current year in yyyy format using Date and DateFormatter class which is 
    pre defined class, then get the first date of current year in hh dd-MM-yyyy format 
    (hh is set to 10 due to timezone offset variance in various timezones) and if it is not null, then return it. 
    */
    static func startOfYear() -> Date {
        var currentYear = Date()
        currentYear = Date()
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "yyyy"
        let currentYearString = formatter1.string(from: currentYear)
        
        //Get first date of current year
        let firstDateString = "10 01-01-\(currentYearString)"
        let formatter2 = DateFormatter()
        formatter2.dateFormat = "hh dd-MM-yyyy"
        var firstDate = Date()
        if let aString = formatter2.date(from: firstDateString) {
            firstDate = aString
        }
        return firstDate
    }
}

// MARK: Helper methods
extension Date {
    /// Returns  list of weekdays in this calendar, localized to the Calendar’s locale is set to gregorian identifier.
    func getWeekDaysInEnglish() -> [String] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar.weekdaySymbols
    }
    
    ///Enum for weekdays string
    enum Weekday: String {
        ///Case if day is Monday
        case monday
        ///Case if day is Tuesday
        case tuesday
        ///Case if day is Wednesday
        case wednesday
        ///Case if day is Thurday
        case thursday
        ///Case if day is Friday
        case friday
        ///Case if day is Saturday
        case saturday
        ///Case if day is Sunday
        case sunday
    }
    
    ///Enum for direction of search for occurance of weekday.
    enum SearchDirection {
        ///Case when next occurance of weekday is searched
        case Next
        ///Case when previous occurance of weekday is searched
        case Previous

       /**
        Determine weekday's occurance search direction. If Next is passed in SearchDirection, then direction of
       search is forward, if Previous is passed in SearchDirection, direction of search is backward.
       */
        var calendarSearchDirection: Calendar.SearchDirection {
            switch self {
            case .Next:
                return .forward
            case .Previous:
                return .backward
            }
        }
    }
}
