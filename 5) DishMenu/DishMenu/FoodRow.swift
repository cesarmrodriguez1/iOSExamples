//
//  FoodRow.swift
//  DishMenu
//
//  Created by Guest User on 8/30/21.
//  Copyright © 2021 Guest User. All rights reserved.
//

import SwiftUI

struct FoodRow: View{
    var category: String
    var foods: [Product]
    
    var body: some View{
        VStack{
            Text(self.category)
                .foregroundColor(.black)
                .font(.title)
                .multilineTextAlignment(.leading)
            
            ScrollView(.horizontal, showsIndicators: false, content:{
                HStack(alignment: .top){
                    ForEach(foods){ food in
                        NavigationLink(
                            destination: FoodDetail(food: food),
                            label:{
                                FoodItem(food: food)
                                    .frame(width: 300)
                                    .padding(.trailing, 30)
                        }
                        )
                    }
                }
                
            })
        }
    }
}
