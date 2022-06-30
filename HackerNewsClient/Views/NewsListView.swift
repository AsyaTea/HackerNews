//
//  NewsList.swift
//  HackerNewsClient
//
//  Created by Asya Tealdi on 28/06/22.
//

import SwiftUI

struct NewsListView: View {
    @ObservedObject var recentNewsVM : DataViewModel
    @ObservedObject var topNewsVM : DataViewModel
    @ObservedObject var bestNewsVM : DataViewModel
    
    @State private var listType = 0
    
    var body: some View {
        NavigationView{            
            VStack{
                Picker("", selection: $listType) {
                    Text("News").tag(0)
                    Text("Top").tag(1)
                    Text("Best Stories").tag(2)
                }
                .pickerStyle(.segmented)
                .padding()
                  
                if listType == 0 {
                    if recentNewsVM.isLoading {
                        ProgressView("Loading")
                    } else {
                        ListView(dataVM: recentNewsVM, list: 0)
                    }
                  
                } else if listType == 1 {
                    if topNewsVM.isLoading {
                        ProgressView("Loading")
                    } else {
                        ListView(dataVM: topNewsVM, list: 1)
                    }
                } else {
                    if bestNewsVM.isLoading {
                        ProgressView("Loading")
                    } else {
                        ListView(dataVM: bestNewsVM, list: 2)
                    }
                }
                
            }
            .navigationTitle("Hacker News")
        }
    }
}



//struct NewsList_Previews: PreviewProvider {
//    static var previews: some View {
//        NewsListView()
//    }
//}
