//
//  ChildTests.swift
//  HomeChoresTrackerTests
//
//  Created by Chad Rutherford on 2/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import XCTest
@testable import HomeChoresTracker

class ChildTests: XCTestCase {
    
    func testChildCreation() {
        let childRep = ChildRepresentation(name: "Bobby", parentName: "Dave", cleanStreak: 40, chores: [])
        XCTAssertEqual(childRep.name, "Bobby")
        let child = Child(representation: childRep)
        XCTAssertEqual(child?.name, childRep.name)
        let childRep2 = child?.childRepresentation
        XCTAssertEqual(child?.name, childRep2?.name)
    }
}
