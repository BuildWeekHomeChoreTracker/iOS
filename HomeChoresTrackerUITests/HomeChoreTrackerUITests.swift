//
//  HomeChoreTrackerUITests.swift
//  HomeChoresTrackerUITests
//
//  Created by Chad Rutherford on 2/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import XCTest

class HomeChoreTrackerUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUp() {
        app = XCUIApplication()
        app.launch()
    }
    
    func testUserCanLogin() {
        let username = app.textFields["Username"]
        let password = app.secureTextFields["Password"]
        
        username.tap()
        username.typeText("bobbyrocks\n")
        password.tap()
        password.typeText("test24\n")
        app.buttons["Sign In"].tap()
        
        let exp = expectation(description: "Waiting for segue")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 6)
        XCTAssert(app.staticTexts["Chores"].exists)
    }
    
    func testImage() {
        let username = app.textFields["Username"]
        let password = app.secureTextFields["Password"]
        
        username.tap()
        username.typeText("bobbyrocks\n")
        password.tap()
        password.typeText("test24\n")
        app.buttons["Sign In"].tap()
        
        let exp = expectation(description: "Waiting for segue")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 4)
        XCTAssert(app.staticTexts["Chores"].exists)
        
        XCTAssertNotNil(app.cells)
        
        let cell = app.cells.staticTexts["UseDuster"]
        XCTAssertNotNil(cell)
        
        XCTAssertNotNil(cell.images["chore_bg"])
    }
}
