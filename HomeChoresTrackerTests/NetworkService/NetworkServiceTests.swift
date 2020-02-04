//
//  NetworkServiceTests.swift
//  HomeChoresTrackerTests
//
//  Created by Chad Rutherford on 2/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import XCTest
@testable import HomeChoresTracker

class NetworkServiceTests: XCTestCase {
    
    func testNetworkServiceEncode() {
        let request = URLRequest(url: URL(string: "https://chore-tracker1.herokuapp.com/api/chore")!)
        let child = ChildRepresentation(name: "Bobby", parentName: "Dave", cleanStreak: 5, chores: [])
        let status = NetworkService.encode(from: child.self, request: request)
        let childData = try! JSONEncoder().encode(child)
        XCTAssertEqual(status.request?.httpBody, childData)
    }
    
    func testCreateRequest() {
        var request = URLRequest(url: URL(string: "https://chore-tracker1.herokuapp.com/api/chore")!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let createdRequest = NetworkService.createRequest(url: URL(string: "https://chore-tracker1.herokuapp.com/api/chore"), method: .get, headerType: .contentType, headerValue: .json)
        
        XCTAssertEqual(request, createdRequest)
    }
    
    func testDecodeChild() {
        let choreData = goodChores
        let chores = NetworkService.decode(to: ChoreRepresentation.self, data: choreData) as! [ChoreRepresentation]
        XCTAssertNotNil(chores)
        XCTAssert(chores.count > 0)
        XCTAssertEqual(chores.last?.title, "clean room")
    }
}
