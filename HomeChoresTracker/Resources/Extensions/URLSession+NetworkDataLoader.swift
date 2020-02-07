//
//  URLSession+NetworkDataLoader.swift
//  HomeChoresTracker
//
//  Created by Chad Rutherford on 2/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

/**
 URLSession abstraction for testing purposes
 */
extension URLSession: NetworkDataLoader {
    func loadData(using request: URLRequest, completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
        dataTask(with: request) { data, response, error in
            completion(data, response as? HTTPURLResponse, error)
        }.resume()
    }
    
    func loadData(using url: URL, completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) {
        dataTask(with: url) { data, response, error in
            completion(data, response as? HTTPURLResponse, error)
        }.resume()
    }
}
