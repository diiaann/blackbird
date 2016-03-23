//
//  EditListViewController.swift
//  notable
//
//  Created by Diandian Xiao on 3/16/16.
//  Copyright © 2016 plainspace. All rights reserved.
//

import UIKit
import Parse

class EditListViewController: UIViewController {
    
    @IBOutlet weak var listTitleInput: UITextField!
    @IBOutlet weak var listDescInput: UITextField!
    
    var user = PFUser.currentUser()
    
    var list: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (list != nil) {
            listTitleInput.text = list["title"] as? String
            listDescInput.text = list["desc"] as? String
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func didTapSave(sender: AnyObject) {
        
        //Update the existing list
        var query = PFQuery(className:"List")
        query.getObjectInBackgroundWithId(list.objectId!) {
            (list: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
            } else if let list = list {
                list["title"] = self.listTitleInput.text
                list["desc"] = self.listDescInput.text
                list.saveInBackground()
                self.dismissViewControllerAnimated(true, completion: nil)
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
