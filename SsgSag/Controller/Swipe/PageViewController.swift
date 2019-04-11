//
//  PageViewController.swift
//  PageControl
//
//  Created by Andrew Seeley on 2/2/17.
//  Copyright © 2017 Seemu. All rights reserved.
//

import UIKit
import Alamofire

class PageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    var pageControl = UIPageControl()
    var pageStatus: Int = 1
    var lastSelectedBarIndex: Int = 0
    
    var segmentOrder: segmentOrder = .first
    
    // MARK: UIPageViewControllerDataSource
    lazy var orderedViewControllers: [UIViewController] = {
        return [ self.newVC(viewController: "DetailText"),
                self.newVC(viewController: "DetailImage")]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        view.addSubview(orderedViewControllers[0].view)
        view.addSubview(orderedViewControllers[1].view)
        
        orderedViewControllers[0].view.isUserInteractionEnabled = true
        orderedViewControllers[1].view.isUserInteractionEnabled = true
        
        
        let tapGestureImage = UITapGestureRecognizer(target: self, action: #selector(tapOn(_:)))
        tapGestureImage.numberOfTapsRequired = 1
        tapGestureImage.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(tapGestureImage)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func segmentedProgressBarChangedIndex(index: Int) {
        print("111111")
    }
    
    func segmentedProgressBarFinished() {
        print("22222")
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
    
    func newVC(viewController: String) -> UIViewController {
        return UIStoryboard(name: "SwipeStoryBoard", bundle: nil).instantiateViewController(withIdentifier: viewController)
    }
    
    // MARK: Delegate methords
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        let pageContentViewController = pageViewController.viewControllers![0]
        
        self.pageControl.currentPage = orderedViewControllers.index(of: pageContentViewController)!
    }
    
    // MARK: Data source functions.
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    
}

enum segmentOrder {
     case first
     case second
}
