//
//  BestStoriesList.swift
//  HackerNewsClient
//
//  Created by Asya Tealdi on 28/06/22.
//

import SwiftUI

struct BestStoriesList: View {
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
                    ListView(dataVM: dataVM, list: 2)
                }
            }
            .navigationTitle("Best Stories")
        }
    }
}

struct BestStoriesList_Previews: PreviewProvider {
    static var previews: some View {
        BestStoriesList(dataVM: DataViewModel(urlNumber: 2), list: 2)
    }
}
