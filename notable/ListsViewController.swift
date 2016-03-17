//
//  ListsViewController.swift
//  notable
//
//  Created by Jared on 3/7/16.
//  Copyright © 2016 plainspace. All rights reserved.
//

import UIKit
import Parse

extension CAGradientLayer {
    
    func greenColorGradient() -> CAGradientLayer {
        let topColor = UIColor(red: 235/255, green: 225/255, blue: 217/255, alpha: 1)
        let bottomColor = UIColor(red: 108/255, green: 160/255, blue: 163/255, alpha: 1)
        
        let gradientColors: [CGColor] = [topColor.CGColor, bottomColor.CGColor]
        let gradientLocations: [Float] = [0.0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        
        return gradientLayer
    }
}

class ListsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    //NSArray vs NSDictionary
    
    var notes: [PFObject] = [PFObject]()
    var user = PFUser.currentUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .None
        
        // set background color 
        tableView.backgroundColor = UIColor.clearColor()

        initAppearance()
        
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0)
        
        addButton.layer.cornerRadius = addButton.frame.height/2
        
        var query = PFQuery(className:"Note")
        query.whereKey("user", equalTo: user!)
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved:", objects)
                
                self.notes = objects! as [PFObject]
                self.tableView.reloadData()

            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        UITableViewCell.self
        return notes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ListsCell") as! ListsCell
        
        cell.backgroundColor = UIColor.clearColor()
        
        let note = notes[indexPath.row]
        
        cell.titleLabel.text = note["title"] as? String
        cell.subtitleLabel.text = note["desc"] as? String
        
        print(self.tableView.rowHeight)

        return cell
    }
    
    // set background color 
    
    func initAppearance() -> Void {
        let background = CAGradientLayer().greenColorGradient()
        background.frame = self.view.bounds
        self.backgroundView.layer.insertSublayer(background, atIndex: 0)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
        if segue.identifier == "listViewSegue", let destination = segue.destinationViewController as? ListViewController {
            if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPathForCell(cell) {
            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
