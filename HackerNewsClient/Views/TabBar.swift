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
            NewsListView(dataVM: recentNewsVM, list: 0)
                .tabItem {
                    Image(systemName: "newspaper")
                    Text("News")
                }
            TopsList(dataVM: topNewsVM, list: 1)
                .tabItem {
                    Image(systemName: "newspaper")
                    Text("Top")
                }
            BestStoriesList(dataVM: bestNewsVM, list: 2)
                .tabItem {
                    Image(systemName: "newspaper")
                    Text("Best Stories")
                }
        }
        
    }
}

//struct TabBar_Previews: PreviewProvider {
//    static var previews: some View {
//        TabBar(dataVM: DataViewModel())
//    }
//}
