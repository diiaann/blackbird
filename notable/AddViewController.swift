//
//  AddViewController.swift
//  notable_FAB
//
//  Created by Tina Chen on 3/12/16.
//  Copyright © 2016 tinachen. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var addContainer: UIView!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var addListButton: UIButton!
    @IBOutlet weak var addLocationButton: UIButton!
    @IBOutlet weak var addTextButton: UIButton!
    
    var addContainerOriginalFrame: CGRect!
    var addMode: Bool!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addContainerOriginalFrame = addContainer.frame
        
        addButton.layer.cornerRadius = addButton.frame.height/2
        
        addContainer.layer.cornerRadius = addContainer.frame.width/2
        addContainer.layer.shadowColor = UIColor.blackColor().CGColor
        addContainer.layer.shadowOffset = CGSizeMake(0, 2)
        addContainer.layer.shadowRadius = 2
        addContainer.layer.shadowOpacity = 0.3
        
        addListButton.transform = CGAffineTransformMakeScale(0, 0)
        addPhotoButton.transform = CGAffineTransformMakeScale(0, 0)
        addLocationButton.transform = CGAffineTransformMakeScale(0, 0)
        addTextButton.transform = CGAffineTransformMakeScale(0, 0)
        
        //when there is no delay, the openOptions animations don't work.
        delay(0.01) { () -> () in
            self.openOptions()
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onAddButton(sender: UIButton) {
        if addMode! {
            closeOptions()
        }
    }
    
    @IBAction func onTapBackground(sender: UITapGestureRecognizer) {
        if addMode! {
            closeOptions()
        }
    }

    func openOptions() {
        addMode = true
        UIView.animateWithDuration(0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: { () -> Void in
            self.addButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI/Double(4)))
            }, completion: nil)
        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: [], animations: { () -> Void in
            self.addContainer.transform = CGAffineTransformMakeScale(4.5, 4.5)
            }, completion: nil)
        
        UIView.animateWithDuration(0.3, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: [], animations: { () -> Void in
            self.addTextButton.transform = CGAffineTransformIdentity
            }, completion: nil)
        
        UIView.animateWithDuration(0.3, delay: 0.3, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: [], animations: { () -> Void in
            self.addPhotoButton.transform = CGAffineTransformIdentity
            }, completion: nil)
        
        UIView.animateWithDuration(0.3, delay: 0.4, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: [], animations: { () -> Void in
            self.addLocationButton.transform = CGAffineTransformIdentity
            }, completion: nil)
        
        UIView.animateWithDuration(0.3, delay: 0.5, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.3, options: [], animations: { () -> Void in
            self.addListButton.transform = CGAffineTransformIdentity
            }, completion: nil)
    }
    
    func closeOptions() {
        addMode = false
        UIView.animateWithDuration(0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: { () -> Void in
            self.addButton.transform = CGAffineTransformIdentity
            self.addContainer.transform = CGAffineTransformIdentity
            }, completion: { _ in
                self.dismissViewControllerAnimated(true, completion: nil)
        })
        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: [], animations: { () -> Void in
            self.addListButton.transform = CGAffineTransformMakeScale(0, 0)
            self.addPhotoButton.transform = CGAffineTransformMakeScale(0, 0)
            self.addLocationButton.transform = CGAffineTransformMakeScale(0, 0)
            self.addTextButton.transform = CGAffineTransformMakeScale(0, 0)
            }, completion: nil)
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