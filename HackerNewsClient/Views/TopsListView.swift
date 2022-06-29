//
//  TopsList.swift
//  HackerNewsClient
//
//  Created by Asya Tealdi on 28/06/22.
//

import SwiftUI

struct TopsList: View {
    @ObservedObject var dataVM: DataViewModel
    var list : Int
    var body: some View {
        NavigationView{
            VStack {
                if dataVM.isLoading {
                    ProgressView()
                        .onAppear {
                            print("cprogress top")
                        }
                } else if dataVM.error != nil {
                    ErrorView(dataVM: dataVM)
                        .onAppear {
                            print("tops error")
                        }
                } else {
                    ListView(dataVM: dataVM, list: 1)
                        .onAppear {
                            print("creating top list")
                        }
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
        TopsList(dataVM: DataViewModel(urlNumber: 1), list: 1)
    }
}
