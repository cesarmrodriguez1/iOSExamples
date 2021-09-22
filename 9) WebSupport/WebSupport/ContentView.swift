//
//  ContentView.swift
//  WebSupport
//
//  Created by gdaalumno on 22/09/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        WebView(request: URLRequest(url: URL(string: "https://www.apple.com")!))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
