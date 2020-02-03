//
//  ChildController.swift
//  HomeChoresTracker
//
//  Created by Kenny on 2/3/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import CoreData

class ChildController {
    
    func getChores(child: Child, chore: Chore) -> [Chore]? {
        guard let chores = child.chores else {return nil}
        return Array(chores) as? [Chore]
    }
    
}
