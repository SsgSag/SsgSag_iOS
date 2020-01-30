//
//  ClubReviewViewController.swift
//  SsgSag
//
//  Created by 남수김 on 2020/01/28.
//  Copyright © 2020 wndzlf. All rights reserved.
//

import UIKit
import RxSwift

class ClubReviewViewController: UIViewController {
    let tabViewModel = ClubDetailViewModel.shared
    var disposeBag: DisposeBag!
    var reviewDataSet: [ReviewCellInfo] = []
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var normalReviewTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        disposeBag = DisposeBag()
        bind()
        self.normalReviewTableView.dataSource = self
        self.normalReviewTableView.estimatedRowHeight = 400
        self.normalReviewTableView.rowHeight = UITableView.automaticDimension
        
//        self.normalReviewTableView.frame.size.height = self.normalReviewTableView.contentSize.height
        
        print("size - \(self.normalReviewTableView.contentSize)")
    }
    
    func bind() {
        self.tabViewModel.reviewDataSet
        .filter { $0 != nil }
        .map { $0 }
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] data in
            guard data != nil else {return}
            self?.reviewDataSet.removeAll()
            data?.forEach { self?.reviewDataSet.append(ReviewCellInfo(data: $0))
                self?.reviewDataSet.append(ReviewCellInfo(data: $0))
                self?.reviewDataSet.append(ReviewCellInfo(data: $0))
                self?.reviewDataSet.append(ReviewCellInfo(data: $0))
                self?.reviewDataSet.append(ReviewCellInfo(data: $0))
            }
            self?.normalReviewTableView.reloadData()
        })
        .disposed(by: disposeBag)
    }
    
    @objc func moreViewSelect(sender: UIButton) {
        self.reviewDataSet[sender.tag].onClick = true
        self.normalReviewTableView.reloadData()
        
        
//        self.normalReviewTableView.frame.size.height = self.normalReviewTableView.contentSize.height
//        self.scrollView.contentSize.height = self.normalReviewTableView.contentSize.height + 48 + 48 + 48
//        print("size - \(self.normalReviewTableView.contentSize)")
//        self.view.layoutIfNeeded()
    }
    
    deinit {
        print("memory - review 종료")
    }

}
