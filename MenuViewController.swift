//
//  MenuViewController.swift
//  notable
//
//  Created by Jared on 3/22/16.
//  Copyright © 2016 plainspace. All rights reserved.
//

import UIKit
import Parse

class MenuViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    var currentUser = PFUser.currentUser()
    
    @IBAction func didTouchSignoutButton(sender: AnyObject) {
        
        PFUser.logOutInBackgroundWithBlock({(error) -> Void in
            self.performSegueWithIdentifier("signOutSegue", sender: self);
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initAppearance()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didPressClose(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // set background color
    
    func initAppearance() -> Void {
        let background = CAGradientLayer().greenColorGradient()
        background.frame = self.view.bounds
        self.backgroundView.layer.insertSublayer(background, atIndex: 0)
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
