//
//  ContentView.swift
//  DishMenu
//
//  Created by Guest User on 8/30/21.
//  Copyright © 2021 Guest User. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var categories: [String:[Product]]{
        .init(grouping: foodData, by:{$0.category})
    }
    var body: some View {
        NavigationView{
            List(categories.keys.sorted(), id: \.self){ category in
                FoodRow(category: "\(category)", foods: self.categories[category]!)
                    .frame(height: 320)
                    .padding(.top)
                    .padding(.bottom)
            }
        .navigationBarTitle("Restaurant")
        }
    }
}

