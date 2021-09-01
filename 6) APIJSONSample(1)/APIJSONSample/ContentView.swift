//
//  ContentView.swift
//  APIJSONSample
//
//  Created by gdaalumno on 01/09/21.
//

import SwiftUI

struct RandomMealView: View{
    @StateObject private var myGenerator = MealGenerator()
    
    var PersonalizedButton: some View{
        Button("Get random meal"){
            myGenerator.fetchDish()
        }
        .foregroundColor(.primary)
        .padding()
        .background(Color.blue)
        .cornerRadius(10.0)
        .onAppear{
            myGenerator.fetchDish()
        }
    }
    var body: some View{
        VStack{
            PersonalizedButton
            if let name = myGenerator.currentMeal?.name{
                Text(name)
                    .font(.largeTitle)
            }
            
            AsyncImageView(urlString: $myGenerator.currentURL)
            
            if let ingredients = myGenerator.currentMeal?.ingredients{
                HStack{
                    Text("Ingredients").font(.title2)
                    Spacer()
                }
                
                ForEach(ingredients, id: \.self){ingredient in
                    HStack{
                        Text(ingredient.name + " - " + ingredient.measure).font(.title2)
                        Spacer()
                    }
                }
            }
        }.padding()
    }
    
}

struct ContentView: View {
    var body: some View {
        RandomMealView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
