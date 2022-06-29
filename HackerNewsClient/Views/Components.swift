//
//  Components.swift
//  HackerNewsClient
//
//  Created by Asya Tealdi on 28/06/22.
//

import Foundation
import SwiftUI
import WebKit
import UIKit

struct ListView : View {
    @ObservedObject var dataVM: DataViewModel
    @State private var showNews = false
    var list : Int
    
    var body: some View {
            List {
                ForEach(dataVM.stories, id: \.self) { news in
                    
                    NavigationLink(destination: newsView(dataVM: dataVM, news: news)) {
                        CustomCell(news: news)
                    }
                }
            }
            .gesture( DragGesture()
                        .onChanged { value in
                            print("hello im swiping hehe")
                            dataVM.loadMore(x: 20)
                })
            .refreshable {
                print("Refreshing")
//                self.dataVM = DataViewModel(urlNumber: list)
            }
        
    }
}

struct CustomCell: View {
        
    var news: Item
    var date: Date
        
    init(news: Item) {
        self.news = news
        self.date = Date(timeIntervalSince1970: TimeInterval(news.time!))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            if news.title != nil {
                Text(news.title!)
                    .font(.headline)
            }
            HStack{
                Text("by \(news.by!)")

                if news.time != nil {
                    Text("\(dateFormatter(time: date))")
                }
                
                Image(systemName: "text.bubble")
                Text(String(news.kids?.count ?? 0))
                Spacer()
                Text("Score: \(String(news.score ?? 0))")
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
    var news: Item
    
    var body: some View {
        
            VStack(alignment: .leading, spacing: 10) {
                Website(dataVM: dataVM, news: news)
            }
            .padding(20)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Story")
        
    }
}

struct Website: View {
    
    @State private var showWebView = false
    @State private var modalView = false
    @ObservedObject var dataVM: DataViewModel
    var news: Item
    var body: some View {
        
        NavigationView {
            VStack {
                if let website = news.url {
                    WebView(url: URL(string: website)!, showWebView: $showWebView)
                        .overlay(showWebView ? ProgressView("Loading").toAnyView() : EmptyView().toAnyView())
                }               
            }    
            .overlay(
                VStack{
                    Spacer()
                    Button {
                         modalView.toggle()
//                        dataVM.fetchComments(storyID: news.id)
                     } label: {
                         ZStack{
                             RoundedRectangle(cornerRadius: 10)
                                 .frame(width: 380, height: 50, alignment: .bottom)
                             Text("View Comments")
                                 .foregroundColor(.white)
                                
                         }
                     }
                     .sheet(isPresented: $modalView) {
                         CommentsView(dataVM: dataVM, modalView: $modalView)
                             .onAppear {
//                                 dataVM.fetchComments(storyID: news.id)
                             }
                     }
                }
            )

        }

    }
}

struct CommentsView: View {
    @ObservedObject var dataVM: DataViewModel
    @Binding var modalView : Bool
    var body: some View {
        NavigationView {
            VStack{
                ForEach(dataVM.comments, id:\.self) { comment in
                    Text(comment.text!)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading:
                    Button(action: {
                        modalView.toggle()
                    }, label: {
                        HStack{
                            Text("< Back")
                        }
                    })

            )
        }

    }
}

struct WebView: UIViewRepresentable {
 
    var url: URL
    @Binding var showWebView : Bool
 
    func makeUIView(context: Context) -> WKWebView {
        showWebView = true
        return WKWebView()
    }
 
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

extension View {
    func toAnyView() -> AnyView {
        AnyView(self)
    }
}
