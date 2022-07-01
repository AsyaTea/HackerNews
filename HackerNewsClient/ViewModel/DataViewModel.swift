//
//  DataViewModel.swift
//  HackerNewsClient
//
//  Created by Asya Tealdi on 28/06/22.
//

import Foundation
import Dispatch
import SwiftUI


class DataViewModel : ObservableObject {
    
    var storiesListID = [Int]()
    
    @Published var listType = 0
    @Published var stories = [Item]()
    @Published var comments = [Item]()
    @Published var filteredComments = [Item]()
    
    var newStories = [Int]()
    var initialStories = 15
    
    @Published var isLoading: Bool = true
    @Published var isLoadingComments: Bool = true
    @Published var error : String? = nil
    @Published var loadingWebSite = false
    
    let urls = [
        URL(string: "https://hacker-news.firebaseio.com/v0/newstories.json?print=pretty"),
        URL(string: "https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty"),
        URL(string: "https://hacker-news.firebaseio.com/v0/beststories.json?print=pretty"),
    ]
    var urlNumber = 0
    
    //FAVOURITES OBJECTS
    @Published var savedItems: Set<Int> = []
    private var db = Database()
    
    var filteredStories : [Item] {
        return stories.filter { savedItems.contains($0.id) }
    }
    // -----------------
    
    init(urlNumber: Int)  {
        self.fetchStories(url: urls[urlNumber]!)
        self.urlNumber = urlNumber
        self.savedItems = db.load()
    }
    
    func fetchStories(url: URL)  {
        
        let task = URLSession.shared.dataTask(with: url) { stories, response, error in
            
            DispatchQueue.main.async {
                
                 let decoder = JSONDecoder()
                 if let news = stories {
                     
                     do {
                        self.storiesListID = try decoder.decode([Int].self, from: news)
                         let smallListID = self.storiesListID[..<self.initialStories]
                         for storyID in smallListID {
                             self.fetchOneItem(storyID: storyID)
                         }
                     } catch {
                         print(error)
                     }
                 }
            }
        }
        task.resume()
    }
    
    func loadMore(moreStories: Int) {

        if self.initialStories <= self.storiesListID.count - moreStories {
           
            let smallListID = self.storiesListID[self.initialStories..<self.initialStories+moreStories]
            self.initialStories = self.initialStories + moreStories
            for storiesID in smallListID {
                self.fetchOneItem(storyID: storiesID)
            }
            
        }
    }
    
    func refresh(url: URL) {
        
        let task = URLSession.shared.dataTask(with: url) { storiesID, response, error in
            
            DispatchQueue.main.async {
                
                 let decoder = JSONDecoder()
                 
                 if let stories = storiesID {
                     
                     do {
                        self.newStories = try decoder.decode([Int].self, from: stories)
                         
                         for newStory in self.newStories {
                             if !self.storiesListID.contains(newStory) {
                                 self.fetchOneItem(storyID: newStory)
                                 
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
    
    func fetchOneItem(storyID: Int) {
       
        let storyUrl = URL(string: "https://hacker-news.firebaseio.com/v0/item/\(storyID).json")
        
        let task = URLSession.shared.dataTask(with: storyUrl!) { story, response, error in
            let decoder = JSONDecoder()
                
            DispatchQueue.main.async {
                if let story = story {
                    
                    do {
                        let story = try decoder.decode(Item.self, from: story)
                        self.stories.append(story)
                        if story.kids != nil {
                            for comment in story.kids! {
                                self.fetchComment(commentID: comment)
                            }
                        }                        
                        //If news list sort by most recent
                        if self.urlNumber == 0 {
                            if self.stories.count >= 2{
                                self.stories.sort {
                                    $0.time! > $1.time!
                                }
                            }
                        }
                    
                        self.isLoading = false
                    } catch {
                        print(error)
                    }
                }
            }
        }
        task.resume()
    }
    
    func fetchComment(commentID: Int) {
        
        let url = URL(string: "https://hacker-news.firebaseio.com/v0/item/\(commentID).json")
        
        let task = URLSession.shared.dataTask(with: url!) { comment, response, error in
            
            let decoder = JSONDecoder()
            DispatchQueue.main.async {
                
                if let comment = comment {
                    
                    do {
                        
                        let comment = try decoder.decode(Item.self, from: comment)
                        self.comments.append(comment)
                        self.isLoadingComments = false
                       
                        
                    } catch {
                        print(error)
                    }
                }
            }
        }
        task.resume()
    }
    
    func filterComments(storyID: Int) {
        let filteredComments = self.comments.filter { comment in
            return comment.parent == storyID
        }
        self.filteredComments = filteredComments
        
    }
    
    
    // MARK: -  FAVOURITES FUNCTIONS
    
    func contains(item: Item) -> Bool {
        savedItems.contains(item.id)
    }
    
    func toggleFav(item: Item) {
        if contains(item: item) {
            savedItems.remove(item.id)
        } else {
            savedItems.insert(item.id)
        }
        db.save(favouritesID: savedItems)
    }
    
}
