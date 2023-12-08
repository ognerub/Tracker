//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Admin on 11/30/23.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {
    
    func testViewController() throws {
        
        let vc = TrackersListViewController()
        let trackerStore = TrackerStore()
        let trackerCategoryStore = TrackerCategoryStore()
        let trackerRecordStore = TrackerRecordStore()
        
        try trackerStore.deleteAll()
        try trackerCategoryStore.deleteAll()
        try trackerRecordStore.deleteAll()
        
        let category = trackerCategoryStore.createMockCategory()
        try trackerCategoryStore.addNewTrackerCategory(category)
        
        let tracker = trackerStore.createMockTracker()
        try trackerStore.addNewTracker(tracker, selectedCategoryRow: 0)
        
        assertSnapshots(matching: vc, as: [.image])
    }

}
