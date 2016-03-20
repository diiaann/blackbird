//
//  NoteViewController.swift
//  notable
//
//  Created by Tina Chen on 3/15/16.
//  Copyright © 2016 plainspace. All rights reserved.
//

import UIKit
import Parse

class NoteViewController: UIViewController, UIAlertViewDelegate, UITextViewDelegate {

    @IBOutlet weak var noteScrollView: UIScrollView!
    @IBOutlet weak var editControlsView: UIView!
    @IBOutlet weak var noteControlsView: UIView!
    @IBOutlet weak var listBottomBorder: UIView!
    
    @IBOutlet weak var listTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var descriptionTextFieldHeight: NSLayoutConstraint!
    @IBOutlet weak var saveCancelContainer: UIView!
    @IBOutlet weak var scrollViewTop: NSLayoutConstraint!
    @IBOutlet weak var editControlsBottomMargin: NSLayoutConstraint!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    //@IBOutlet weak var imagesView: UIView!
    
    var user = PFUser.currentUser()
    
    var editControlsViewOriginalY: CGFloat!
    var noteScrollViewOriginalCenter: CGPoint!
    var images: [UIImageView]!
    var newImage: UIImageView!
    var image: UIImage!
    
    var isNewNote = false
    var keyboardOpen = false
    var note: PFObject!
    
    var alertController: UIAlertController!
    var cancelAction: UIAlertAction!
    var deleteAction: UIAlertAction!
    
    var keyboardHeight: CGFloat!
    var editControlsOriginalBottomMargin: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionTextView.delegate = self
        if descriptionTextView.text == "Add description" {
            descriptionTextView.textColor = UIColor.lightGrayColor()
        }
        
        listTextField.userInteractionEnabled = false
        titleTextField.userInteractionEnabled = false
        descriptionTextView.userInteractionEnabled = false
        saveCancelContainer.userInteractionEnabled = false
        
        listBottomBorder.backgroundColor = UIColor(hexString: "D5DFDF")
        
        images = []
        newImage = UIImageView(image: image)
        images.append(newImage)
        if images.count > 0 {
            renderImages()
        }
        
        setupAlertControllers()
        editControlsOriginalBottomMargin = editControlsBottomMargin.constant
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        if isNewNote {
            loadEditMode()
            deleteButton.enabled = false
            if keyboardOpen {
                titleTextField.becomeFirstResponder()
            }
        } else {
            loadNote()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onBackButton(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func onEditButton(sender: UIButton) {
        enterEditMode()
    }
    

    @IBAction func onCancel(sender: UIButton) {
        if isNewNote {
            dismissViewControllerAnimated(true, completion: { () -> Void in
                self.exitEditMode()
            })
        } else {
            exitEditMode()
        }
    }
    
    @IBAction func onDeleteButton(sender: UIButton) {
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func enterEditMode() {
        listTextField.userInteractionEnabled = true
        titleTextField.userInteractionEnabled = true
        descriptionTextView.userInteractionEnabled = true
        saveCancelContainer.userInteractionEnabled = true
        
        editControlsBottomMargin.constant = 0
        scrollViewTop.constant = scrollViewTop.constant + 40
        
        UIView.animateWithDuration(0.1, delay: 0, options: [], animations: { () -> Void in
            self.noteControlsView.alpha = 0
            }, completion: nil)
        UIView.animateWithDuration(0.3, delay: 0, options: [], animations: { () -> Void in
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor(hexString: "437B7F")
            }, completion: nil)
    }
    
    
    func loadEditMode() {
        listTextField.userInteractionEnabled = true
        titleTextField.userInteractionEnabled = true
        descriptionTextView.userInteractionEnabled = true
        saveCancelContainer.userInteractionEnabled = true
        noteControlsView.alpha = 0
        view.backgroundColor = UIColor(hexString: "437B7F")
        editControlsBottomMargin.constant = 0
        scrollViewTop.constant = 43
    }

    @IBAction func onSave(sender: UIButton) {
        var currentNote: PFObject
        if isNewNote {
            currentNote = PFObject(className:"Note")
        } else {
            currentNote = note
        }
        currentNote["title"] = titleTextField.text
        currentNote["desc"] = descriptionTextView.text
        currentNote["user"] = user
        
        //TODO: this is hardcoded until we have a way to select a list
        currentNote["parent"] = PFObject(withoutDataWithClassName:"List", objectId:"K7VRojcMCR")
        
        currentNote.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                self.exitEditMode()
                print("Saved \(self.titleTextField.text)")
                //self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                print(error!.description);
            }
        }
    }
    
    func exitEditMode() {
        listTextField.userInteractionEnabled = false
        titleTextField.userInteractionEnabled = false
        descriptionTextView.userInteractionEnabled = false
        saveCancelContainer.userInteractionEnabled = false
        
        editControlsBottomMargin.constant = -60
        scrollViewTop.constant = scrollViewTop.constant - 40
        
        UIView.animateWithDuration(0.1, delay: 0, options: [], animations: { () -> Void in
           self.noteControlsView.alpha = 1
            }, completion: nil)
        UIView.animateWithDuration(0.3, delay: 0, options: [], animations: { () -> Void in
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor(hexString: "A8C3C3")
            }, completion: nil)
    }
    
    func loadNote() {
        titleTextField.text = note["title"] as! String
        descriptionTextView.text = note["desc"] as! String
    }
    
    func renderImages() {
        for imageView in images {
            if imageView.frame.size.width != 0 {
                var currentY = descriptionTextView.frame.origin.y + 62
                var calculatedHeight = noteScrollView.frame.size.width * imageView.frame.size.height/imageView.frame.size.width
                imageView.frame = CGRect(x: CGFloat(0), y: CGFloat(currentY), width: noteScrollView.frame.size.width, height: calculatedHeight)
                noteScrollView.addSubview(imageView)
                currentY += calculatedHeight
            }
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        descriptionTextFieldHeight.constant = textView.intrinsicContentSize().height
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if descriptionTextView.textColor == UIColor.lightGrayColor() {
            descriptionTextView.text = nil
            descriptionTextView.textColor = UIColor(hexString: "306161")
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if descriptionTextView.text.isEmpty {
            descriptionTextView.text = "Add description"
            descriptionTextView.textColor = UIColor.lightGrayColor()
        }
    }
    
    func keyboardWillShow(notification: NSNotification!) {
        let userInfo:NSDictionary = notification.userInfo!
        let keyboardFrame:NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.CGRectValue()
        keyboardHeight = keyboardRectangle.height
        editControlsBottomMargin.constant = editControlsOriginalBottomMargin + keyboardHeight + 60
        UIView.animateWithDuration(0.5) { () -> Void in
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide(notification: NSNotification!) {
        let userInfo:NSDictionary = notification.userInfo!
        let keyboardFrame:NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.CGRectValue()
        let keyboardHeight = keyboardRectangle.height
        editControlsBottomMargin.constant = 0
        UIView.animateWithDuration(0.3) { () -> Void in
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func onCardViewTap(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    func setupAlertControllers() {
        alertController = UIAlertController(title: nil, message: "Are you sure you want to delete this note?", preferredStyle: .ActionSheet)
        
        cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            // ...
        }
        
        alertController.addAction(cancelAction)
        
        deleteAction = UIAlertAction(title: "Delete", style: .Destructive) { (action) in
            self.note.deleteInBackground()
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }
        alertController.addAction(deleteAction)
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
