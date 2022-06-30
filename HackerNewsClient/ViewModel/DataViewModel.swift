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

    @Published var stories = [Item]()
    var newStories = [Int]()
    
    var storyCommentsIDs = [Int]()
    @Published var comments = [Item]()
    
    var initialStories = 5
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
        
//        self.newStories = [Item]()
        
        let task = URLSession.shared.dataTask(with: url) { news, response, error in
            
            DispatchQueue.main.async {
                
                 let decoder = JSONDecoder()
                 
                 if let news = news {
                     
                     do {
                        self.storiesListID = try decoder.decode([Int].self, from: news)
//                         print(storiesListID)
                         let smallListID = self.storiesListID[..<self.initialStories]
                         
                         for newsID in smallListID {
                             self.fetchOneItem(newsID: newsID)
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
        print("loading more")
//        self.stories = [Item]()
        let smallListID = self.storiesListID[self.initialStories..<self.initialStories+x]
        self.initialStories = self.initialStories + x
              for newsID in smallListID {
                  self.fetchOneItem(newsID: newsID)
              }
    }
    
    func refresh(url: URL) {
        
        //caricare quelle che non ho e riordinare
        let task = URLSession.shared.dataTask(with: url) { news, response, error in
            
            DispatchQueue.main.async {
                
                 let decoder = JSONDecoder()
                 
                 if let news = news {
                     
                     do {
                        self.newStories = try decoder.decode([Int].self, from: news)
                         
                         for newStory in self.newStories {
                             if !self.storiesListID.contains(newStory) {
                                 self.fetchOneItem(newsID: newStory)
                                 
                             }
                         }
                    
                     } catch {
                         print(error)
                     }
                 }
            }
        }
        task.resume()
        
    }
    
    func fetchOneItem(newsID: Int) {
        
      
        
        let newsUrl = URL(string: "https://hacker-news.firebaseio.com/v0/item/\(newsID).json")
        
        let task = URLSession.shared.dataTask(with: newsUrl!) { news, response, error in
            let decoder = JSONDecoder()
                
            DispatchQueue.main.async {
                if let news = news {
                    
                    do {
                        let news = try decoder.decode(Item.self, from: news)
                        
                        self.stories.append(news)
                        if self.urlNumber == 0 {
                            if self.stories.count >= 2{
                                self.stories.sort {
                                    $0.time! > $1.time!
                                }
                            }
                        }
//                        if self.storiesCopy.count >= 2 {
//                            self.storiesCopy.sort {
//                                $0.score! > $1.score!
//                            }
//                        }
                        self.isLoading = false
                    } catch {
                        print(error)
                    }
                }
            }
        }
        task.resume()
    }
    
    func fetchComments(storyID: Int) {
        
        let storyURL = URL(string: "https://hacker-news.firebaseio.com/v0/item/\(storyID).json")
        
        let task = URLSession.shared.dataTask(with: storyURL!) { comments, response, error in
            
            let decoder = JSONDecoder()
            DispatchQueue.main.async {
                if let comments = comments {
                    
                    do {
                        let commentsListID = try decoder.decode([Int].self, from: comments)
                        self.storyCommentsIDs = commentsListID.sorted { $0 > $1 }
                        print(self.storyCommentsIDs)
                        
                        for commentID in self.storyCommentsIDs {
                            self.fetchOneComment(commentID: commentID)
                        }
                        
                    } catch {
                        print(error)
                    }
                }
            }

        }
        
        task.resume()
    }
    
    func fetchOneComment(commentID: Int) {
        let commentUrl = URL(string: "https://hacker-news.firebaseio.com/v0/item/\(commentID).json")
        
        let task = URLSession.shared.dataTask(with: commentUrl!) { comment, response, error in
            let decoder = JSONDecoder()
                
            DispatchQueue.main.async {
                if let comment = comment {
                    
                    do {
                        let comment = try decoder.decode(Item.self, from: comment)
                        self.comments.append(comment)
//                        self.isLoading = false
                    } catch {
                        print(error)
                    }
                }
            }
        }
        task.resume()
    }
    
}
