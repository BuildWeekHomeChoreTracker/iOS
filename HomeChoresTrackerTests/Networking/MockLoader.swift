//
//  MockLoader.swift
//  HomeChoresTrackerTests
//
//  Created by Chad Rutherford on 2/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
@testable import HomeChoresTracker

class MockLoader: NetworkDataLoader {
    var data: Data?
    var response: HTTPURLResponse?
    var error: Error?
    
    func loadData(using request: URLRequest, completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(self.data, self.response, self.error)
        }
    }
    
    func loadData(using url: URL, completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(self.data, self.response, self.error)
        }
    }
}
