//
//  EditViewController.swift
//  notable
//
//  Created by Diandian Xiao on 3/14/16.
//  Copyright © 2016 plainspace. All rights reserved.
//

import UIKit
import Parse

class EditViewController: UIViewController {
    
    var user = PFUser.currentUser()
    
    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var descInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressSave(sender: AnyObject) {
        
        var note = PFObject(className:"Note")
        note["title"] = titleInput.text
        note["desc"] = descInput.text
        note["user"] = user
        
        do {
            try note.save()
        }
        catch {
            print("error!")
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
