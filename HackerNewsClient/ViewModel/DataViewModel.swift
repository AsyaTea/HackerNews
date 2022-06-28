//
//  DataViewModel.swift
//  HackerNewsClient
//
//  Created by Asya Tealdi on 28/06/22.
//

import Foundation

class DataViewModel : ObservableObject {
    
    @Published var newsList = [Int]()
    @Published var news = [News]()
    @Published var tops = [News]()
    @Published var bestStories = [News]()
    
    @Published var isLoading: Bool = false
    @Published var error : String? = nil
    
    let newsURL = "https://hacker-news.firebaseio.com/v0/newstories.json?print=pretty"
    
    init() {
        fetchNews()
    }
    
    func fetchNews() {
        
        isLoading = true
        
        let url = URL(string: "https://hacker-news.firebaseio.com/v0/newstories.json?print=pretty")
        
        let task = URLSession.shared.dataTask(with: url!) { news, response, error in
            
            DispatchQueue.main.async {
                self.isLoading = false
                let decoder = JSONDecoder()
                
                if let news = news {
                    
                    do {
                        let news = try decoder.decode([Int].self, from: news)
                        self.newsList = news
                        
                        for newsID in self.newsList {
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
    
    func fetchOneNews(newsID: Int) {
        
            let newsUrl = URL(string: "https://hacker-news.firebaseio.com/v0/item/\(newsID).json")
            
            let task = URLSession.shared.dataTask(with: newsUrl!) { news, response, error in
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    let decoder = JSONDecoder()
                    
                    if let news = news {
                        
                        do {
                            let news = try decoder.decode(News.self, from: news)
                           
                            self.news.append(news)
                        } catch {
                            print(error)
                        }
                    }
                }
            }
            
            task.resume()
        }
}
