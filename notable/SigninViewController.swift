//
//  SigninViewController
//  notable
//
//  Created by Jared on 2/10/16.
//  Copyright © 2016 plainspace. All rights reserved.
//

import UIKit
import Parse

class SigninViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var loginScrollView: UIScrollView!
    @IBOutlet weak var fieldParentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var buttonParentView: UIView!
    @IBOutlet weak var signinButtonBackground: UIView!
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // signInButton.enabled = false
        
        loginScrollView.delegate = self
        loginScrollView.contentSize = loginScrollView.frame.size
        loginScrollView.contentInset.bottom = 100
        
        initialYtitleLabel = titleLabel.frame.origin.y
        offsettitleLabel = -50
        
        initialYfieldParentView = fieldParentView.frame.origin.y
        offsetfieldParentView = -83
        
        initialYbuttonParentView = buttonParentView.frame.origin.y
        offsetbuttonParentView = -113
        
        signinButtonBackground.layer.cornerRadius = signinButtonBackground.frame.height/20
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        // user_email = defaults.objectForKey("email") as! String
        // user_password = defaults.objectForKey("password") as! String
        
        // print(user_email)
        // print(user_password)
        
        // definesPresentationContext = true
        
    }
    
    @IBAction func didTouchBackButton(sender: AnyObject) {
         performSegueWithIdentifier("signinIntroSegue", sender:self)
    }

    @IBAction func didTouchNeedSignupButton(sender: AnyObject) {
        performSegueWithIdentifier("needSignUpSegue", sender:self)
        
    }
    
    var initialYtitleLabel: CGFloat!
    var offsettitleLabel: CGFloat!
    
    var initialYfieldParentView: CGFloat!
    var offsetfieldParentView: CGFloat!
    
    var initialYbuttonParentView: CGFloat!
    var offsetbuttonParentView: CGFloat!
    
    var defaults = NSUserDefaults.standardUserDefaults()
    
    func showError(error: String) {
        // errorMessage.hidden = false
        // errorMessage.text = error
        
    }
    
    @IBAction func onEmailChange(sender: AnyObject) {
        //        validateForm()
    }
    
    @IBAction func onPasswordChange(sender: AnyObject) {
        //        validateForm()
    }
    
    //    func validateForm(){
    //        if (passwordInput.text != "" && emailInput.text != "") {
    //            loginButton.enabled = true
    //            print("loginButton enabled")
    //        }
    //    }
    //
    
    @IBAction func didPressSignin(sender: AnyObject) {
  
//        PFUser.logInWithUsernameInBackground(emailInput.text!, password: passwordInput.text!) {
//            (user: PFUser?, error: NSError?) -> Void in
//            if user != nil {
//                self.performSegueWithIdentifier("loginSegue", sender: self)
//            } else {
//                print(error)
//            }
//        }
        
        // if emailField.text == "asdf" && passwordField.text == "asdf"
        
        PFUser.logInWithUsernameInBackground(emailField.text!, password: passwordField.text!) {
            (user: PFUser?, error: NSError?) -> Void in
            if (self.emailField.text != "" && self.passwordField.text != "") {
                self.signInButton.enabled = true
                self.performSegueWithIdentifier("signinSegue", sender: self)
            } else if self.emailField.text!.isEmpty {
                let alertController = UIAlertController(title: "Email Required", message: "Please enter your email address", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in
                }
                self.presentViewController(alertController, animated: true) {}
                alertController.addAction(okAction)
            } else if self.passwordField.text!.isEmpty {
                let alertController = UIAlertController(title: "Password Required", message: "Please enter your password", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in
                }
                self.presentViewController(alertController, animated: true) {}
                alertController.addAction(okAction)
            } else {
                let alertController = UIAlertController(title: "Whoops!", message: "We're sorry, but we couldn't find an account with those credentials.", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in
                }
                self.presentViewController(alertController, animated: true) {}
                alertController.addAction(okAction)
                
                print(error)
            }
        }
    }
    
    @IBAction func didTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    override func viewWillAppear(animated: Bool) {
    
        let transform = CGAffineTransformMakeScale(0.2, 0.2)
        
        titleLabel.transform = transform
        fieldParentView.transform = transform
        
        titleLabel.alpha = 0
        fieldParentView.alpha = 0
    }
    
    override func viewDidAppear(animated: Bool) {
        
        UIView.animateWithDuration(0.2) { () -> Void in
            self.fieldParentView.transform = CGAffineTransformIdentity
            self.titleLabel.transform = CGAffineTransformIdentity
            
            self.fieldParentView.alpha = 1
            self.titleLabel.alpha = 1
        }
    }
    
    func keyboardWillShow(notification: NSNotification!) {
        titleLabel.frame.origin.y = initialYtitleLabel + offsettitleLabel
        fieldParentView.frame.origin.y = initialYfieldParentView + offsetfieldParentView
        buttonParentView.frame.origin.y = initialYbuttonParentView + offsetbuttonParentView
    }
    
    func keyboardWillHide(notification: NSNotification!) {
        titleLabel.frame.origin.y = initialYtitleLabel
        fieldParentView.frame.origin.y = initialYfieldParentView
        buttonParentView.frame.origin.y = initialYbuttonParentView
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= -50 {
            view.endEditing(true)
        }
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
