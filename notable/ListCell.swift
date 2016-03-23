//
//  ListCell.swift
//  notable
//
//  Created by Jared on 3/13/16.
//  Copyright © 2016 plainspace. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var previewImageView: UIImageView!
    
    var originalCenter:CGPoint!
    var actionsOnDragRelease = false
    
    private let whiteRoundedCornerView = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // add a pan recognizer
        //let recognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        //recognizer.delegate = self
        //addGestureRecognizer(recognizer)

    }

    //MARK: - white rounder corner tableViewCell methods
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setUp()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let bounds = self.bounds
        
        var whiteRoundedCornerViewFrame = CGRect()
        whiteRoundedCornerViewFrame.origin.x = 15
        whiteRoundedCornerViewFrame.origin.y = 15
        
        whiteRoundedCornerViewFrame.size.width = bounds.width - 20 - whiteRoundedCornerViewFrame.origin.x
        whiteRoundedCornerViewFrame.size.height = bounds.height - whiteRoundedCornerViewFrame.origin.y
        whiteRoundedCornerView.frame = whiteRoundedCornerViewFrame
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private func setUp() {
        setUpWhiteRoundedCornerView()
    }
    
    private func setUpWhiteRoundedCornerView() {
        let child = whiteRoundedCornerView
        child.backgroundColor = .whiteColor()
        
        let layer = child.layer
        layer.cornerRadius = 6.0
        layer.rasterizationScale = UIScreen.mainScreen().scale
        layer.shadowColor = UIColor.grayColor().CGColor
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowOpacity = 0.5
        layer.shouldRasterize = true
        
        insertSubview(child, atIndex: 0)
    }
    
    //MARK: - horizontal pan gesture methods
    func handlePan(recognizer: UIPanGestureRecognizer) {
        // 1
        if recognizer.state == .Began {
            // when the gesture begins, record the current center location
            originalCenter = center
            print("began")
        }
        // 2
        if recognizer.state == .Changed {
            let translation = recognizer.translationInView(self)
            center = CGPointMake(originalCenter.x + translation.x, originalCenter.y)
            // has the user dragged the item far enough to initiate an actions complete?
            // actionsOnDragRelease = frame.origin.x < -frame.size.width / 2.0
            print("changed")
        }
        // 3
        if recognizer.state == .Ended {
            // the frame this cell had before user dragged it
            let originalFrame = CGRect(x: 0, y: frame.origin.y,
                width: bounds.size.width, height: bounds.size.height)
            if !actionsOnDragRelease {
                // if the item is not being actioned, snap back to the original location
                UIView.animateWithDuration(0.2, animations: {self.frame = originalFrame})
            }
            print("ended")
        }
    }
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translationInView(superview!)
            if fabs(translation.x) > fabs(translation.y) {
                return true
            }
            return false
        }
        return false
    }
}
