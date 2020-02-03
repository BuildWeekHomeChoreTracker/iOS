//
//  Child+convenience.swift
//  HomeChoresTracker
//
//  Created by Kenny on 2/3/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import CoreData

extension Child {
    
//    var childRepresentation: ChildRepresentation? {
//        guard let name = name,
//            let parentName = parentName
//        else {return nil}
//        return ChildRepresentation(name: name, parentName: parentName, cleanStreak: Int(cleanStreak), chores: chores)
//    }
    
    convenience init?(name: String, parentName: String, cleanStreak: Int?, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.name = name
        self.parentName = parentName
        if let cleanStreak = cleanStreak {
            self.cleanStreak = Int16(cleanStreak)
        }
    }
    
    convenience init?(representation: ChildRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(name: representation.name, parentName: representation.parentName, cleanStreak: representation.cleanStreak, context: context)
    }
}
