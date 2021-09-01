//
//  Data.swift
//  DishMenu
//
//  Created by Guest User on 8/30/21.
//  Copyright © 2021 Guest User. All rights reserved.
//

import Foundation

let foodData: [Product] = load("food.json")

func load<T:Decodable>(_ filename: String, as type: T.Type = T.self) ->T{
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else{
            fatalError("Couldnt find the resource")
    }
    
    do{
        data = try Data(contentsOf:  file)
    }
    catch{
        fatalError("Couldnt load file")
    }
    
    do{
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
    catch{
        fatalError("Couldnt parse file")
    }
}
