//
//  CardView.swift
//  GesturesSupport
//
//  Created by gdaalumno on 23/09/21.
//

import SwiftUI

struct CardView: View{
    @GestureState var traslation: CGSize = .zero
    @GestureState var degrees: Double = 0
    
    let proxy: GeometryProxy
    
    var body: some View{
        let dragGesture = DragGesture()
            .updating($traslation){ (value, state, _) in
                state = value.translation
            }
            .updating($degrees){ (value, state, _) in
                state = value.translation.width > 0 ? 2 : -2
            }
        
        Rectangle()
            .overlay(
                ZStack{
                    Image("vader")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                    
                    VStack(alignment: .leading){
                        Text("This is a profile")
                            .foregroundColor(.white)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        Text("This is profile info")
                            .foregroundColor(.white)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    }
                    .position(
                        x: proxy.frame(in: .local).minX + 75,
                        y: proxy.frame(in: .local).minY - 50
                    )
                }
            )
            .cornerRadius(10)
        
            .frame(
                maxWidth: proxy.size.width - 28,
                maxHeight: proxy.size.height * 0.8
            )
            .position(
                x: proxy.frame(in: .global).midX,
                y: proxy.frame(in: .global).midY - 30
            )
            .animation(.interactiveSpring())
            .offset(x: traslation.width, y:0)
            .gesture(dragGesture)
            .rotationEffect(.degrees(degrees))
    }
}
