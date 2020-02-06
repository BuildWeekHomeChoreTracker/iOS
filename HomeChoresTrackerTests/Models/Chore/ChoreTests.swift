//
//  ChoreTests.swift
//  HomeChoresTrackerTests
//
//  Created by Chad Rutherford on 2/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import XCTest
@testable import HomeChoresTracker

class ChoreTests: XCTestCase {
    
    func testChoreCreation() {
        let choreRep = ChoreRepresentation(bonusPoints: 5,
                                           childId: 7,
                                           cleanStreak: 5,
                                           comments: "",
                                           completed: 1,
                                           dueDate: "",
                                           id: 1,
                                           image: nil,
                                           information: "",
                                           parentId: 4,
                                           score: 5,
                                           title: "Wash Clothes")
        XCTAssertEqual(choreRep.title, "Wash Clothes")
        let chore = Chore(representation: choreRep)
        XCTAssertEqual(chore?.title, choreRep.title)
        let choreRep2 = chore?.choreRepresentation
        XCTAssertEqual(chore?.title, choreRep2?.title)
    }
}
