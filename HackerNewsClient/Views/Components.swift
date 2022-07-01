//
//  Components.swift
//  HackerNewsClient
//
//  Created by Asya Tealdi on 28/06/22.
//

import Foundation
import SwiftUI

struct ListView : View {
    @ObservedObject var dataVM: DataViewModel
    @State var isLoading = false
    @State private var showNews = false
    var list : Int
    
    var body: some View {
            List {
                ForEach(dataVM.stories, id: \.self) { news in
                    NavigationLink(destination: newsView(dataVM: dataVM, story: news)) {
                        CustomCell(news: news)
                    }
                    .onAppear {
                        if news == dataVM.stories.last {
                            dataVM.loadMore(moreStories: 10)
                              }
                           }
                }
                if isLoading {
                     ProgressView()
                       .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
                   }
            }
            .refreshable {
                print("Refresh")
                dataVM.refresh(url: dataVM.urls[dataVM.urlNumber]!)
            }
        
    }
}

struct CustomCell: View {
        
    var story: Item
    var date: Date
        
    init(news: Item) {
        self.story = news
        self.date = Date(timeIntervalSince1970: TimeInterval(news.time!))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            if story.title != nil {
                Text(story.title!)
                    .font(.headline)
            }
            HStack{
                Text("by \(story.by!)")
                if story.time != nil {
                    Text("\(dateFormatter(time: date))")
                }
                Image(systemName: "text.bubble")
                Text(String(story.kids?.count ?? 0))
                Spacer()
                Text("Score: \(String(story.score ?? 0))")
            }
            .font(.subheadline)
        }
    }
    
    func dateFormatter(time: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: time)
    }
}

struct newsView: View {
    
    @ObservedObject var dataVM: DataViewModel
    var story: Item
    
    @State var modalView = false
    @State var isFavourite = false
    
    var body: some View {
        
            VStack(alignment: .leading, spacing: 10) {
                Website(dataVM: dataVM, story: story)
            }
            .padding(20)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Story")
            .toolbar {
                HStack{
                    Spacer()
                  
                    Button {
                        isFavourite.toggle()
                        dataVM.toggleFav(item: story)
                    } label: {
                        if dataVM.contains(item: story) {
                            Image(systemName: "star.fill")
                        } else {
                            Image(systemName: "star")
                        }
                        
                    }
                    Button {
                        modalView.toggle()
                    } label: {
                        Text("Comments")
                    }
                }
            }
            .sheet(isPresented: $modalView) {
                CommentsView(dataVM: dataVM, modalView: $modalView)
            }
    }
}

struct Website: View {
    
    @State private var showWebView = false
    @State private var modalView = false
    @ObservedObject var dataVM: DataViewModel
    var story: Item
    var date: Date
    
    init(dataVM: DataViewModel, story: Item) {
        self.date = Date(timeIntervalSince1970: TimeInterval(story.time!))
        self.dataVM = dataVM
        self.story = story
    }
    
    var body: some View {
        
        NavigationView {
            VStack {
                if let website = story.url {
                    WebView(url: URL(string: website)!)
                } else if story.text != nil {
                    VStack(alignment: .leading, spacing: 20){
                        HStack {
                            Text("Author: ")
                            Text("\(story.by ?? "")")
                                .fontWeight(.bold)
                        }
                       
                        Text("Item type:  \(story.type ?? "")")
                        if story.time != nil {
                            Text("Date published: \(dateFormatter(time: date))")
                        }
                        Text("Score: \(story.score ?? 0)")
                            
                        Text("Text: ")
                            
                        Text(story.text ?? "No data to show")
                        Spacer()
                        Spacer()
                    }
                    
                }
               
            }    
        }
    }
    
    func dateFormatter(time: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: time)
    }
}

struct CommentsView: View {
    @ObservedObject var dataVM: DataViewModel
    @Binding var modalView : Bool
    var body: some View {
        NavigationView {
            VStack {
                List {
                    NavigationLink(destination: EmptyView()) {
                        Text("Comment 1")
                        
                    }
                    
                    Text("Comment 2")
                    Text("Comment 3")
                    Text("Comment 4")
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Comments")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("< Back") {
                        print("Help tapped!")
                        modalView.toggle()
                    }
                }
            }
            
        }
      

    }
}

struct SubCommentView: View {
    var body: some View {
        Text("More comments!")
    }
}

