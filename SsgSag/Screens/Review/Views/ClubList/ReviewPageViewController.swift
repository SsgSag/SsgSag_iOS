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
    private var previousPageIndex = 0
    private var curPageIndex = 0
    
    lazy var subViewControllers: [UIViewController] = {
        return [
            UIStoryboard(name: "Review", bundle: nil).instantiateViewController(withIdentifier: "ClubListVC") as! ClubSchoolListViewController,
            UIStoryboard(name: "Review", bundle: nil).instantiateViewController(withIdentifier: "ClubUnionListVC") as! ClubUnionListViewController
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
            if (pageViewController.viewControllers?.first as? ClubSchoolListViewController) != nil {
                index = 0
            } else if (pageViewController.viewControllers?.first as? ClubUnionListViewController) != nil {
                index = 1
            }
            
            pageDelegate?.setPageTabStatus(curIndex: index)
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
