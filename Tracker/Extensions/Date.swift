//
//  Date.swift
//  Tracker
//
//  Created by Admin on 10/29/23.
//

import Foundation

extension Date {
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, dd MMM yyyy HH:mm:ss Z"
        formatter.timeZone = .current
        return formatter
    }()
    
    var formatted: String {
        return Date.formatter.string(from: self)
    }
    
    var onlyDate: Date? {
        get {
            let calendar = Calendar.current
            var dateComponents = calendar.dateComponents([.year, .month, .day
                                                         ], from: self)
            dateComponents.timeZone = NSTimeZone.system
            return calendar.date(from: dateComponents)
        }
    }
    
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
    
    func dayOfWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
}

extension String {
    func dateFromISO8601String() -> Date {
        var formatDate = self
        let isoDateFormatter = ISO8601DateFormatter()
        if let date = isoDateFormatter.date(from: self) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .none
            formatDate = dateFormatter.string(from: date)
            return date
        }
        return isoDateFormatter.date(from: self) ?? Date()
    }
    
}
