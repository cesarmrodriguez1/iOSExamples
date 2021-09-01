//
//  MealData.swift
//  APIJSONSample
//
//  Created by gdaalumno on 01/09/21.
//

import Foundation

struct MealData: Decodable{
    let meals:[Meal]
}

struct Meal: Decodable{
    let name: String
    let imageUrlString: String
    let ingredients: [Ingredient]
    let instructions: String
    
}

extension Meal{
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        let dishDictionary = try container.decode([String:String?].self)
        
        var index = 1
        var ingredients : [Ingredient] = []
        
        while let ingredient = dishDictionary["strIngredient\(index)"] as? String,
              let measure = dishDictionary["strMeasure\(index)"] as? String,
              !ingredient.isEmpty,
              !measure.isEmpty{
            ingredients.append(.init(name: ingredient, measure: measure))
            
            index += 1
        }
        self.ingredients = ingredients
        self.name = dishDictionary["strMeal"] as? String ?? ""
        self.imageUrlString = dishDictionary["strMealThumb"] as? String ?? ""
        instructions = dishDictionary["strInstructions"] as? String ?? ""
    }
}

struct Ingredient: Decodable, Hashable{
    let name: String
    let measure: String
}
