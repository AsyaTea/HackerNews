//
//  NewsModel.swift
//  HackerNewsClient
//
//  Created by Asya Tealdi on 28/06/22.
//

import Foundation

struct News: Codable, Hashable {
    var id: UUID
    var deleted: Bool?
    var type: String?
    var by: String?
    var time: Date?
    var text: String?
    var dead: Bool?
    var parent: Int32?
    var poll: Int32?
    var kids: [UUID]?
    var url : String?
    var score: Int?
    var title: String?
    var parts: [Int32]?
    var descendats: Int?
    

    
}
