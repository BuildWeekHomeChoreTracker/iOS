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
                choreReps.append(ChoreRepresentation(bonusPoints: Int(chore.bonusPoints), childId: Int(chore.childId), cleanStreak: Int(chore.cleanStreak), comments: chore.comments, dueDate: chore.dateString, id: Int(chore.id), image: chore.image, information: chore.information ?? "No Description Given", parentId: Int(chore.parentId), score: Int(chore.score), title: chore.title ?? "No Title"))
            }
        }
        return ChildRepresentation(id: Int(childId), name: name, parentName: parentName)
    }
    
    convenience init?(id: Int16, name: String, parentName: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.childId = id
        self.name = name
        self.parentName = parentName
    }
    
    convenience init?(representation: ChildRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(id: Int16(representation.id), name: representation.name, parentName: representation.parentName, context: context)
    }
}
