//
//  Chore+convenience.swift
//  HomeChoresTracker
//
//  Created by Kenny on 2/3/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import CoreData

extension Chore {
    
    // MARK: - Properties
    var choreRepresentation: ChoreRepresentation? {
        let rep = ChoreRepresentation(
            bonusPoints: Int(bonusPoints),
            childId: Int(id),
            cleanStreak: Int(cleanStreak),
            comments: comments,
            completed: Int(completed),
            dueDate: dateString,
            id: Int(id),
            image: image,
            information: information ?? "No Description Provided",
            parentId: Int(parentId),
            score: Int(score),
            title: title ?? "chore has no name"
        )
        return rep
    }
    
    var dateString: String {
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .none
        let dateString = df.string(from: self.dueDate ?? Date())
        return dateString
    }
    
    // MARK: - Init
    convenience init?(id: Int16,
                      parentId: Int16,
                      title: String,
                      bonusPoints: Int16? = nil,
                      cleanStreak: Int16? = nil,
                      comments: String? = nil,
                      completed: Int16 = 0,
                      dueDate: Date? = nil,
                      image: Data? = nil,
                      information: String? = nil,
                      score: Int16? = nil,
                      context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.parentId = parentId
        self.title = title
        self.bonusPoints = bonusPoints ?? 0
        self.cleanStreak = cleanStreak ?? 0
        self.comments = comments
        self.completed = completed
        self.dueDate = dueDate
        self.image = image
        self.information = information
        if let score = score {
            self.score = score
        }
    }
    
    // MARK: - Rep Convenience Init
    convenience init?(representation: ChoreRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(id: Int16(representation.id),
                  parentId: Int16(representation.parentId),
                  title: representation.title,
                  bonusPoints: Int16(representation.bonusPoints ?? 0),
                  cleanStreak: Int16(representation.cleanStreak ?? 0),
                  comments: representation.comments,
                  completed: Int16(representation.completed),
                  dueDate: representation.dateFromString,
                  image: representation.image,
                  information: representation.information,
                  score: Int16(representation.score ?? 0),
                  context: context)
    }
}
