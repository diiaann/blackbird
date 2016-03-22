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
    
    var currentUser = PFUser.currentUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if currentUser != nil {
            performSegueWithIdentifier("signedInSegue", sender: self)
        }
        
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
    
    @IBAction func didPressSignin(sender: AnyObject) {
        
        if self.emailField.text!.isEmpty {
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
            PFUser.logInWithUsernameInBackground(emailField.text!, password: passwordField.text!) {
                (user: PFUser?, error: NSError?) -> Void in
                
                if user != nil {
                    self.performSegueWithIdentifier("signedInSegue", sender: self)
                } else {
                    print(error)
                }
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
        titleLabel.transform = CGAffineTransformMakeScale(0.8, 0.8)
        fieldParentView.frame.origin.y = initialYfieldParentView + offsetfieldParentView
        buttonParentView.frame.origin.y = initialYbuttonParentView + offsetbuttonParentView
    }
    
    func keyboardWillHide(notification: NSNotification!) {
        titleLabel.frame.origin.y = initialYtitleLabel
        titleLabel.transform = CGAffineTransformMakeScale(1.0, 1.0)
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
