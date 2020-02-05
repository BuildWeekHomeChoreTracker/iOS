//
//  ChildRepresentation.swift
//  HomeChoresTracker
//
//  Created by Kenny on 2/3/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import CoreData

struct ChildRepresentation: Codable {
    let id: Int
    let name: String
    let parentName: String
    var cleanStreak: Int?
}
