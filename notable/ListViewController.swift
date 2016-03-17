//
//  ListViewController.swift
//  notable
//
//  Created by Jared on 3/13/16.
//  Copyright © 2016 plainspace. All rights reserved.
//

import UIKit
import Parse

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var listTitle: UILabel!
    @IBOutlet weak var listDesc: UILabel!
    
    var list: PFObject!
    
    var notes: [PFObject] = [PFObject]()

    
    @IBAction func didPressBack(sender: AnyObject) {
        print("does it get here")
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 235/255, green: 225/255, blue: 217/255, alpha: 1)
        
        backgroundView.backgroundColor = UIColor(red: 168/255, green: 195/255, blue: 195/255, alpha: 1)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .None
        
        listTitle.text = list["title"] as? String
        listDesc.text = list["desc"] as? String
        
        // set background color
        tableView.backgroundColor = UIColor.clearColor()
                
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0)
        
        addButton.layer.cornerRadius = addButton.frame.height/2
        
        let query = PFQuery(className: "Note")
        query.whereKey("parent", equalTo: list)
        query.findObjectsInBackgroundWithBlock {
            (notes: [PFObject]?, error: NSError?) -> Void in
            print("notes", notes)
            self.notes = notes!
            self.tableView.reloadData()
            
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        UITableViewCell.self
        return notes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ListCell") as! ListCell
        let note = notes[indexPath.row]

        cell.backgroundColor = UIColor.clearColor()
        
        cell.titleLabel.text = note["title"] as? String
        cell.subtitleLabel.text = note["desc"] as? String
        
        print(self.tableView.rowHeight)
        
        return cell
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
