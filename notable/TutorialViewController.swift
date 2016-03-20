//
//  TutorialViewController.swift
//  notable
//
//  Created by Jared on 2/11/16.
//  Copyright © 2016 plainspace. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet var tutorialScrollView: UIScrollView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var spinButtonParentContainer: UIView!
    
    @IBOutlet weak var spinButtonImage: UIImageView!
    
    @IBOutlet weak var spinButton: UIButton!
    
    
//    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
//        // Get the current page based on the scroll offset
//        let page : Int = Int(round(scrollView.contentOffset.x / 320))
//        
//        // Set the current page, so the dots will update
//        pageControl.currentPage = page
//        
//        let transform = CGAffineTransformMakeScale(0.2, 0.2)
//        
//        spinButtonImage.transform = transform
//        spinButtonImage.alpha = 0
//        
//        if page == 3 {
//            pageControl.hidden = true
//            
//            UIView.animateWithDuration(0.3) { () -> Void in
//                
//                self.spinButtonImage.transform = CGAffineTransformIdentity
//                self.spinButtonImage.alpha = 1
//                
//            }
//            
//        } else {
//            pageControl.hidden  = false
//            spinButtonImage.alpha = 0
//        }
//        
//    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        // Get the current page based on the scroll offset
        let page : Int = Int(round(scrollView.contentOffset.x / 320))
        // Set the current page, so the dots will update
        pageControl.currentPage = page
        if page == 3 {
            pageControl.hidden = true
            UIView.animateWithDuration(0.5) { () -> Void in
                self.spinButtonImage.alpha = 1
            }
        } else {
            pageControl.hidden = false
            spinButtonImage.alpha = 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tutorialScrollView.contentSize = CGSize(width: 1280, height: 568)
        
        tutorialScrollView.delegate = self
        
        spinButtonImage.alpha = 0
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        let transform = CGAffineTransformMakeScale(0.2, 0.2)
        
        spinButtonImage.transform = transform
        spinButtonImage.alpha = 0
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        UIView.animateWithDuration(0.3) { () -> Void in
            
            self.spinButtonImage.transform = CGAffineTransformIdentity
            self.spinButtonImage.alpha = 1
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
