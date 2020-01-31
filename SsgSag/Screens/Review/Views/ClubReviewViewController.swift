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
    
    @IBOutlet weak var blogTableHeightLayout: NSLayoutConstraint!
    @IBOutlet weak var reviewTableHeightLayout: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var normalReviewTableView: UITableView!
    @IBOutlet weak var blogReviewTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        disposeBag = DisposeBag()
        bind()
        self.normalReviewTableView.dataSource = self
        self.normalReviewTableView.estimatedRowHeight = 428
        self.normalReviewTableView.rowHeight = UITableView.automaticDimension
        
        self.blogReviewTableView.dataSource = self
        let nibCell = UINib(nibName: "BlogReviewTableViewCell", bundle: nil)
        self.blogReviewTableView.register(nibCell, forCellReuseIdentifier: "BlogReviewCell")
        self.blogReviewTableView.estimatedRowHeight = 428
        self.normalReviewTableView.rowHeight = UITableView.automaticDimension
        
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
            
            self?.reviewTableHeightLayout.constant = CGFloat.greatestFiniteMagnitude
            self?.normalReviewTableView.reloadData()
            self?.view.layoutIfNeeded()
            self?.reviewTableHeightLayout.constant = self?.normalReviewTableView.contentSize.height ?? 428
            
            // 나중에 블로그 통신코드에 넣어주기
            self?.blogTableHeightLayout.constant = CGFloat.greatestFiniteMagnitude
            self?.blogReviewTableView.reloadData()
            self?.view.layoutIfNeeded()
            self?.blogTableHeightLayout.constant = self?.blogReviewTableView.contentSize.height ?? 428

        })
        .disposed(by: disposeBag)
    
    }
    
    @objc func moreViewSelect(sender: UIButton) {
        self.reviewDataSet[sender.tag].onClick = true
        self.reviewTableHeightLayout.constant = CGFloat.greatestFiniteMagnitude
        self.normalReviewTableView.reloadData()
        self.view.layoutIfNeeded()
        self.reviewTableHeightLayout.constant = self.normalReviewTableView.contentSize.height
    }
    
    @IBAction func moreReviewClick(_ sender: UIButton) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "MoreReviewVC") as! MoreReviewViewController
        let type: ReviewType = sender.tag == 1 ? .SsgSag : .Blog
        nextVC.vcType = type
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    deinit {
        print("memory - review 종료")
    }

}
