//
//  TabBar.swift
//  HackerNewsClient
//
//  Created by Asya Tealdi on 28/06/22.
//

import SwiftUI

struct TabBar: View {
    @StateObject var recentNewsVM = DataViewModel(urlNumber: 0)
    @StateObject var topNewsVM = DataViewModel(urlNumber: 1)
    @StateObject var bestNewsVM = DataViewModel(urlNumber: 2)
    

    var body: some View {
        TabView {
            NewsListView(recentNewsVM: recentNewsVM, topNewsVM: topNewsVM, bestNewsVM: bestNewsVM)
                .tabItem {
                    Image(systemName: "newspaper")
                    Text("News")
                }
            FavouriteList(recentNewsVM: recentNewsVM, topNewsVM: topNewsVM, bestNewsVM: bestNewsVM)
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Favourites")
                }
        }
        
    }
}


