//
//  NewsModel.swift
//  HackerNewsClient
//
//  Created by Asya Tealdi on 28/06/22.
//

import Foundation

struct Story: Codable, Hashable {
    
    var id: Int
    var type: String?
    var by: String?
    var time: Int32?
    var descendants : Int?
//    var text: String?
    var kids: [Int]?
    var url : String?
    var score: Int?
    var title: String?
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        by = try values.decode(String.self, forKey: .by)
        type = try values.decode(String.self, forKey: .type)
        descendants = try values.decode(Int.self, forKey: .descendants)
        time = try values.decode(Int32.self, forKey: .time)
//        text = try values.decode(String.self, forKey: .text)
        kids = try values.decode([Int].self, forKey: .kids)
        url = try values.decode(String.self, forKey: .url)
        score = try values.decode(Int.self, forKey: .score)
        title = try values.decode(String.self, forKey: .title)
        
    }
}
