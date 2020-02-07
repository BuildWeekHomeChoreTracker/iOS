//
//  XCUIElement+Ext.swift
//  HomeChoresTrackerUITests
//
//  Created by Chad Rutherford on 2/6/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import XCTest

extension XCUIElement {
    func clearandEnterText(text: String) {
        guard let stringValue = self.value as? String else {
            XCTFail("Tried to clear and enter text into a non-string value")
            return
        }
        
        self.tap()
        
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        self.typeText(deleteString)
        self.typeText(text)
    }
}
