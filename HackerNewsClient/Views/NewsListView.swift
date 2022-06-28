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
                ListView(dataVM: dataVM)
            }
        }
    }
}

struct ListView : View {
    @ObservedObject var dataVM: DataViewModel
    var body: some View {
        VStack{
            List {
                ForEach(dataVM.news, id: \.self) { news in
                    CustomCell(news: news)
                }
            }
        
    }
    .navigationBarTitleDisplayMode(.inline)
    .navigationBarItems(
        leading:
            Text("Hacker News")
            .foregroundColor(.black)
            .font(.largeTitle)
            .padding(.top, 10)
        
    )
    }
}

struct CustomCell: View {
    
     var news: News
     var date: Date
//     var time: String
    
    
    func dateFormatter(time: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: time)
    }
    
    init(news: News) {
        self.news = news
        self.date = Date(timeIntervalSince1970: TimeInterval(news.time!))
//        self.time = dateFormatter(time: date)
//        print("my date is \(date)")
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            if news.title != nil {
                Text(news.title!)
                    .font(.headline)
            }
            HStack{
                Text("by \(news.by!)")

                if news.time != nil {
                    Text("\(dateFormatter(time: date))")
                }
            }
            .font(.subheadline)
          
            
        }
    }
    
}

struct NewsList_Previews: PreviewProvider {
    static var previews: some View {
        NewsListView(dataVM: DataViewModel())
    }
}
