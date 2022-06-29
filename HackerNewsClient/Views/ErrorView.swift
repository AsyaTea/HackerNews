//
//  ErrorView.swift
//  HackerNewsClient
//
//  Created by Asya Tealdi on 28/06/22.
//

import SwiftUI

struct ErrorView: View {
    @ObservedObject var dataVM : DataViewModel
    var body: some View {
        Text("Something went wrong!")
    }
}

//struct ErrorView_Previews: PreviewProvider {
//    static var previews: some View {
//        ErrorView(dataVM: DataViewModel())
//    }
//}
