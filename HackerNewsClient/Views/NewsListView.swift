//
//  NewsList.swift
//  HackerNewsClient
//
//  Created by Asya Tealdi on 28/06/22.
//

import SwiftUI

struct NewsListView: View {
    @ObservedObject var dataVM: DataViewModel
    var body: some View {
        NavigationView{
            

            if dataVM.isLoading {
                ProgressView()
            } else if dataVM.error != nil {
                ErrorView(dataVM: dataVM)
            } else {
                VStack{
                    List {
                        ForEach(dataVM.news, id: \.self) { news in
                            CustomCell()
                        }
                        Text("Hifahjbjehbfuwebf")
                        Text("Hi")
                    }
                   
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading:
                    Text("News")
                    .foregroundColor(.black)
                    .font(.largeTitle)
                    .padding(.top,15)
                
            )
            }
        }
    }
}

struct ListView : View {
    var body: some View {
        Text("hello")
    }
}

struct CustomCell: View {
    var body: some View {
        VStack{
            HStack{
                Text("Titolo Qui")
            }
            Text("Dati vari qua")
        }
    }
}

struct NewsList_Previews: PreviewProvider {
    static var previews: some View {
        NewsListView(dataVM: DataViewModel())
    }
}
