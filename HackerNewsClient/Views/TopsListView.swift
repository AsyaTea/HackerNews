//
//  TopsList.swift
//  HackerNewsClient
//
//  Created by Asya Tealdi on 28/06/22.
//

import SwiftUI

struct TopsList: View {
    @ObservedObject var dataVM: DataViewModel

    var body: some View {
        NavigationView{
            VStack {
                if dataVM.isLoading {
                    ProgressView()
                } else if dataVM.error != nil {
                    ErrorView(dataVM: dataVM)
                } else {
                    ListView(dataVM: dataVM)
                }
            }
            .navigationTitle("Top News")
//            .navigationBarTitleDisplayMode(.inline)
//            .navigationBarItems(
//                leading:
//                    Text("Top News")
//                    .foregroundColor(.black)
//                    .font(.largeTitle)
//                    .padding()
//
//            )
        }
    }
}

struct TopsList_Previews: PreviewProvider {
    static var previews: some View {
        TopsList(dataVM: DataViewModel(urlNumber: 1))
    }
}
