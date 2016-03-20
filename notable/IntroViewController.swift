//
//  IntroViewController.swift
//  notable
//
//  Created by Jared on 2/10/16.
//  Copyright © 2016 plainspace. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {
    
    @IBOutlet weak var createButtonBackground: UIView!
    @IBOutlet weak var signinButtonBackground: UIView!
    
    override func viewDidLoad() {
        
        createButtonBackground.layer.cornerRadius = createButtonBackground.frame.height/20
        
        signinButtonBackground.layer.cornerRadius = signinButtonBackground.frame.height/20
        
        super.viewDidLoad()
        
    }
    
    @IBAction func didPressCreate(sender: AnyObject) {
        print("create")
    }
    
    @IBAction func didPressSignIn(sender: AnyObject) {
        print("sign in")
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
