//
//  ChoreRepresentation.swift
//  HomeChoresTracker
//
//  Created by Kenny on 2/3/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

struct AllChores: Decodable {
    var chores: [ChoreRepresentation] // "chore:[ChoreRepresentation]
    
    enum CodingKeys: String, CodingKey {
        case chores = "chore"
    }
}

struct ChoreRepresentation: Codable {
    var bonusPoints: Int?
    var cleanStreak: Int?
    var comments: String?
    var dueDate: String?
    var id: Int
    var image: Data?
    var information: String?
    var parentId: Int
    var score: Int?
    var title: String
    
    enum CodingKeys: String, CodingKey {
        case id = "child_id"
        case image = "photo_obj"
        case score = "chore_score"
        case title = "name"
        case information = "description"
        case bonusPoints = "bonus_pts"
        case dueDate = "due_date"
        case parentId = "parent_id"
    }
    
    init(bonusPoints: Int?, cleanStreak: Int?, comments: String?, dueDate: String, id: Int, image: Data?, information: String, parentId: Int, score: Int?, title: String) {
        
        self.comments = comments
        self.dueDate = dueDate
        self.id = id
        self.image = image
        self.information = information
        self.parentId = parentId
        self.score = score
        self.title = title
        self.bonusPoints = bonusPoints
        self.cleanStreak = cleanStreak
    }
    
    var dateFromString: Date {
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        guard let date = df.date(from: self.dueDate ?? "12-12-1970") else {return Date()}
        return date
    }
    
}
