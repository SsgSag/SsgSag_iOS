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
    var tabViewModel: ClubDetailViewModel!
    var disposeBag: DisposeBag!
    var reviewDataSet: [ReviewCellInfo] = []
    
    @IBOutlet weak var emptyBlogView: UIView!
    @IBOutlet weak var emptyReviewView: UIView!
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
            .compactMap{ $0 }
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] data in
            
            //포스트데이터만체크
            if data.isEmpty {
                self?.emptyReviewView.isHidden = false
            } else {
                self?.emptyReviewView.isHidden = true
            }
            self?.reviewDataSet.removeAll()
//            data?.forEach {
//                self?.reviewDataSet.append(ReviewCellInfo(data: $0))
//                self?.reviewDataSet.append(ReviewCellInfo(data: $0))
//                self?.reviewDataSet.append(ReviewCellInfo(data: $0))
//                self?.reviewDataSet.append(ReviewCellInfo(data: $0))
//                self?.reviewDataSet.append(ReviewCellInfo(data: $0))
//            }
            
            
            self?.reviewTableHeightLayout.constant = CGFloat.greatestFiniteMagnitude
            self?.normalReviewTableView.reloadData()
            self?.view.layoutIfNeeded()
            if let contentSize = self?.normalReviewTableView.contentSize.height {
                self?.reviewTableHeightLayout.constant = contentSize == 0 ? 428 : contentSize
            }
            
            
            // 나중에 블로그 통신코드에 넣어주기
            //블로그데이터만체크
//            self?.emptyBlogView.isHidden = true
            self?.blogTableHeightLayout.constant = CGFloat.greatestFiniteMagnitude
            self?.blogReviewTableView.reloadData()
            self?.view.layoutIfNeeded()
            if let contentSize = self?.blogReviewTableView.contentSize.height {
                self?.blogTableHeightLayout.constant = contentSize == 0 ? 428 : contentSize
            }
            
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
    
    @IBAction func registerReview(_ sender: Any) {
        guard let navigationVC = self.storyboard?.instantiateViewController(withIdentifier: "ReviewPrepareVC") as? UINavigationController else {return}
        guard let nextVC = navigationVC.topViewController as? ReviewPrepareViewController else {return}
        guard let clubInfo = try? tabViewModel.clubInfoData.value() else {return}
        let type: ClubType = clubInfo.clubType == 0 ? .Union : .School
        let clubactInfo = ClubActInfoModel(clubType: type)
        nextVC.isExistClub = true
        clubactInfo.isExistClub = true
        clubactInfo.clubName = clubInfo.clubName
        clubactInfo.clubIdx = clubInfo.clubIdx
        let location = clubInfo.univOrLocation
        clubactInfo.location.accept(location)
        
        nextVC.clubactInfo = clubactInfo
        
        self.present(navigationVC, animated: true)
    }
    
    @IBAction func registerBlog(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterBlogReviewVC") else {return}
        
        self.present(nextVC, animated: true)
    }
    
    deinit {
        print("memory - review 종료")
    }

}
