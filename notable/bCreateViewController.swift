//
//  CreateViewController.swift
//  Carousel
//
//  Created by Jared on 2/12/16.
//  Copyright © 2016 plainspace. All rights reserved.
//

import UIKit

class CreateViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var createScrollView: UIScrollView!
    @IBOutlet weak var createParentView: UIView!
    @IBOutlet weak var buttonParentView: UIView!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var agreeButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func didTouchBackButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    var defaults = NSUserDefaults.standardUserDefaults()
    
    var animateForm: Bool! = true
    
    var initialYcreateParentView: CGFloat!
    var offsetcreateParentView: CGFloat!
    
    var initialYbuttonParentView: CGFloat!
    var offsetbuttonParentView: CGFloat!
    
    // had to add this manually; the Common.swift file wasn't working
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    @IBAction func didTouchCreate(sender: AnyObject) {
        if firstNameField.text!.isEmpty {
            let alertController = UIAlertController(title: "First name required", message: "Please enter your first name", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in
            }
            presentViewController(alertController, animated: true) {}
            alertController.addAction(okAction)
        } else if lastNameField.text!.isEmpty {
            let alertController = UIAlertController(title: "Last name Required", message: "Please enter your last name", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in
            }
            presentViewController(alertController, animated: true) {}
            alertController.addAction(okAction)
        } else if emailField.text!.isEmpty {
            let alertController = UIAlertController(title: "Email Required", message: "Please enter your email address", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in
            }
            presentViewController(alertController, animated: true) {}
            alertController.addAction(okAction)
        } else if passwordField.text!.isEmpty {
            let alertController = UIAlertController(title: "Password Required", message: "Please enter your password", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in
            }
            presentViewController(alertController, animated: true) {}
            alertController.addAction(okAction)
        } else if agreeButton.selected == false {
            let termsAlertController = UIAlertController(title: "Terms of Service", message: "Please agree to the terms of service before continuing", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in
            }
            self.presentViewController(termsAlertController, animated: true) {
            }
            termsAlertController.addAction(okAction)
        } else {
            activityIndicator.startAnimating()
            defaults.setObject(firstNameField.text, forKey: "first_name")
            defaults.setObject(lastNameField.text, forKey: "last_name")
            defaults.setObject(emailField.text, forKey: "email")
            defaults.setObject(passwordField.text, forKey: "password")
            defaults.synchronize()
            delay(2) {
                self.activityIndicator.stopAnimating()
                self.performSegueWithIdentifier("tutorialSegue", sender: self)
            }
        }
    }
    
    @IBAction func didTouchAgree(sender: AnyObject) {
        if agreeButton.selected == false {
            print("terms true")
            agreeButton.selected = true
        }
        else {
            print("terms false")
            agreeButton.selected = false
        }
    }
    
    func keyboardWillShow(notification: NSNotification!) {
        createParentView.frame.origin.y = initialYcreateParentView + offsetcreateParentView
        buttonParentView.frame.origin.y = initialYbuttonParentView + offsetbuttonParentView
    }
    
    func keyboardWillHide(notification: NSNotification!) {
        createParentView.frame.origin.y = initialYcreateParentView
        buttonParentView.frame.origin.y = initialYbuttonParentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createScrollView.delegate = self
        
        createScrollView.contentSize = createScrollView.frame.size
        
        createScrollView.contentInset.bottom = 100
        
        initialYcreateParentView = createParentView.frame.origin.y
        offsetcreateParentView = -83
        
        initialYbuttonParentView = buttonParentView.frame.origin.y
        offsetbuttonParentView = -205
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
//        let viewedTerms = NSUserDefaults.standardUserDefaults().boolForKey("animateForm")
        
        let transform = CGAffineTransformMakeScale(0.2, 0.2)
        
        createParentView.transform = transform
        
        createParentView.alpha = 0
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        UIView.animateWithDuration(0.1) { () -> Void in
            
            self.createParentView.transform = CGAffineTransformIdentity
            
            self.createParentView.alpha = 1
            
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= -50 {
            view.endEditing(true)
        }
    }
    
//    @IBAction func checkBoxButton(sender: AnyObject) {
//        checkBoxButton.selected = !checkBoxButton.selected
//    }
    
    @IBAction func didTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
