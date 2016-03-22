//
//  NewListViewController.swift
//  notable
//
//  Created by Diandian Xiao on 3/20/16.
//  Copyright © 2016 plainspace. All rights reserved.
//

import UIKit
import Parse

class NewListViewController: UIViewController {

    @IBOutlet weak var listTitleInput: UITextField!
    @IBOutlet weak var listDescInput: UITextField!
    
    var user = PFUser.currentUser()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapSave(sender: UIButton) {
        
        var list = PFObject(className:"List")
        list["title"] = listTitleInput.text
        list["desc"] = listDescInput.text
        list["user"] = user
        
        list.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                print(error!.description);
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
