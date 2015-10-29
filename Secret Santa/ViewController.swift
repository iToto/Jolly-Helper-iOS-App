//
//  ViewController.swift
//  Secret Santa
//
//  Created by Anna Gyergyai on 2014-11-15.
//  Copyright (c) 2014 Anna Gyergyai. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
  
  @IBOutlet var scrollView: UIScrollView!
  @IBOutlet var NameLabel: UILabel! = nil
  @IBOutlet var NameTextField: UITextField!
  @IBOutlet var AgeLabel: UILabel! = nil
  @IBOutlet var AgeTextField: UITextField!
  @IBOutlet var EmailLabel: UILabel! = nil
  @IBOutlet var EmailTextField: UITextField!

  var activeField: UITextField?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    scrollView.contentSize = view.frame.size
    registerForKeyboardNotifications()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillDisappear(animated: Bool) {
    deregisterFromKeyboardNotifications()
  }
  
  @IBAction func submitSecretSanta(sender: UIButton) {
    
    let person:PersonModel = PersonModel.init(username: NameTextField.text!, email: EmailTextField.text!, age: (AgeTextField.text! as NSString).doubleValue)
    RequestLib.createPerson(person, callback: handleSuccessReg)
  }
  
  func handleSuccessReg(response: NSURLResponse) {
    print("Response: " + response.description)
    let refreshAlert = UIAlertController(title: "Congrats!", message: "Thanks for joining! You'll be receiving an email shortly with your secret santa!", preferredStyle: UIAlertControllerStyle.Alert)
    
    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction) in
      let vc: AnyObject! = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController")
      self.showViewController(vc as! UIViewController, sender: vc)
    }))
    
    refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction) in
      print("Handle Cancel Logic here")
    }))
    
    self.presentViewController(refreshAlert, animated: true, completion: nil)
  }
  
  func registerForKeyboardNotifications() {
    //Adding notifies on keyboard appearing
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
  }
  
  
  func deregisterFromKeyboardNotifications() {
    //Removing notifies on keyboard appearing
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
  }
  
  func keyboardWasShown(notification: NSNotification) {
    //Need to calculate keyboard exact size due to Apple suggestions
    self.scrollView.scrollEnabled = true
    let info : NSDictionary = notification.userInfo!
    let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size
    let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
    
    self.scrollView.contentInset = contentInsets
    self.scrollView.scrollIndicatorInsets = contentInsets
    
    var aRect : CGRect = self.view.frame
    aRect.size.height -= keyboardSize!.height
    if let activeFieldPresent = activeField
    {
      if (!CGRectContainsPoint(aRect, activeField!.frame.origin))
      {
        self.scrollView.scrollRectToVisible(activeField!.frame, animated: true)
      }
    }
    
    
  }
  
  func keyboardWillBeHidden(notification: NSNotification) {
    //Once keyboard disappears, restore original positions
    let info : NSDictionary = notification.userInfo!
    let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size
    let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
    self.scrollView.contentInset = contentInsets
    self.scrollView.scrollIndicatorInsets = contentInsets
    self.view.endEditing(true)
    self.scrollView.scrollEnabled = false
    
  }
  
  func textFieldDidBeginEditing(textField: UITextField) {
    activeField = textField
  }
  
  func textFieldDidEndEditing(textField: UITextField) {
    activeField = nil
  }
}

