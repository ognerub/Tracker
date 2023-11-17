//
//  Schedule.swift
//  Tracker
//
//  Created by Admin on 10/14/23.
//

import Foundation

struct Schedule: Codable {
    let days: [WeekDay]
}

enum WeekDay: String, CaseIterable, Codable {
    case monday = "Monday"
    case tuesday = "Tuesday"
    case wednesday = "Wednesday"
    case thursday = "Thursday"
    case friday = "Friday"
    case saturday = "Saturday"
    case sunday = "Sunday"
    case empty = ""
}
