//
//  WebView.swift
//  WebSupport
//
//  Created by gdaalumno on 22/09/21.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable{
    
    let request: URLRequest
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context){
        uiView.load(request)
    }
}

#if DEBUG
struct WebView_Previews: PreviewProvider{
    static var previews: some View{
        WebView(request: URLRequest(url: URL(string: "https://tec.mx")!))
        
    }
}
#endif
