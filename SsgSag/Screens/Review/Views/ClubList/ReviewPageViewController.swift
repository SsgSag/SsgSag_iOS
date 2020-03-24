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
    var mainType: MainType!
    
    var subViewControllers: [UIViewController] = []
    
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
                index = 1
            } else if (pageViewController.viewControllers?.first as? ClubUnionListViewController) != nil {
                index = 0
            }
            
            pageDelegate?.setPageTabStatus(curIndex: index)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        self.dataSource = self
        setTypePage()
        
        self.setViewControllers([subViewControllers[0]], direction: .forward, animated: true, completion: nil)
    }
    
    func setTypePage() {
        switch mainType {
        case .club:
            subViewControllers = [
                UIStoryboard(name: "Review", bundle: nil).instantiateViewController(withIdentifier: "ClubUnionListVC") as! ClubUnionListViewController,
                UIStoryboard(name: "Review", bundle: nil).instantiateViewController(withIdentifier: "ClubListVC") as! ClubSchoolListViewController
            ]
        case .activity:
            guard let vc = UIStoryboard(name: "Review", bundle: nil).instantiateViewController(withIdentifier: "ClubUnionListVC") as? ClubUnionListViewController else {
                return
            }
            vc.clubType = 2
            subViewControllers = [vc]
        case .intern:
            guard let vc = UIStoryboard(name: "Review", bundle: nil).instantiateViewController(withIdentifier: "ClubUnionListVC") as? ClubUnionListViewController else {
                return
            }
            vc.clubType = 3
            subViewControllers = [vc]
        default:
            return
        }
    }
    
    // 스크롤식의 페이징설정
    required init?(coder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
}
