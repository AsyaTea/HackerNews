//
//  TopsList.swift
//  HackerNewsClient
//
//  Created by Asya Tealdi on 28/06/22.
//

import SwiftUI

struct FavouriteList: View {
    @ObservedObject var recentNewsVM: DataViewModel
    @ObservedObject var topNewsVM: DataViewModel
    @ObservedObject var bestNewsVM: DataViewModel
    
    var body: some View {
        NavigationView{
            VStack {
                List {
                    ForEach(recentNewsVM.filteredStories, id:\.self) { item in
                        NavigationLink(destination: newsView(dataVM: recentNewsVM, story: item)) {
                            CustomCell(news: item)
                        }
                    }
                    ForEach(topNewsVM.filteredStories, id:\.self) { item in
                        NavigationLink(destination: newsView(dataVM: topNewsVM, story: item)) {
                            CustomCell(news: item)
                        }
                    }
                    ForEach(bestNewsVM.filteredStories, id:\.self) { item in
                        NavigationLink(destination: newsView(dataVM: topNewsVM, story: item)) {
                            CustomCell(news: item)
                        }
                    }
                }
            }
            .navigationTitle("Favourites")

        }
    }
    

}
