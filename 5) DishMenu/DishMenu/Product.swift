//
//  Product.swift
//  DishMenu
//
//  Created by Guest User on 8/30/21.
//  Copyright © 2021 Guest User. All rights reserved.
//

import SwiftUI

struct Product: Hashable, Codable, Identifiable{
    var id: Int
    var name: String
    var imageName: String
    var description: String
    var category: String
    
    enum Category: String, CaseIterable, Codable, Hashable{
        case international = "Cocina internacional"
        case dessert = "Postre"
        case seafood = "Delicias del mar"
        case drink = "Bebidas"
    }
}
