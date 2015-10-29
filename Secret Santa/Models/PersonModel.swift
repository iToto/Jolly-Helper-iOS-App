//
//  PersonModel.swift
//  Jolly Helper
//
//  Created by Salvatore D'Agostino on 2015-10-29.
//  Copyright © 2015 Anna Gyergyai. All rights reserved.
//

import Foundation

class PersonModel: NSObject {
  var username: String
  var email: String
  var age: Double
  
  init(username: String, email: String, age: Double) {
    self.username = username
    self.email = email
    self.age = age
  }
  
  func toJson() -> String {
    return "{ " +
    "username: '" + self.username + "', " +
    "email: '" + self.email + "', " +
    "age: " + self.age.description + ", " +
    "}"
  }
}
