//
//  BestStoriesList.swift
//  HackerNewsClient
//
//  Created by Asya Tealdi on 28/06/22.
//

import SwiftUI

struct BestStoriesList: View {
    @ObservedObject var dataVM: DataViewModel
    var body: some View {
        NavigationView{
            VStack{
                if dataVM.isLoading {
                    ProgressView()
                } else if dataVM.error != nil {
                    ErrorView(dataVM: dataVM)
                } else {
                    ListView(dataVM: dataVM)
                }
            }
            .navigationTitle("Best Stories")
        }
    }
}

struct BestStoriesList_Previews: PreviewProvider {
    static var previews: some View {
        BestStoriesList(dataVM: DataViewModel(urlNumber: 2))
    }
}
