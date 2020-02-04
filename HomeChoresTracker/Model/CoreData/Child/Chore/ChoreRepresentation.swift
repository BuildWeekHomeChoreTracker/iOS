//
//  ChoreRepresentation.swift
//  HomeChoresTracker
//
//  Created by Kenny on 2/3/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

struct ChoreRepresentation: Codable {
    var bonusPoints: Int?
    var cleanStreak: Int?
    var comments: String?
    var dueDate: Date?
    var id: Int
    var image: Data?
    var information: String?
    var parentId: Int
    var score: Int?
    var title: String
    
    
    
    
    
    
    enum ChoreKeys: String, CodingKey {
        case image = "photo_obj"
        case score = "chore_score"
        case title = "name"
        case information = "description"
        case bonusPoints = "bonus_pts"
        case dueDate = "due_date"
        case parentId = "parent_id"
    }
    
    init(bonusPoints: Int?, cleanStreak: Int?, comments: String?, dueDate: Date, id: Int, image: Data?, information: String, parentId: Int, score: Int?, title: String) {
        
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
    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: ChoreKeys.self)
//        image = try container.decode(Data?.self, forKey: .image)
//        score = try container.decode(Int?.self, forKey: .score)
//        title = try container.decode(String.self, forKey: .title)
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: ChoreKeys.self)
//        try container.encode(image, forKey: .image)
//        try container.encode(score, forKey: .score)
//        try container.encode(title, forKey: .title)
//    }
}
