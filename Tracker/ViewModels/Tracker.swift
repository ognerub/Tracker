//
//  Tracker.swift
//  Tracker
//
//  Created by Admin on 10/14/23.
//

import UIKit

struct Tracker: Identifiable {    
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: Schedule
}

struct TrackerForCoreData: Identifiable {
    let id: UUID
    let name: String
    let color: NSData
    let emoji: String
    let schedule: NSData
}
