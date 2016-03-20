//
//  SigninViewController
//  notable
//
//  Created by Jared on 2/10/16.
//  Copyright © 2016 plainspace. All rights reserved.
//

import UIKit

class SigninViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var loginScrollView: UIScrollView!
    @IBOutlet weak var fieldParentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var buttonParentView: UIView!
    @IBOutlet weak var signinButtonBackground: UIView!
    @IBOutlet weak var signInButton: UIButton!
    
    @IBAction func didTouchBackButton(sender: AnyObject) {
         dismissViewControllerAnimated(true, completion: nil)
    }
    
    var initialYtitleLabel: CGFloat!
    var offsettitleLabel: CGFloat!
    
    var initialYfieldParentView: CGFloat!
    var offsetfieldParentView: CGFloat!
    
    var initialYbuttonParentView: CGFloat!
    var offsetbuttonParentView: CGFloat!
    
    var defaults = NSUserDefaults.standardUserDefaults()
    
    @IBAction func didPressSignin(sender: AnyObject) {
        if emailField.text == "asdf" && passwordField.text == "asdf" {
//            activityIndicator.startAnimating()
            delay(2) {
//                self.activityIndicator.stopAnimating()
                self.performSegueWithIdentifier("tutorialSegue", sender:self)
            }
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
        } else {
//            activityIndicator.startAnimating()
            delay(2) {
//                self.activityIndicator.stopAnimating()
                let alertController = UIAlertController(title: "Whoops!", message: "We're sorry, but we couldn't find an account with those credentials.", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in
                }
                self.presentViewController(alertController, animated: true) {}
                alertController.addAction(okAction)
            }
        }
    }
    
    @IBAction func didTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        // Do any additional setup after loading the view.
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
