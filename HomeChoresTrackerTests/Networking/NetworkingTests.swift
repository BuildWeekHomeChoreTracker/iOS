//
//  NetworkingTests.swift
//  HomeChoresTrackerTests
//
//  Created by Chad Rutherford on 2/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import XCTest
@testable import HomeChoresTracker

class NetworkingTests: XCTestCase {
    
    func testFetchChores() {
        let controller = ChildController()
        let loginExpectation = expectation(description: "Waiting to login")
        
        controller.login(with: "bobbyrocks", and: "test24") { error in
            XCTAssertNil(error)
            loginExpectation.fulfill()
        }
        
        wait(for: [loginExpectation], timeout: 10)
        XCTAssertNotNil(controller.bearer)
        
        let choresExpectation = expectation(description: "Waiting for chores to load")
        
        controller.getChores { error in
            XCTAssertNil(error)
            XCTAssert(!controller.chores.isEmpty)
            choresExpectation.fulfill()
        }
        
        wait(for: [choresExpectation], timeout: 10)
        XCTAssertTrue(controller.chores.count > 0)
    }
    
    func testfetchMockChores() {
        let mock = MockLoader()
        mock.data = goodChores
        
        let controller = ChildController(networkLoader: mock)
        controller.bearer = Bearer(token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiam9zaGQiLCJpYXQiOjE1ODA4MjI5MjYsImV4cCI6MTU4MDg1MTcyNn0.nB-vnFsyeKykP0e5cmntO7Jyc274X5zH1PbR3MYTYoA")
        let choresExpectation = expectation(description: "Waiting for chores to load")
        
        controller.getChores { error in
            XCTAssertNil(error)
            XCTAssert(!controller.chores.isEmpty)
            choresExpectation.fulfill()
        }
        
        wait(for: [choresExpectation], timeout: 2)
        XCTAssertTrue(controller.chores.count > 0)
        XCTAssertEqual(controller.chores[0].title, "wash dishes")
        XCTAssertEqual(controller.chores[0].score, 5)
    }
    
    func testBadMockDataReturnsNoChores() {
        let mock = MockLoader()
        mock.data = badChores
        
        let controller = ChildController(networkLoader: mock)
        controller.bearer = Bearer(token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiam9zaGQiLCJpYXQiOjE1ODA4MjI5MjYsImV4cCI6MTU4MDg1MTcyNn0.nB-vnFsyeKykP0e5cmntO7Jyc274X5zH1PbR3MYTYoA")
        let choresExpectation = expectation(description: "Waititng for chores to load")
        
        controller.getChores { error in
            if let error = error {
                XCTAssertNotNil(error)
            }
            XCTAssert(controller.chores.isEmpty)
            choresExpectation.fulfill()
        }
        
        wait(for: [choresExpectation], timeout: 2)
        XCTAssertFalse(controller.chores.count > 0)
    }
    
    func testGoodFetchNoMockData() {
        let mock = MockLoader()
        mock.data = noChores
        
        let controller = ChildController(networkLoader: mock)
        controller.bearer = Bearer(token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsInVzZXJuYW1lIjoiam9zaGQiLCJpYXQiOjE1ODA4MjI5MjYsImV4cCI6MTU4MDg1MTcyNn0.nB-vnFsyeKykP0e5cmntO7Jyc274X5zH1PbR3MYTYoA")
        let choresExpectation = expectation(description: "Waiting for chores to load")
        
        controller.getChores { error in
            XCTAssertNil(error)
            XCTAssert(controller.chores.isEmpty)
            choresExpectation.fulfill()
        }
        
        wait(for: [choresExpectation], timeout: 2)
        XCTAssertFalse(controller.chores.count > 0)
    }
}
