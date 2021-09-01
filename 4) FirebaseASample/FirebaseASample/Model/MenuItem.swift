//
//  MenuItem.swift
//  FirebaseASample
//
//  Created by César on 02/02/21.
//

import Firebase

struct MenuItem {
  let reference: DatabaseReference?
  let key: String
  let name: String
  let price: Double
  var ordered: Bool

  // MARK: Initialize with Raw Data
    init(name: String, price: Double, ordered: Bool, key: String = ""){
        self.reference = nil
        self.key = key
        self.name = name
        self.price = price
        self.ordered = ordered
    }

  // MARK: Initialize with Firebase DataSnapshot
  init?(snapshot: DataSnapshot) {
    guard
      let value = snapshot.value as? [String: AnyObject],
      let name = value["name"] as? String,
      let price = value["price"] as? Double,
      let ordered = value["ordered"] as? Bool
    else {
      return nil
    }

    self.reference = snapshot.ref
    self.key = snapshot.key
    self.name = name
    self.price = price
    self.ordered = ordered
  }

  // MARK: Convert GroceryItem to AnyObject
  func toAnyObject() -> Any {
    return [
      "name": name,
      "price": price,
      "ordered": ordered
    ]
  }
}
