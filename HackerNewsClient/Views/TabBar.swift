//
//  TabBar.swift
//  HackerNewsClient
//
//  Created by Asya Tealdi on 28/06/22.
//

import SwiftUI

struct TabBar: View {
    @StateObject var dataVM = DataViewModel()
    var body: some View {
        TabView {
            NewsListView(dataVM: dataVM)
                .tabItem {
                    Image(systemName: "newspaper")
                    Text("News")
                }
            TopsList()
                .tabItem {
                    Image(systemName: "newspaper")
                    Text("Top")
                }
            BestStoriesList()
                .tabItem {
                    Image(systemName: "newspaper")
                    Text("Best Stories")
                }
        }
        
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar(dataVM: DataViewModel())
    }
}
