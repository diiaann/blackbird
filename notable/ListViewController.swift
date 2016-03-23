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
    @IBOutlet weak var smallTitle: UILabel!
    @IBOutlet weak var titleTop: NSLayoutConstraint!
//    @IBOutlet weak var previewImageView: UIImageView!
    
    var list: PFObject!
    var notes: [PFObject] = [PFObject]()
    var query: AnyObject!

    
    @IBAction func didPressBack(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 240/255, green: 231/255, blue: 235/255, alpha: 1)
        backgroundView.backgroundColor = UIColor(red: 168/255, green: 195/255, blue: 195/255, alpha: 1)
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .None
        
        list.fetchInBackground()
        
        self.listTitle.text = list["title"] as? String
        self.smallTitle.text = list["title"] as? String
        self.listDesc.text = list["desc"] as? String
        
        
        list.fetchInBackgroundWithBlock({ (object: PFObject?, error: NSError?) -> Void in
            if error == nil {
                self.listTitle.text = self.list["title"] as? String
                self.smallTitle.text = self.list["title"] as? String
                self.listDesc.text = self.list["desc"] as? String

            }
        })
        
        
        smallTitle.alpha = 0
        smallTitle.transform = CGAffineTransformMakeScale(0.2, 0.2)
        
        // set background color
        tableView.backgroundColor = UIColor.clearColor()
        
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0)
        
        addButton.layer.cornerRadius = addButton.frame.height/2
        
        query = PFQuery(className: "Note")
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
        
        let images = note["images"] as? [PFFile]
        if images != nil {
            if images?.count > 0 && images?[0] != nil {
                images![0].getDataInBackgroundWithBlock {
                    (imageData: NSData?, error: NSError?) -> Void in
                    if imageData != nil {
                        cell.previewImageView.image = UIImage(data: imageData!)
                    }
                }
            }
        }

        print(self.tableView.rowHeight)
        
        return cell
    }
    
    @IBAction func didPressTrash(sender: AnyObject) {
        let alertController = UIAlertController(title: "Are you sure?", message: "This message cannot be undone."
            , preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            self.list.deleteInBackground()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
        }
        self.presentViewController(alertController, animated: true) {}
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "noteDetailSegue" {
            
            let indexPath = tableView.indexPathForSelectedRow
            // Get the Row of the Index Path and set as index
            let note = notes[(indexPath?.row)!]
            // Get in touch with the DetailViewController
            let noteViewController = segue.destinationViewController as! NoteViewController
            // Pass on the data to the Detail ViewController by setting it's indexPathRow value
            noteViewController.note = note
        }
        else if segue.identifier == "editListSegue" {
            let editListViewController = segue.destinationViewController as! EditListViewController
            editListViewController.list = list
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset = tableView.contentOffset.y
        let min = titleTop.constant
        let max = titleTop.constant - headerView.frame.height
        if (offset < min && offset > max) {
            let scale = convertValue(offset, r1Min: min, r1Max: max, r2Min: 1, r2Max: 0.2)
            let opacity = convertValue(offset, r1Min: min, r1Max: max, r2Min: 1, r2Max: 0)
            smallTitle.transform = CGAffineTransformMakeScale(scale, scale)
            smallTitle.alpha = opacity
        } else if offset < min {
            smallTitle.alpha = 0
        } else if offset > max {
            smallTitle.alpha = 1
            smallTitle.transform = CGAffineTransformMakeScale(1, 1)
        }
    }
}
