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
    
    var lists: [PFObject] = [PFObject]()
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
        
    }
    
    override func viewWillAppear(animated: Bool) {
        var query = PFQuery(className:"List")
        
        query.whereKey("user", equalTo: user!)
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved:", objects)
                
                self.lists = objects! as [PFObject]
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
        return lists.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ListsCell") as! ListsCell
        
        
        cell.backgroundColor = UIColor.clearColor()
        
        let list = lists[indexPath.row]

        cell.titleLabel.text = list["title"] as? String

        cell.subtitleLabel.text = list["desc"] as? String
        
        //TODO: remove this print statement
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
        
        if segue.identifier == "listViewSeque" {

            let indexPath = tableView.indexPathForSelectedRow
            // Get the Row of the Index Path and set as index
            let list = lists[(indexPath?.row)!]
            // Get in touch with the DetailViewController
            let detailViewController = segue.destinationViewController as! ListViewController
            // Pass on the data to the Detail ViewController by setting it's indexPathRow value
                        
            detailViewController.list = list
            
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
