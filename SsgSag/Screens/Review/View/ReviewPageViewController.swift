//
//  ReviewPageViewController.swift
//  SsgSag
//
//  Created by 남수김 on 2020/01/23.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit

class ReviewPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    var pageDelegate: ReviewPageDelegate?
    
    lazy var subViewControllers: [UIViewController] = {
        return [
            UIStoryboard(name: "Review", bundle: nil).instantiateViewController(withIdentifier: "clubReviewVC") as! ClubReviewViewController,
//            UIStoryboard(name: "2", bundle: nil).instantiateViewController(withIdentifier: "두번째페이지") as! TestViewController,
//            UIStoryboard(name: "3", bundle: nil).instantiateViewController(withIdentifier: "세번째페이지") as! ClubReviewViewController,
        ]
    }()
    
    // 이전페이지
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let curindex: Int = subViewControllers.firstIndex(of: viewController) ?? 0
        if curindex <= 0 {
            return nil
        }
        return subViewControllers[curindex-1]
    }
    
    // 다음페이지
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

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        // 페이지이동시 tab이동
        if completed {
            var index: Int!
            if let curVC = pageViewController.viewControllers?.first as? ClubReviewViewController {
                index = curVC.pageIndex
            } 
            pageDelegate?.setPageTabStatus(index: index)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        self.dataSource = self
        
        self.setViewControllers([subViewControllers[0]], direction: .forward, animated: true, completion: nil)
    }
    
    // 스크롤식의 페이징설정
    required init?(coder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
}
