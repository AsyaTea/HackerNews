//
//  WebView.swift
//  HackerNewsClient
//
//  Created by Asya Tealdi on 30/06/22.
//

import Foundation
import WebKit
import UIKit
import SwiftUI

struct WebView: UIViewRepresentable {

    var url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

extension View {
    func toAnyView() -> AnyView {
        AnyView(self)
    }
}

