//
//  ReviewMainViewController.swift
//  SsgSag
//
//  Created by 남수김 on 2020/01/23.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit
import RxSwift

class ReviewMainViewController: UIViewController {
    
    @IBOutlet weak var tabCollectionView: UICollectionView!
    
    typealias TabModel = ReviewTabCellModel
    var tabTitle = [ TabModel(title: "동아리 후기", onFocus: true),
                     TabModel(title: "대외활동 후기", onFocus: false),
                     TabModel(title: "인턴 후기", onFocus: false)
                    ]
    var reviewPageInstance: ReviewPageViewController!
    var focusIndex: BehaviorSubject<Int> = BehaviorSubject<Int>(value: 0)
    var curIndex = 0
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabCollectionView.dataSource = self
        self.tabCollectionView.delegate = self
        self.tabCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .left)
        bindData()
        
    }
    
    func bindData() {
        let sub = reviewPageInstance.subViewControllers
        
        focusIndex.subscribe(onNext: { index in
            guard self.curIndex != index else { return }
            
            let direction: UIPageViewController.NavigationDirection! = self.curIndex < index ? .forward : .reverse
            self.reviewPageInstance.setViewControllers([sub[index]], direction: direction , animated: true, completion: nil)
            self.curIndex = index
            })
        .disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ReviewPageSegue" {
            self.reviewPageInstance = segue.destination as? ReviewPageViewController
            reviewPageInstance.pageDelegate = self
        }
    }
}
