//
//  PageViewController.swift
//  PageControl
//
//  Created by Andrew Seeley on 2/2/17.
//  Copyright © 2017 Seemu. All rights reserved.
//

import UIKit
import Alamofire

class PageViewController: UIPageViewController {
    
    private var segmentOrder: segmentOrder = .first
    
    // MARK: UIPageViewControllerDataSource
    lazy var orderedViewControllers: [UIViewController] = {
        let swipeStoryboard = UIStoryboard(name: StoryBoardName.swipe,
                                           bundle: nil)
        
        let detailTextVC = swipeStoryboard.instantiateViewController(withIdentifier: StoryBoardName.detailText)
        
        let detailImageVC = swipeStoryboard.instantiateViewController(withIdentifier: StoryBoardName.detailImage)
        
        return [ detailTextVC, detailImageVC ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orderedViewControllers[0].view.frame = view.frame
        orderedViewControllers[1].view.frame = view.frame
        
        view.addSubview(orderedViewControllers[0].view)
        view.addSubview(orderedViewControllers[1].view)
        
        orderedViewControllers[0].view.isUserInteractionEnabled = true
        orderedViewControllers[1].view.isUserInteractionEnabled = true
        
        let tapGestureImage = UITapGestureRecognizer(target: self,
                                                     action: #selector(tapOn(_:)))
        tapGestureImage.numberOfTapsRequired = 1
        tapGestureImage.numberOfTouchesRequired = 1
        
        self.view.addGestureRecognizer(tapGestureImage)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func removeFromParent() {
        super.removeFromParent()
        print("removedFrom Parent")
    }
    
    deinit {
        print("deinit pageVC Parent")
    }
    
    
    @objc func tapOn(_ sender: UITapGestureRecognizer) {
        self.view.layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        if segmentOrder == .first {
            
            orderedViewControllers[0].view.isHidden = false
            orderedViewControllers[1].view.isHidden = true
            
            segmentOrder = .second
        } else {

            orderedViewControllers[0].view.isHidden = true
            orderedViewControllers[1].view.isHidden = false
            
            segmentOrder = .first
        }        
    }
}

enum segmentOrder {
     case first
     case second
}
