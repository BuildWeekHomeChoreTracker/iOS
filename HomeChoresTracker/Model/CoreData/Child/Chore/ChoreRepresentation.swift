//
//  ChoreRepresentation.swift
//  HomeChoresTracker
//
//  Created by Kenny on 2/3/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

struct ChoreRepresentation: Codable {
    var image: Data?
    var score: Int?
    var title: String
    
    enum ChoreKeys: String, CodingKey {
        case image = "photo_obj"
        case score = "chore_score"
        case title = "name"
    }
    
    init(image: Data?, score: Int?, title: String) {
        self.image = image
        self.score = score
        self.title = title
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ChoreKeys.self)
        image = try container.decode(Data?.self, forKey: .image)
        score = try container.decode(Int?.self, forKey: .score)
        title = try container.decode(String.self, forKey: .title)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: ChoreKeys.self)
        try container.encode(image, forKey: .image)
        try container.encode(score, forKey: .score)
        try container.encode(title, forKey: .title)
    }
}
