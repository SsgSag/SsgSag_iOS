//
//  ReviewPageViewController.swift
//  SsgSag
//
//  Created by 남수김 on 2020/01/23.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit

class ReviewPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    lazy var subViewControllers: [UIViewController] = {
        return [
            UIStoryboard(name: "Review", bundle: nil).instantiateViewController(withIdentifier: "clubReviewVC") as! ClubReviewViewController,
            UIStoryboard(name: "Review", bundle: nil).instantiateViewController(withIdentifier: "clubReviewVC") as! ClubReviewViewController,
            UIStoryboard(name: "Review", bundle: nil).instantiateViewController(withIdentifier: "clubReviewVC") as! ClubReviewViewController,
        ]
    }()
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let curindex: Int = subViewControllers.firstIndex(of: viewController) ?? 0
        if curindex <= 0 {
            return nil
        }
        return subViewControllers[curindex-1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let curindex: Int = subViewControllers.firstIndex(of: viewController) ?? 0
        if curindex >= subViewControllers.count - 1 {
            return nil
        }
        return subViewControllers[curindex+1]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return subViewControllers.count
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        self.dataSource = self
        
        self.setViewControllers([subViewControllers[0]], direction: .forward, animated: true, completion: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
   
}
