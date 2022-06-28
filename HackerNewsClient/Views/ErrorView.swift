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
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(dataVM: DataViewModel())
    }
}
