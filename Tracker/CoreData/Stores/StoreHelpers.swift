//
//  StoreHelpers.swift
//  Tracker
//
//  Created by Admin on 11/19/23.
//

import Foundation

final class StoreHelpers {
    
    private let uiColorMarshalling = UIColorMarshalling()
    
    func tracker(from trackerCoreData: TrackerCoreData) throws -> Tracker {
        guard let id = trackerCoreData.id else {
            throw TrackerStoreError.decodingErrorInvalidID
        }
        guard let name = trackerCoreData.name else {
            throw TrackerStoreError.decodingErrorInvalidName
        }
        guard let color = trackerCoreData.color else {
            throw TrackerStoreError.decodingErrorInvalidColor
        }
        guard let emoji = trackerCoreData.emoji else {
            throw TrackerStoreError.decodingErrorInvalidEmoji
        }
        guard let scheduleString = trackerCoreData.schedule else {
            throw TrackerStoreError.decodingErrorInvalidSchedule
        }
        
        let schedule = Schedule(days: weekDays(from: scheduleString))
        return Tracker(
            id: id,
            name: name,
            color: uiColorMarshalling.color(from:color),
            emoji: emoji,
            schedule: schedule
        )
    }
    
    func weekDays(from scheduleString: String) -> [WeekDay] {
        var weekDays: [WeekDay] = []
        scheduleString.components(separatedBy: ",").forEach{ day in
            switch day {
            case WeekDay.monday.rawValue: return weekDays.append(WeekDay.monday)
            case WeekDay.tuesday.rawValue: weekDays.append(WeekDay.tuesday)
            case WeekDay.wednesday.rawValue: weekDays.append(WeekDay.wednesday)
            case WeekDay.thursday.rawValue: weekDays.append(WeekDay.thursday)
            case WeekDay.friday.rawValue: weekDays.append(WeekDay.friday)
            case WeekDay.saturday.rawValue: weekDays.append(WeekDay.saturday)
            case WeekDay.sunday.rawValue: weekDays.append(WeekDay.sunday)
            default: weekDays.append(WeekDay.empty)
            }
        }
        return weekDays
    }
}
