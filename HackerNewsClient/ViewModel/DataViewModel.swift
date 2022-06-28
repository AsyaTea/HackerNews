//
//  DataViewModel.swift
//  HackerNewsClient
//
//  Created by Asya Tealdi on 28/06/22.
//

import Foundation

class DataViewModel : ObservableObject {
    
    @Published var newsListID = [Int]()

    @Published var news = [News]()
    
    @Published var isLoading: Bool = false
    @Published var error : String? = nil
    
    var urlNumber = 0
    
   
    let urls = [
        URL(string: "https://hacker-news.firebaseio.com/v0/newstories.json?print=pretty"),
        URL(string: "https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty"),
        URL(string: "https://hacker-news.firebaseio.com/v0/beststories.json?print=pretty"),
    ]
    
    
    init(urlNumber: Int)  {
        print("sto creando il VM")
        self.fetchNews(url: urls[urlNumber]!)
        self.urlNumber = urlNumber
   
    }
    
    func fetchNews(url: URL)  {
        
        isLoading = true
        
        let url = urls[0]
        
            let task = URLSession.shared.dataTask(with: url!) { news, response, error in
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    let decoder = JSONDecoder()
                    
                    if let news = news {
                        
                        do {
                            self.newsListID = try decoder.decode([Int].self, from: news)
                            print(self.newsListID)
                            for newsID in self.newsListID {
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
//                            print(self.urlNumber)
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
