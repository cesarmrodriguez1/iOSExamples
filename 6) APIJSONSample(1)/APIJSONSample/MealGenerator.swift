//
//  MealGenerator.swift
//  APIJSONSample
//
//  Created by gdaalumno on 01/09/21.
//

import Foundation
import Combine

final class MealGenerator: ObservableObject{
    @Published var currentMeal: Meal?
    @Published var currentURL : String?
    private var cancellables = Set<AnyCancellable>()
    
    public func fetchDish(){
        let url = URL(string: "https://www.themealdb.com/api/json/v1/1/random.php")!
        
        URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .sink{_ in } receiveValue: {data, _ in
                
                if let mealData = try?
                
                    JSONDecoder().decode(MealData.self, from: data){
                    self.currentMeal = mealData.meals.first
                    self.currentURL = mealData.meals.first?.imageUrlString
                }
                else{
                    print("Something went wrong :(")
                }
            }
            .store(in: &cancellables)
    }
}
