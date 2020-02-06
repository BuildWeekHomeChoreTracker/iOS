//
//  NetworkDataLoader.swift
//  HomeChoresTracker
//
//  Created by Chad Rutherford on 2/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

protocol NetworkDataLoader {
    func loadData(using request: URLRequest, completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void)
    func loadData(using url: URL, completion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void)
}
