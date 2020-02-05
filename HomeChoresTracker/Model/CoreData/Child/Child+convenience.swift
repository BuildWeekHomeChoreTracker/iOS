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
    
    var childRepresentation: ChildRepresentation? {
        guard let name = name,
            let parentName = parentName,
            let chores = chores
        else {return nil}
        var choreReps = [ChoreRepresentation]()
        for chore in chores {
            if let chore = chore as? Chore {
                choreReps.append(ChoreRepresentation(bonusPoints: Int(chore.bonusPoints ?? 0), cleanStreak: Int(chore.cleanStreak ?? 0), comments: chore.comments, dueDate: chore.dateString, id: Int(chore.id), image: chore.image, information: chore.information ?? "No Description Given", parentId: Int(chore.parentId), score: Int(chore.score), title: chore.title ?? "No Title"))
            }
        }
        return ChildRepresentation(name: name, parentName: parentName, chores: choreReps)
    }
    
    convenience init?(name: String, parentName: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.name = name
        self.parentName = parentName
    }
    
    convenience init?(representation: ChildRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(name: representation.name, parentName: representation.parentName, context: context)
    }
}
