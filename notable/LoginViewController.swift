//
//  LoginViewController.swift
//  notable
//
//  Created by Diandian Xiao on 3/13/16.
//  Copyright © 2016 plainspace. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    @IBOutlet weak var errorMessage: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.enabled = false
        errorMessage.hidden = true

    }
    func showError(error: String) {
        errorMessage.hidden = false
        errorMessage.text = error
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onInputChange(sender: AnyObject) {
        validateForm()
    }
    
    @IBAction func onPasswordChange(sender: AnyObject) {
        validateForm()
    }
    
    func validateForm(){
        if (passwordInput.text != "" && emailInput.text != "") {
            loginButton.enabled = true
            print("loginButton enabled")
        }
    }
    
    @IBAction func didPressLogin(sender: AnyObject) {
       
        
        PFUser.logInWithUsernameInBackground(emailInput.text!, password: passwordInput.text!) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                self.performSegueWithIdentifier("loginSegue", sender: self)
            } else {
                print(error)
            }
        }
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
