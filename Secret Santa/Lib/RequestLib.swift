//
//  RequestLib.swift
//  Jolly Helper
//
//  Created by Salvatore D'Agostino on 2015-10-29.
//  Copyright © 2015 Anna Gyergyai. All rights reserved.
//

import Foundation

class RequestLib  {
  
  class func createPerson(person: PersonModel, callback: (NSURLResponse) -> Void) {
    
    let request = NSMutableURLRequest(URL: NSURL(string: "https://jolly-helper-staging.herokuapp.com/persons")!)
    let session = NSURLSession.sharedSession()
    
    //var params = ["email":"\(usenNameTF.text)", "password":"\(passwordTF.text)"] as Dictionary
    let params = ["name":"\(person.username)", "email":"\(person.email)", "age": "\(person.age)"] as Dictionary
    var err: NSError?
    
    do {
      request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: [])
    } catch let error as NSError {
      err = error
      request.HTTPBody = nil
    }
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    request.HTTPMethod = "POST"
    
    let task: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
      do {
        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves) as? NSArray
      } catch let error as NSError {
        err = error
      }
      
      // json = {"response":"Success","msg":"User login successfully."}
      if(err != nil) {
        
        print(err!.localizedDescription)
        
      }
        
      else {
        
        //success! user added to secret santa
        
        dispatch_async(dispatch_get_main_queue()) {
          callback(response!)
        }
      }
    })
    task.resume()
  }
}