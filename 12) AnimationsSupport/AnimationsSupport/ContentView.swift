//
//  ContentView.swift
//  AnimationsSupport
//
//  Created by gdaalumno on 23/09/21.
//

import SwiftUI

struct ContentView: View {
    @State private var isAnimating = false
    
    
    var body: some View {
        VStack{
            RoundedRectangle(cornerRadius: 30.0)
                //.fill(Color.green)
                .fill(self.isAnimating ? Color.green: Color.blue)
            
                //.frame(width: 200, height: 200)
                .frame(width: self.isAnimating ? 100: 200, height: 200)
            
                .scaleEffect(self.isAnimating ? 0.5 : 1.0)
                .onAppear(perform: {
                    isAnimating = true
                })
                //.animation(Animation.linear(duration: 1).repeatForever())
                .animation(Animation.linear(duration: 1).delay(2).repeatForever())
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
