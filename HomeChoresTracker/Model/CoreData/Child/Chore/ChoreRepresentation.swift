//
//  ChoreRepresentation.swift
//  HomeChoresTracker
//
//  Created by Kenny on 2/3/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

struct ChoreRepresentation: Codable {
    var image: Data?
    var score: Int?
    let title: String
}
