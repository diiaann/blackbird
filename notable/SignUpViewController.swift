//
//  SignUpViewController.swift
//  notable
//
//  Created by Diandian Xiao on 3/12/16.
//  Copyright © 2016 plainspace. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {

    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var passwordConfirmInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorMessage: UILabel!
    
    var currentUser = PFUser.currentUser()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpButton.enabled = false
        errorMessage.hidden = true
        
        if currentUser != nil {
            performSegueWithIdentifier("signInSegue", sender: self)
        } else {
            // Show the signup or login screen
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showError(error: String) {
        errorMessage.hidden = false
        errorMessage.text = error
        
    }
    
    func validateForm(){
        if (passwordInput.text != "" && passwordConfirmInput.text != "" && emailInput.text != "") {
            signUpButton.enabled = true
            print("button enabled")
        }
    }
    
    @IBAction func onEmailChange(sender: AnyObject) {
        validateForm()
    }

    @IBAction func onPasswordChange(sender: AnyObject) {
        validateForm()
    }
    
    
    @IBAction func onConfirmPasswordChange(sender: AnyObject) {
        validateForm()
    }
    
    @IBAction func didPressButton(sender: AnyObject) {
        
        
        if (passwordConfirmInput.text != passwordInput.text){
            showError("Passwords do not match")
        }
        
        else if (passwordInput.text?.characters.count < 6) {
            showError("Password needs to be at least 6 characters")

        }
        else {
            var user = PFUser()
            user.username = emailInput.text
            user.password = passwordInput.text
            
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool, error: NSError?) -> Void in
                if let error = error {
                    let errorString = error.userInfo["error"] as? NSString
                    self.showError(String(errorString))
                } else {
                    print("success")
                    self.performSegueWithIdentifier("signInSegue", sender: self)
                }
            }
        }
    
    }

}
