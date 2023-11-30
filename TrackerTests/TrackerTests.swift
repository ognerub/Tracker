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
        assertSnapshots(matching: vc, as: [.image])
    }

}
