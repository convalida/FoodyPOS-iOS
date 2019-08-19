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
    
    /// Get today's date in proper date format in MM/dd/yyyy" using Date and DateFormatter class which is pre defined class
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

///Rajat ji please update this as todayDate is already defined
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
    
    /// Find next or previous occourance of a weekday from current or a particular date. Used find previous occurance of Monday. Rajat ji kindly elaborate this, with flow.
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
    Get start date of current year in yyyy format to string format using Date and DateFormatter class which is pre defined class.
    Rajat ji kindly elaborate the flow if possible and also which of the two formats- yyyy or hh dd-MM-yyyy is used,
    also if hh is set to 10 and reason if so.
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
    /// Returns  list of weekdays in this calendar, localized to the Calendar’s locale is set to gregorian identifier. Rajat ji please check/update this
    func getWeekDaysInEnglish() -> [String] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar.weekdaySymbols
    }
    
    enum Weekday: String {
        case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    }
    
    enum SearchDirection {
        case Next
        case Previous
        
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
