//
//  FoodDetail.swift
//  DishMenu
//
//  Created by Guest User on 8/30/21.
//  Copyright © 2021 Guest User. All rights reserved.
//

import SwiftUI

struct FoodDetail: View {
    var food: Product
    var body: some View {
        List{
            ZStack{
                Image(food.imageName)
                .resizable()
                    .aspectRatio(contentMode: .fit)
                Rectangle()
                    .frame(height: 80.0)
                    .opacity(0.25)
                    .blur(radius: 10.0)
                
                HStack{
                    VStack(alignment: .leading, spacing: 8){
                        Text(food.name)
                            .foregroundColor(.white)
                            .font(.largeTitle)
                    }
                    .padding(.leading)
                    .padding(.bottom)
                    
                    Spacer()
                }
            }
        .listRowInsets(EdgeInsets())
            Text(food.description)
            .foregroundColor(.black)
            .font(.body)
            .lineLimit(nil)
            .lineSpacing(12)
            
            Spacer()
            
            HStack{
                Spacer()
                OrderButton()
                Spacer()
            }.padding(.top, 50)
        }.edgesIgnoringSafeArea(.top)
        
    }
}

struct OrderButton: View{
    var body: some View {
        Button(action: {}){
            Text("Order now!")
            .bold()
        }
        .frame(width: 200, height: 50)
        .foregroundColor(.white)
        .background(Color.blue)
    }
}
