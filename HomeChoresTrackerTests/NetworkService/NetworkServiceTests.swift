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
        let chore = ChoreRepresentation(bonusPoints: 5,
                                        childId: 5,
                                        cleanStreak: 5,
                                        comments: "",
                                        completed: 1,
                                        dueDate: "",
                                        id: 1,
                                        image: nil,
                                        information: "",
                                        parentId: 4,
                                        score: 5,
                                        title: "Wash Dishes")
        let status = NetworkService.encode(from: chore, request: request)
        let choreData = try? JSONEncoder().encode(chore)
        XCTAssertEqual(status.request?.httpBody, choreData)
    }
    
    func testCreateRequest() {
        var request = URLRequest(url: URL(string: "https://chore-tracker1.herokuapp.com/api/chore")!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let createdRequest = NetworkService.createRequest(url: URL(string: "https://chore-tracker1.herokuapp.com/api/chore"),
                                                          method: .get,
                                                          headerType: .contentType,
                                                          headerValue: .json)
        
        XCTAssertEqual(request, createdRequest)
    }
    
    func testDecodeChild() {
        let choreData = goodChores
        let chores = NetworkService.decode(to: AllChores.self, data: choreData) as? AllChores
        XCTAssertNotNil(chores)
        XCTAssert(!(chores?.chores.isEmpty)!)
        XCTAssertEqual(chores?.chores.last?.title, "Rake Yard")
    }
}
