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
    var choreRepresentation: ChoreRepresentation? {
        guard let title = title else {return nil}
        return ChoreRepresentation(image: image, score: Int(score), title: title)
    }
    
    convenience init?(title: String, image: Data? = nil, score: Int16? = nil, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.image = image
        if let score = score {
            self.score = score
        }
    }
    
    convenience init?(representation: ChoreRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        let score = representation.score ?? 0
        self.init(title: representation.title, image: representation.image, score: Int16(score), context: context)
    }
}
