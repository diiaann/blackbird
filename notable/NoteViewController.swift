//
//  NoteViewController.swift
//  notable
//
//  Created by Tina Chen on 3/15/16.
//  Copyright © 2016 plainspace. All rights reserved.
//

import UIKit
import Parse

class NoteViewController: UIViewController, UIAlertViewDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, communicationNoteView {

    @IBOutlet weak var noteScrollView: UIScrollView!
    @IBOutlet weak var noteCardView: UIView!
    @IBOutlet weak var editControlsView: UIView!
    @IBOutlet weak var noteControlsView: UIView!
    @IBOutlet weak var listBottomBorder: UIView!
    
    @IBOutlet weak var selectListButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var descriptionTextFieldHeight: NSLayoutConstraint!
    @IBOutlet weak var saveCancelContainer: UIView!
    @IBOutlet weak var scrollViewTop: NSLayoutConstraint!
    @IBOutlet weak var editControlsBottomMargin: NSLayoutConstraint!
    @IBOutlet weak var noteCardViewHeight: NSLayoutConstraint!
    @IBOutlet weak var deleteButton: UIButton!
    
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    
    var user = PFUser.currentUser()
    var list: PFObject!
    
    var editControlsViewOriginalY: CGFloat!
    var noteScrollViewOriginalCenter: CGPoint!
    
    var isNewNote = false
    var keyboardOpen = false
    var note: PFObject!
    var images: [PFFile]!
    var image: UIImage!
    
    var alertController: UIAlertController!
    var cancelAction: UIAlertAction!
    var deleteAction: UIAlertAction!
    
    var keyboardHeight: CGFloat!
    var editControlsOriginalBottomMargin: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionTextView.delegate = self
        imagePicker.delegate = self
        
        titleTextField.userInteractionEnabled = false
        descriptionTextView.userInteractionEnabled = false
        saveCancelContainer.userInteractionEnabled = false
        
        listBottomBorder.backgroundColor = UIColor(hexString: "D5DFDF")
        
        setupAlertControllers()
        editControlsOriginalBottomMargin = editControlsBottomMargin.constant
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        if isNewNote {
            loadNewNote()
            deleteButton.enabled = false
            if keyboardOpen {
                titleTextField.becomeFirstResponder()
            }
        } else {
            loadNote()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
    
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
    
    //animate into edit mode from view mode
    func enterEditMode() {
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
    
    //go directly into edit mode without animations
    func loadNewNote() {
        titleTextField.userInteractionEnabled = true
        descriptionTextView.userInteractionEnabled = true
        saveCancelContainer.userInteractionEnabled = true
        noteControlsView.alpha = 0
        view.backgroundColor = UIColor(hexString: "437B7F")
        if descriptionTextView.text == "Add description" {
            descriptionTextView.textColor = UIColor.lightGrayColor()
        }
        editControlsBottomMargin.constant = 0
        scrollViewTop.constant = 43
        images = [PFFile]()
        if image != nil {
            var newImageData = UIImageJPEGRepresentation(image!, 0.5)
            images.append(PFFile(name: "image.jpg", data: newImageData!)!)
            renderImages()
        }
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
        currentNote["images"] = images
        
        //TODO: this is hardcoded until we have a way to select a list
        currentNote["parent"] = list
        
        currentNote.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            print("saving note")
            if (success) {
                self.exitEditMode()
                print("Saved \(self.titleTextField.text)")
                //self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                print(error!.description);
            }
        }
    }
    
    //animates from edit mode to view mode
    func exitEditMode() {
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
        if descriptionTextView.text == "Add description" {
            descriptionTextView.textColor = UIColor.lightGrayColor()
        } else {
            descriptionTextView.textColor = UIColor(hexString: "306161")
        }
        images = note["images"] as? [PFFile]
        if images?.count > 0 {
            renderImages()
        }
        
        list = note["parent"] as! PFObject
        list.fetchIfNeededInBackgroundWithBlock {
            (post: PFObject?, error: NSError?) -> Void in
            self.selectListButton.setTitle(self.list["title"] as? String, forState: .Normal)
        }
    }
    
    func renderImages() {
        print("rendering with array count: \(images?.count)")
        var startingY = self.descriptionTextView.frame.origin.y + self.descriptionTextView.frame.height + 20
        for imageFile in images {
            print("Starting y is \(startingY)")
            var calculatedHeight: CGFloat!
            imageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                let imageView = UIImageView(image: UIImage(data: imageData!))
                print("\(self.images?.count) width is \(imageView.frame.size.width)")
                if imageView.frame.size.width != 0 {
                    calculatedHeight = self.noteScrollView.frame.size.width * imageView.frame.size.height/imageView.frame.size.width
                    imageView.frame = CGRect(x: CGFloat(0), y: CGFloat(startingY), width: self.noteScrollView.frame.size.width, height: calculatedHeight)
                    self.noteCardView.addSubview(imageView)
                    startingY = startingY + calculatedHeight + 1
                    self.noteCardViewHeight.constant = startingY - 1
                }
            }
        }
    }
    
    //Manages placeholder text effect for description text view
    func textViewDidChange(textView: UITextView) {
        descriptionTextFieldHeight.constant = textView.intrinsicContentSize().height
    }
    //If text is placeholder, remove it when user starts editing
    func textViewDidBeginEditing(textView: UITextView) {
        if descriptionTextView.textColor == UIColor.lightGrayColor() {
            descriptionTextView.text = nil
            descriptionTextView.textColor = UIColor(hexString: "306161")
        }
    }
    //If field is empty when user exits editing, replace with placeholder
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

    @IBAction func onSelectListButton(sender: UIButton) {
        performSegueWithIdentifier("selectListSegue", sender: self)
    }
    
    func backToNote(list: PFObject) {
        
        self.list = list
        //TODO: this might incur weird behavior for empty states
        selectListButton.setTitle(list["title"] as! String, forState: .Normal)
                
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

    
    @IBAction func AddImageButton(sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    
    @IBAction func onPhotoButton(sender: UIButton) {
        if (UIImagePickerController.isSourceTypeAvailable(.Camera)) {
            if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .Camera
                imagePicker.cameraCaptureMode = .Photo
                presentViewController(imagePicker, animated: true, completion: {})
            }
        } else {
            print("no camera found")
        }

    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        if images != nil {
            print("images exists with \(images.count) images")
        } else {
            images = [PFFile]()
            print("created new pffile array")
        }
        var newImageData = UIImageJPEGRepresentation(image, 0.5)
        print("number of images before appending \(images.count)")
        images.append(PFFile(name: "image.jpg", data: newImageData!)!)
        print("number of images after appending \(images.count)")
        print("images is \(images)")
        renderImages()
        dismissViewControllerAnimated(true, completion: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "selectListSegue") {
            
            let destViewController = segue.destinationViewController as! SelectListViewController
            destViewController.delegate = self
            
        }
    }


}
