//
//  TableViewController.swift
//  Secret Santa
//
//  Created by Anna Gyergyai on 2014-11-24.
//  Copyright (c) 2014 Anna Gyergyai. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var items:[String : String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        let handler = {
            (list: [String : String]) -> Void in
            self.items = list
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
        self.getPeople(handler)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.items.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell")!
        
        cell.textLabel!.text = Array(self.items.keys)[indexPath.row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("DetailsController") as! DetailsController
        vc.toPass = Array(self.items.values)[indexPath.row]
        self.showViewController(vc as UIViewController, sender: vc)
    }
    
    func getPeople(handler:([String : String] -> Void))-> [String : String] {
        let url = NSURL(string: "https://jolly-helper-staging.herokuapp.com/persons")!
        var nameList:[String : String] = [:]
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
            
            var jsonErrorOptional: NSError?
            let jsonOptional: AnyObject!
            do {
                jsonOptional = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions(rawValue: 0))
            } catch let error as NSError {
                jsonErrorOptional = error
                jsonOptional = nil
            } catch {
                fatalError()
            }

            let jsonArray = jsonOptional as! NSArray
            
            for var index = 0; index < jsonArray.count ; ++index {
                nameList.updateValue(jsonOptional[index]["uid"] as! String, forKey: jsonOptional[index]["name"] as! String)
            }
            
            handler(nameList)
        }
    
        task.resume()

        return nameList
    }

}