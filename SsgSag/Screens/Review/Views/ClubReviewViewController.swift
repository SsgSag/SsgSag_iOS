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
    
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var emptyBlogView: UIView!
    @IBOutlet weak var emptyReviewView: UIView!
    @IBOutlet weak var blogTableHeightLayout: NSLayoutConstraint!
    @IBOutlet weak var reviewTableHeightLayout: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var normalReviewTableView: UITableView!
    @IBOutlet weak var blogReviewTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshResizeTableView), name: NSNotification.Name(rawValue: "resizeTableView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reviewEdit(_:)), name: NSNotification.Name(rawValue: "reviewEdit"), object: nil)
        
        
        disposeBag = DisposeBag()
        tableViewSetup()
        bind()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func tableViewSetup() {
        normalReviewTableView.dataSource = self
        normalReviewTableView.delegate = self
        
        normalReviewTableView.estimatedRowHeight = 1500
        normalReviewTableView.rowHeight = UITableView.automaticDimension
        
        blogReviewTableView.dataSource = self
        let nibCell = UINib(nibName: "BlogReviewTableViewCell", bundle: nil)
        blogReviewTableView.register(nibCell, forCellReuseIdentifier: "BlogReviewCell")
        blogReviewTableView.estimatedRowHeight = 1500
        normalReviewTableView.rowHeight = UITableView.automaticDimension
        
    }
    
    func bind() {
        self.reviewCountLabel.text = "\(tabViewModel.reviewCount)"
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
            data.forEach {
                self?.reviewDataSet.append(ReviewCellInfo(data: $0))
            }
            
            
            self?.reviewTableHeightLayout.constant = CGFloat.greatestFiniteMagnitude
            self?.normalReviewTableView.reloadData()
            self?.view.layoutIfNeeded()
            if let contentSize = self?.normalReviewTableView.contentSize.height {
                self?.reviewTableHeightLayout.constant = contentSize == 0 ? 428 : contentSize
            }
        })
        .disposed(by: disposeBag)
    
        // 나중에 블로그 통신코드에 넣어주기
                    //블로그데이터만체크
        ////            self?.emptyBlogView.isHidden = true
        //            self?.blogTableHeightLayout.constant = CGFloat.greatestFiniteMagnitude
        //            self?.blogReviewTableView.reloadData()
        //            self?.view.layoutIfNeeded()
        //            if let contentSize = self?.blogReviewTableView.contentSize.height {
        //                self?.blogTableHeightLayout.constant = contentSize == 0 ? 428 : contentSize
        //            }
    }
    
    @objc func refreshResizeTableView() {
        
        self.normalReviewTableView.beginUpdates()
        self.reviewTableHeightLayout.constant = CGFloat.greatestFiniteMagnitude
        
        self.reviewTableHeightLayout.constant = self.normalReviewTableView.contentSize.height
        self.normalReviewTableView.endUpdates()
        
    }
    
    @objc func reviewEdit(_ notification: Notification) {
        let editAction = UIAlertAction(title: "수정", style: .default) { _ in
            guard let reveiwInfo = notification.object as? ReviewInfo else {return}
            guard let clubInfo = try? self.tabViewModel.clubInfoData.value() else {return}
            let clubIdx = clubInfo.clubIdx
            let type: ClubType = clubInfo.clubType == 0 ? .Union : .School
            guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ReviewEditVC") as? ReviewEditViewController else {return}
            nextVC.reviewService = ReviewService()
            nextVC.clubService = ClubService()
            nextVC.reviewEditViewModel = ReviewEditViewModel(model: reveiwInfo)
            
            let clubactInfo = ClubActInfoModel(clubType: type)
            clubactInfo.clubIdx = clubIdx
            clubactInfo.clubName = clubInfo.clubName
            clubactInfo.location.accept(clubInfo.univOrLocation)
            clubactInfo.isExistClub = true
            nextVC.clubactInfo = clubactInfo
            
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        let deleteAction = UIAlertAction(title: "삭제", style: .default) { _ in
            
        }
        let reportAction = UIAlertAction(title: "신고", style: .default) { _ in
            
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        self.simpleActionSheet(title: "하실 작업을 선택해주세요.", actions: [editAction, deleteAction, reportAction, cancelAction])
        
        
    }
    
    
    @objc func moreViewSelect(sender: UIButton) {
        self.reviewDataSet[sender.tag].onClick = true
        
    }
    
    @IBAction func moreReviewClick(_ sender: UIButton) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "MoreReviewVC") as! MoreReviewViewController
        let type: ReviewType = sender.tag == 1 ? .SsgSag : .Blog
        nextVC.vcType = type
        guard let clubInfo = try? tabViewModel.clubInfoData.value() else {return}
        nextVC.clubInfo = clubInfo
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
