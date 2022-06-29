//
//  DataViewModel.swift
//  HackerNewsClient
//
//  Created by Asya Tealdi on 28/06/22.
//

import Foundation
import Dispatch


class DataViewModel : ObservableObject {
    
    var storiesListID = [Int]()

    var stories = [Story]()
    
    @Published var newsCopy = [Story]()
    
    var initialStories = 20
    @Published var isLoading: Bool = true
    @Published var error : String? = nil
    
    @Published var loadingWebSite = false
    
    let urls = [
        URL(string: "https://hacker-news.firebaseio.com/v0/newstories.json?print=pretty"),
        URL(string: "https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty"),
        URL(string: "https://hacker-news.firebaseio.com/v0/beststories.json?print=pretty"),
    ]
    
    var urlNumber = 0
    
    init(urlNumber: Int)  {
        self.fetchNews(url: urls[urlNumber]!)
        self.urlNumber = urlNumber
    }
    
    func fetchNews(url: URL)  {
        
        let task = URLSession.shared.dataTask(with: url) { news, response, error in
            
            DispatchQueue.main.async {
                
                 let decoder = JSONDecoder()
                 
                 if let news = news {
                     
                     do {
                         self.storiesListID = try decoder.decode([Int].self, from: news)
                         self.storiesListID = self.storiesListID.sorted { $0 > $1 }
                         let smallListID = self.storiesListID[..<self.initialStories]
                         
                         for newsID in smallListID {
                             self.fetchOneNews(newsID: newsID)
                         }
                         
                         
                         
                     } catch {
                         print(error)
                     }
                 }
            }
        }
        task.resume()
    }
    
    func loadMore(x: Int) {
        let smallListID = self.storiesListID[self.initialStories..<self.initialStories+x]
        for newsID in smallListID {
            self.fetchOneNews(newsID: newsID)
        }
    }
    
    func fetchOneNews(newsID: Int) {
        
        let newsUrl = URL(string: "https://hacker-news.firebaseio.com/v0/item/\(newsID).json")
        
        let task = URLSession.shared.dataTask(with: newsUrl!) { news, response, error in
                let decoder = JSONDecoder()
                
            DispatchQueue.main.async {
                if let news = news {
                    
                    do {
                        let news = try decoder.decode(Story.self, from: news)
                        self.stories.append(news)
                        self.isLoading = false
                    } catch {
                        print(error)
                    }
                }
            }
        }
        task.resume()
    }
    
}
