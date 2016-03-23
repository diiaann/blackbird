//
//  CreateViewController.swift
//  notable
//
//  Created by Jared on 2/12/16.
//  Copyright © 2016 plainspace. All rights reserved.
//

import UIKit
import Parse

class CreateViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var signupScrollView: UIScrollView!
    @IBOutlet weak var fieldParentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var buttonParentView: UIView!
    @IBOutlet weak var signupButtonBackground: UIView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var currentUser = PFUser.currentUser()
    
    @IBAction func didTouchBackButton(sender: AnyObject) {
        performSegueWithIdentifier("signupIntroSegue", sender:self)
    }
    
    @IBAction func didTouchNeedSigninButton(sender: AnyObject) {
        performSegueWithIdentifier("needSignInSegue", sender:self)
    }
    
    var initialYtitleLabel: CGFloat!
    var offsettitleLabel: CGFloat!
    
    var initialYfieldParentView: CGFloat!
    var offsetfieldParentView: CGFloat!
    
    var initialYbuttonParentView: CGFloat!
    var offsetbuttonParentView: CGFloat!
    
    var defaults = NSUserDefaults.standardUserDefaults()

    @IBAction func didPressSignup(sender: AnyObject) {
        self.activityIndicator.stopAnimating()
        if emailField.text!.isEmpty {
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
        } else if passwordField.text?.characters.count < 6 {
            let alertController = UIAlertController(title: "Password Required", message: "Please enter a password longer than 6 characters", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in
            }
            presentViewController(alertController, animated: true) {}
            alertController.addAction(okAction)
        } else {
            var user = PFUser()
            user.username = emailField.text
            user.password = passwordField.text
            activityIndicator.startAnimating()
            user.signUpInBackgroundWithBlock {
                (succeeded: Bool, error: NSError?) -> Void in
                if let error = error {
                    let errorString = error.userInfo["error"] as? NSString
                    
                    let alertController = UIAlertController(title: "Whoops!", message: (String(errorString)), preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in
                    }
                    self.presentViewController(alertController, animated: true) {}
                    alertController.addAction(okAction)
                    
                } else {
                    self.activityIndicator.stopAnimating()
                    self.performSegueWithIdentifier("signedUpSegue", sender: self)
                }
            }
        }
    }
    
    @IBAction func didTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if currentUser != nil {
            performSegueWithIdentifier("signedUpSegue", sender: self)
        }
        
        signupScrollView.delegate = self
        signupScrollView.contentSize = signupScrollView.frame.size
        signupScrollView.contentInset.bottom = 100
        
        initialYtitleLabel = titleLabel.frame.origin.y
        offsettitleLabel = -48
        
        initialYfieldParentView = fieldParentView.frame.origin.y
        offsetfieldParentView = -75
        
        initialYbuttonParentView = buttonParentView.frame.origin.y
        offsetbuttonParentView = -200
        
        signupButtonBackground.layer.cornerRadius = signupButtonBackground.frame.height/20
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        let transform = CGAffineTransformMakeScale(0.5, 0.5)
        
        titleLabel.transform = transform
        fieldParentView.transform = transform
        
        titleLabel.alpha = 0
        fieldParentView.alpha = 0
    }
    
    override func viewDidAppear(animated: Bool) {
        
        UIView.animateWithDuration(0.4) { () -> Void in
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
