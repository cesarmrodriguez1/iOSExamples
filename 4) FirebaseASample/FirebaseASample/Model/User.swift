//
//  User.swift
//  FirebaseASample
//
//  Created by César on 02/02/21.
//

import Firebase

struct User {
  let userId: String
  let email: String

  init(authData: Firebase.User) {
    userId = authData.uid
    email = authData.email ?? ""
  }

  init(userId: String, email: String) {
    self.userId = userId
    self.email = email
  }
}
