//
//  FoodItem.swift
//  DishMenu
//
//  Created by Guest User on 8/30/21.
//  Copyright © 2021 Guest User. All rights reserved.
//

import SwiftUI

struct FoodItem: View{
    var food: Product
    
    var body: some View{
        VStack{
            Image(food.imageName)
            .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fill)
                .frame(width: 300, height: 170)
                .cornerRadius(10)
                .shadow(radius: 10)
            
            VStack(alignment: .leading, spacing: 5.0){
                Text(food.name)
                    .foregroundColor(.black)
                    .font(.title)
                
                Text(food.description)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .frame(height: 40)
            }
        }
    }
}
