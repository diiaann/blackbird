//
//  NoteViewController.swift
//  notable
//
//  Created by Tina Chen on 3/15/16.
//  Copyright © 2016 plainspace. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {

    @IBOutlet weak var noteScrollView: UIScrollView!
    @IBOutlet weak var editControlsView: UIView!
    
    @IBOutlet weak var noteControlsView: UIView!
    var editControlsViewOriginalCenter: CGPoint!
    var noteScrollViewOriginalCenter: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editControlsViewOriginalCenter = editControlsView.center
        noteScrollViewOriginalCenter = noteScrollView.center

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBackButton(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    @IBAction func onEditButton(sender: UIButton) {
        UIView.animateWithDuration(0.2, delay: 0, options: [], animations: { () -> Void in
            self.noteControlsView.alpha = 0
            }, completion: nil)
        UIView.animateWithDuration(0.3, delay: 0, options: [], animations: { () -> Void in
            self.editControlsView.center.y = self.editControlsViewOriginalCenter.y - self.editControlsView.frame.size.height
            self.noteScrollView.center.y = self.noteScrollViewOriginalCenter.y + 40
            self.view.backgroundColor = UIColor(hexString: "437B7F")
            }, completion: nil)
    }
    

    @IBAction func onCancel(sender: UIButton) {
        exitEditMode()
    }
    

    @IBAction func onSave(sender: UIButton) {
        exitEditMode()
    }
    
    func exitEditMode() {
        UIView.animateWithDuration(0.2, delay: 0, options: [], animations: { () -> Void in
            self.noteControlsView.alpha = 1
            }, completion: nil)
        UIView.animateWithDuration(0.3, delay: 0, options: [], animations: { () -> Void in
            self.editControlsView.center.y = self.editControlsViewOriginalCenter.y
            self.noteScrollView.center.y = self.noteScrollViewOriginalCenter.y
            self.view.backgroundColor = UIColor(hexString: "A8C3C3")
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
