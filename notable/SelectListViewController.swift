//
//  SelectListViewController.swift
//  notable
//
//  Created by Tina Chen on 3/20/16.
//  Copyright © 2016 plainspace. All rights reserved.
//

import UIKit
import Parse

protocol communicationNoteView {
    func backToNote(list:PFObject)
}

class SelectListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var delegate: communicationNoteView?
    
    var lists: [PFObject] = [PFObject]()
    var user = PFUser.currentUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        var query = PFQuery(className:"List")
        
        query.whereKey("user", equalTo: user!)
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                
                self.lists = objects! as [PFObject]
                self.tableView.reloadData()
                
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let list = lists[indexPath.row]
        
        delegate?.backToNote(list)
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: nil)
        let list = lists[indexPath.row]
        
        cell.textLabel?.text = list["title"] as? String
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    @IBAction func onCancel(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    /*

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
