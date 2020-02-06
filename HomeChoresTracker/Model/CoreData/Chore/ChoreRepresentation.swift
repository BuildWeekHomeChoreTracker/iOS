//
//  ChoreRepresentation.swift
//  HomeChoresTracker
//
//  Created by Kenny on 2/3/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

struct AllChores: Decodable, Equatable {
    var chores: [ChoreRepresentation] // "chore:[ChoreRepresentation]
    
    enum CodingKeys: String, CodingKey {
        case chores = "chore"
    }
}

struct ChoreRepresentation: Codable, Equatable {
    var bonusPoints: Int?
    var childId: Int
    var cleanStreak: Int?
    var comments: String?
    var completed: Int
    var dueDate: String?
    var id: Int
    var image: String?
    var information: String?
    var parentId: Int
    var score: Int?
    var title: String
    
    
    enum CodingKeys: String, CodingKey {
        case bonusPoints = "bonus_pts"
        case childId = "child_id"
        case cleanStreak = "clean_strk"
        case comments
        case completed
        case dueDate = "due_date"
        case id
        case image = "photo_obj"
        case information = "description"
        case parentId = "parent_id"
        case score = "chore_score"
        case title = "name"
        
    }
    
    init(bonusPoints: Int?,
         childId: Int,
         cleanStreak: Int?,
         comments: String?,
         completed: Int,
         dueDate: String,
         id: Int,
         image: String?,
         information: String,
         parentId: Int,
         score: Int?,
         title: String) {
        self.bonusPoints = bonusPoints
        self.cleanStreak = cleanStreak
        self.comments = comments
        self.dueDate = dueDate
        self.id = id
        self.image = image
        self.information = information
        self.parentId = parentId
        self.score = score
        self.title = title
        self.childId = childId
        self.completed = completed
    }
    
    var dateFromString: Date {
        let df = DateFormatter()
        df.dateStyle = .short
        #warning("This may have to change depending on how the front end guys format their date. It's just a string on the API side")
        df.timeStyle = .none
        guard let date = df.date(from: self.dueDate ?? "12-12-1970") else { return Date() }
        return date
    }
}
