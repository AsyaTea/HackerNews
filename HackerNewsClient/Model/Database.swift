//
//  Database.swift
//  HackerNewsClient
//
//  Created by Asya Tealdi on 30/06/22.
//

import Foundation

final class Database {
    private let FAV_KEY = "fav_key"
    
    func save(favouritesID: Set<Int>) {
        let favourites = Array(favouritesID)
        UserDefaults.standard.set(favourites, forKey: FAV_KEY)
    }
    
    func load() -> Set<Int> {
        let favourites = UserDefaults.standard.array(forKey: FAV_KEY) as? [Int] ?? [Int]()
        return Set(favourites)
    }
}
