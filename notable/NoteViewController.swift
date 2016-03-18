//
//  NoteViewController.swift
//  notable
//
//  Created by Tina Chen on 3/15/16.
//  Copyright © 2016 plainspace. All rights reserved.
//

import UIKit
import Parse

class NoteViewController: UIViewController {

    @IBOutlet weak var noteScrollView: UIScrollView!
    @IBOutlet weak var editControlsView: UIView!
    @IBOutlet weak var noteControlsView: UIView!
    @IBOutlet weak var listBottomBorder: UIView!
    
    @IBOutlet weak var listTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var imagesView: UIView!
    
    var user = PFUser.currentUser()
    
    var editControlsViewOriginalY: CGFloat!
    var noteScrollViewOriginalCenter: CGPoint!
    var images: [UIImageView]!
    var newImage: UIImageView!
    var image: UIImage!
    var startInEditMode = false
    
    var isNewNote = false
    var note: PFObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editControlsViewOriginalY = view.frame.height
        noteScrollViewOriginalCenter = noteScrollView.center
        listTextField.setBottomBorder("D5DFDF")
        listTextField.userInteractionEnabled = false
        titleTextField.userInteractionEnabled = false
        descriptionTextField.userInteractionEnabled = false
        images = []
        newImage = UIImageView(image: image)
        images.append(newImage)
        //renderImages()
        

//        view.addSubview(newImage)
//        testImage.image = image

        
    }
    
    override func viewWillAppear(animated: Bool) {
        if startInEditMode == true {
            loadEditMode()
            print("loading editmode")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBackButton(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    @IBAction func onEditButton(sender: UIButton) {
        enterEditMode()
    }
    

    @IBAction func onCancel(sender: UIButton) {
        exitEditMode()
    }
    
    
    func enterEditMode() {
        listTextField.userInteractionEnabled = true
        titleTextField.userInteractionEnabled = true
        descriptionTextField.userInteractionEnabled = true
        UIView.animateWithDuration(0.2, delay: 0, options: [], animations: { () -> Void in
            self.noteControlsView.alpha = 0
            }, completion: nil)
        UIView.animateWithDuration(0.3, delay: 0, options: [], animations: { () -> Void in
            self.editControlsView.frame.origin.y = self.editControlsViewOriginalY - self.editControlsView.frame.size.height
            self.noteScrollView.center.y = self.noteScrollViewOriginalCenter.y + 40
            self.view.backgroundColor = UIColor(hexString: "437B7F")
            }, completion: nil)
    }
    
    
    func loadEditMode() {
        listTextField.userInteractionEnabled = true
        titleTextField.userInteractionEnabled = true
        descriptionTextField.userInteractionEnabled = true
        noteControlsView.alpha = 0
        editControlsView.frame.origin.y = editControlsViewOriginalY - editControlsView.frame.size.height
        noteScrollView.center.y = self.noteScrollViewOriginalCenter.y + 40
        view.backgroundColor = UIColor(hexString: "437B7F")
    }

    @IBAction func onSave(sender: UIButton) {
        var note = PFObject(className:"Note")
        note["title"] = titleTextField.text
        note["desc"] = descriptionTextField.text
        note["user"] = user
        
        //TODO: this is hardcoded until we have a way to select a list
        note["parent"] = PFObject(withoutDataWithClassName:"List", objectId:"K7VRojcMCR")
        
        
        note.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                self.exitEditMode()
                //self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                print(error!.description);
            }
        }
    }
    
    
    func exitEditMode() {
        listTextField.userInteractionEnabled = false
        titleTextField.userInteractionEnabled = false
        descriptionTextField.userInteractionEnabled = false
        UIView.animateWithDuration(0.2, delay: 0, options: [], animations: { () -> Void in
            self.noteControlsView.alpha = 1
            }, completion: nil)
        UIView.animateWithDuration(0.3, delay: 0, options: [], animations: { () -> Void in
            self.editControlsView.frame.origin.y = self.editControlsViewOriginalY
            self.noteScrollView.center.y = self.noteScrollViewOriginalCenter.y
            self.view.backgroundColor = UIColor(hexString: "A8C3C3")
            }, completion: nil)
    }
    
    func renderImages() {
        for imageView in images {
            var currentY = 0
            imageView.frame = CGRect(x: CGFloat(0), y: CGFloat(currentY), width: imagesView.frame.size.width, height: imagesView.frame.size.width * imageView.frame.size.height/imageView.frame.size.width)
            imagesView.addSubview(imageView)
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
