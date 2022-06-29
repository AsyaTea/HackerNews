//
//  NewsList.swift
//  HackerNewsClient
//
//  Created by Asya Tealdi on 28/06/22.
//

import SwiftUI

struct NewsListView: View {
    @ObservedObject var dataVM: DataViewModel
    var list : Int
    var body: some View {
        NavigationView{            
            VStack{
                if dataVM.isLoading {
                    ProgressView()                   
                } else if dataVM.error != nil {
                    ErrorView(dataVM: dataVM)
                  
                } else {
                    ListView(dataVM: dataVM, list: 0)
                  
                }
            }
            .navigationTitle("Hacker News")
        }
    }
}



struct NewsList_Previews: PreviewProvider {
    static var previews: some View {
        NewsListView(dataVM: DataViewModel(urlNumber: 0), list: 0)
    }
}
