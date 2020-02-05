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
    
    //MARK: Properties
    var choreRepresentation: ChoreRepresentation? {
        let rep = ChoreRepresentation(
            bonusPoints: Int(bonusPoints),
            cleanStreak: Int(cleanStreak),
            comments: comments,
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
        df.timeStyle = .short
        let date = df.string(from: self.dueDate ?? Date())
        return date
    }
    
    //MARK: Init
    convenience init?(
        bonusPoints: Int16? = nil,
        cleanStreak: Int16? = nil,
        comments: String? = nil,
        dueDate: Date? = nil,
        id: Int16,
        image: Data? = nil,
        information: String? = nil,
        parentId: Int16,
        score: Int16? = nil,
        title: String,
        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
            self.init(context: context)
            self.bonusPoints = bonusPoints ?? 0
            self.title = title
            self.image = image
            if let score = score {
                self.score = score
            }
    }
    
    //MARK: Rep Convenience Init
    convenience init?(representation: ChoreRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(bonusPoints: Int16(representation.bonusPoints ?? 0),
                  cleanStreak: Int16(representation.cleanStreak ?? 0),
                  comments: representation.comments,
                  dueDate: representation.dateFromString,
                  id: Int16(representation.id),
                  image: representation.image,
                  information: representation.information,
                  parentId: Int16(representation.parentId),
                  score: Int16(representation.score ?? 0),
                  title: representation.title, context: context)
    }
}
