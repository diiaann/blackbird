//
//  ListsViewController.swift
//  notable
//
//  Created by Jared on 3/7/16.
//  Copyright © 2016 plainspace. All rights reserved.
//

import UIKit

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
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .None
        
        // set background color 
        tableView.backgroundColor = UIColor.clearColor()
        
//        tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);

        initAppearance()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        UITableViewCell.self
        return 20
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ListsCell") as! ListsCell
        
        cell.backgroundColor=UIColor.clearColor()
        
        cell.titleLabel.text = "Restaurants"
        cell.subtitleLabel.text = "Restos in NYC that I want to go to"
        
        print(self.tableView.rowHeight)

        return cell
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
